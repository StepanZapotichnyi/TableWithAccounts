import { LightningElement, track } from 'lwc';
import getDetails from '@salesforce/apex/AccountIntegrationController.getDetails';
import patchDetails from '@salesforce/apex/AccountIntegrationController.patchDetails';
import returnAccounts from '@salesforce/apex/AccountIntegrationController.returnAccounts';
import updateReturnAccounts from '@salesforce/apex/AccountIntegrationController.updateReturnAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const pageSize = 7;   
const columns = [
    {label: 'Name', fieldName : 'name'},
    {label: 'Account Number', fieldName : 'accountNumber', editable : true},
    {label: 'Ticker Symbol', fieldName : 'tickerSymbol', editable : true},
    {label: 'Rating', fieldName : 'rating', editable : true},
    {label: 'Type', fieldName : 'type', editable : true},
    {label: 'Org', fieldName : 'org'}
];
export default class TableWithAccounts extends LightningElement {

    @track listAcc = [];
    @track isLoading = false;
    @track page = 1;
    @track totalPage;
    @track draftValues = [];

    returnAccIds = [];
    detailsIds = [];

    combinedAccounts = [];
    startingRecord = 1;
    endingRecord = 0;
    totalRecordCount;
    columns = columns;


    connectedCallback() { 
        this.loadingAccounts();
    }

    loadingAccounts() {
        this.isLoading = true;

        Promise.all([getDetails(), returnAccounts()])
            .then(responses => {
                this.detailsIds = responses[0].map(detail => detail.Id);
                console.log('result DetailsIds' + this.detailsIds);
                
                this.returnAccIds = responses[1].map(account => account.Id);
                console.log('result returnAccIds' + this.returnAccIds);

                responses.forEach(response => {
                    this.combinedAccounts = this.combinedAccounts.concat(response.map(acc => ({
                        Id: acc.Id,
                        name: acc.Name,
                        accountNumber: acc.AccountNumber,
                        rating: acc.Rating,
                        tickerSymbol: acc.TickerSymbol,
                        type: acc.Type,
                        org : this.identifyOrganization(acc.Id)
                    })));
                });


                this.totalRecordCount = this.combinedAccounts.length;
                this.totalPage = Math.ceil(this.totalRecordCount/ pageSize);
                this.displayRecordPerPage(this.page);

            })
            .catch(error => {
                this.showToast('Success', 'Failed to retrieve accounts', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    identifyOrganization(idAccount) {
        return this.detailsIds.includes(idAccount) ? 'Org First' : (this.returnAccIds.includes(idAccount) ? 'Org Second' : 'unknown');
    }

    prevHandel(event) {
        if(this.page > 1) {
            this.page -= 1;
            this.displayRecordPerPage(this.page);
        }
    }

    nextHandel(event) {
        if(this.page < this.totalPage && this.page !== this.totalPage) {
            this.page += 1;
            this.displayRecordPerPage(this.page);
        }
    }

    displayRecordPerPage(page) {
        this.startingRecord = (page - 1) * pageSize;
        this.endingRecord = page * pageSize;
        this.listAcc = this.combinedAccounts.slice(this.startingRecord, this.endingRecord);
    }


    handelSave(event) {
        this.isLoading = true;
        let draftValues = event.detail.draftValues;
        let promisesAll = [];           

        draftValues.forEach(field => {
            if (this.returnAccIds.includes(field.Id)) {
                let returnUpdatedParam = [];
                returnUpdatedParam.push(field);

                if(returnUpdatedParam.length > 0) {
                    promisesAll.push(updateReturnAccounts({accountData : returnUpdatedParam}));
                }
            }
            else if (this.detailsIds.includes(field.Id)) {
                let patchUpdatedParam = [];
                patchUpdatedParam.push(field);
                
                if(patchUpdatedParam.length > 0) {
                    let patchUpdatedParamString = JSON.stringify(patchUpdatedParam);
                    promisesAll.push(patchDetails({accData : patchUpdatedParamString}));
                }
            }
        });
        
        Promise.all(promisesAll)
            .then (result =>  {
                console.log('apex res ' + JSON.stringify(result));
                this.combinedAccounts = [];
                refreshApex(this.loadingAccounts());
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

    handelCancel(event){
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
