import { LightningElement, track } from 'lwc';
import getDetails from '@salesforce/apex/AccountIntegrationController.getDetails';
import returnAccounts from '@salesforce/apex/AccountIntegrationController.returnAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const pageSize = 7;   
const columns = [
    {label: 'Name', fieldName : 'name'},
    {label: 'Account Number', fieldName : 'accountNumber', editable : true},
    {label: 'Ticker Symbol', fieldName : 'tickerSymbol', editable : true},
    {label: 'Rating', fieldName : 'rating', editable : true},
    {label: 'Type', fieldName : 'type', editable : true}
];

export default class TableWithAccounts extends LightningElement {

    @track listAcc = [];
    @track isLoading = false;
    @track page = 1;
    @track totalPage;

    detailsPromise = [];
    accountsPromise = [];

    combinedAccounts = [];
    startingRecord = 1;
    endingRecord = 0;
    totalRecordCount;
    columns = columns;

    fildsItemValues = [];




    connectedCallback() {
        this.loadingAccounts();
    }

    loadingAccounts() {
        this.isLoading = true;

        this.accountsPromise = returnAccounts();
        this.detailsPromise = getDetails();
        console.log('result 1+++' + this.detailsPromise);
        console.log('result 1+++' + this.accountsPromise);

        Promise.all([getDetails(), returnAccounts()])
            // async await
            .then(responses => {
                this.detailsPromise = responses[0];
                this.accountsPromise = responses[1];
                console.log('result' + this.detailsPromise);
                console.log('result' + this.accountsPromise);

                responses.forEach(response => {
                    this.combinedAccounts = this.combinedAccounts.concat(response.map(acc => ({
                        Id: acc.Id,
                        name: acc.Name,
                        accountNumber: acc.AccountNumber,
                        rating: acc.Rating,
                        tickerSymbol: acc.TickerSymbol,
                        type: acc.Type
                    })));
                });


                this.totalRecordCount = this.combinedAccounts.length;
                this.totalPage = Math.ceil(this.totalRecordCount/ pageSize);
                this.displayRecordPerPage(this.page);

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Failed to retrieve accounts',
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
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

    handleUpdate(event) {
        this.fildsItemValues = event.detail.draftValues;
        console.log(this.fildsItemValues);
    }
    
}
