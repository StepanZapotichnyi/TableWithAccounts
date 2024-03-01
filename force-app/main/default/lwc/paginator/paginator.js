import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {
    @api page;
    @api totalPage;
    
    handelPrevious(event) {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    handleNext(event) {
        this.dispatchEvent(new CustomEvent('next'));
    }
}