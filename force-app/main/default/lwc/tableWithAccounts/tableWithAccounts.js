import { LightningElement, track } from 'lwc';
import getAccountsFromAnotherOrg from '@salesforce/apex/AccountIntegrationController.getAccountsFromAnotherOrg';
import patchAccountsInAnotherOrg from '@salesforce/apex/AccountIntegrationController.patchAccountsInAnotherOrg';
import getAccountsFromData from '@salesforce/apex/AccountIntegrationController.getAccountsFromData';
import updateAccountsFromData from '@salesforce/apex/AccountIntegrationController.updateAccountsFromData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const PAGE_SIZE = 7;   
const COLUMNS = [
    {label: 'Name', fieldName : 'name'},
    {label: 'Account Number', fieldName : 'accountNumber', editable : true},
    {label: 'Ticker Symbol', fieldName : 'tickerSymbol', editable : true},
    {label: 'Rating', fieldName : 'rating', editable : true},
    {label: 'Type', fieldName : 'type', editable : true},
    {label: 'Org', fieldName : 'org'}
];
export default class TableWithAccounts extends LightningElement {

    @track accountsList = [];
    @track pageNumber = 1;
    @track numberOfPages;
    @track draftValues = [];
    
    accountIdFromData = [];
    accountIdFromAnotherOrg = [];
    
    isLoading = false;
    combinedAccounts = [];
    startingPageIndex = 1;
    endingPageIndex = 0;
    totalRecordCount;
    columns = COLUMNS;


    connectedCallback() { 
        this.loadingAccounts();
    }

    loadingAccounts() {
        this.isLoading = true;

        Promise.all([getAccountsFromAnotherOrg(), getAccountsFromData()])
            .then(responses => {
                this.accountIdFromAnotherOrg = responses[0].map(detail => detail.Id);
                console.log('result accountIdFromAnotherOrg' + this.accountIdFromAnotherOrg);
                
                this.accountIdFromData = responses[1].map(account => account.Id);
                console.log('result accountIdFromData' + this.accountIdFromData);
                
                 responses.forEach(response => {
                        let mappedResponse = response.map(acc => ({
                            Id: acc.Id,
                            name: acc.Name,
                            accountNumber: acc.AccountNumber,
                            rating: acc.Rating,
                            tickerSymbol: acc.TickerSymbol,
                            type: acc.Type,
                            org : this.identifyOrganization(acc.Id)
                        }));
                        this.combinedAccounts = this.combinedAccounts.concat(mappedResponse);
                    });

                this.totalRecordCount = this.combinedAccounts.length;
                this.numberOfPages = Math.ceil(this.totalRecordCount/ PAGE_SIZE);
                this.displayRecordPerPage(this.pageNumber);

            })
            .catch(error => {
                this.showToast('Success', 'Failed to retrieve accounts', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    identifyOrganization(idAccount) {
        return this.accountIdFromAnotherOrg.includes(idAccount) ? 'Org First' : (this.accountIdFromData.includes(idAccount) ? 'Org Second' : 'unknown');
    }

    prevHandel(event) {
        if(this.pageNumber > 1) {
            this.pageNumber -= 1;
            this.displayRecordPerPage(this.pageNumber);
        }
    }

    nextHandel(event) {
        if(this.pageNumber < this.numberOfPages && this.page !== this.numberOfPages) {
            this.pageNumber += 1;
            this.displayRecordPerPage(this.pageNumber);
        }
    }

    displayRecordPerPage(page) {
        this.startingPageIndex = (page - 1) * PAGE_SIZE;
        this.endingPageIndex = page * PAGE_SIZE;
        this.accountsList = this.combinedAccounts.slice(this.startingPageIndex, this.endingPageIndex);
    }


    handleSave(event) {
        let draftValues = event.detail.draftValues;
        let promisesAll = [];           

        draftValues.forEach(field => {
            if (this.accountIdFromData.includes(field.Id)) {
                promisesAll.push(updateAccountsFromData({ accountData: [field] }));
            } else if (this.accountIdFromAnotherOrg.includes(field.Id)) {
                let patchUpdatedParamString = JSON.stringify([field]);
                promisesAll.push(patchAccountsInAnotherOrg({ accData: patchUpdatedParamString }));
            }
        });
        this.handlePromises(promisesAll);
        this.combinedAccounts = [];
        refreshApex(this.loadingAccounts());
    }

    handlePromises(promisesAll) {
        this.isLoading = true;
        
        Promise.all(promisesAll)
        .then (result =>  {
            this.showToast('Success', 'Records Updated Successfully!', 'success');
        })
        .catch (err => {
            console.log('apex err ' + JSON.stringify(err));
            this.showToast('Error', 'Changes not saved!', 'error');
        }) 
        .finally(() => {
            this.isLoading = false;
        });
    }

    handleCancel(event){
        this.draftValues = []; 
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }     

}