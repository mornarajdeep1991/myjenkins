import { LightningElement, track, api } from 'lwc';

export default class ReferrerDetailsModal extends LightningElement {
    @track accountId; 
    @track contactList;
    @track rowOffset = 0;
    @track error;   
    @track btnLabel = '';   
    @track modalHeader = '';
    @track isContact = false;
    @track modalClass = 'slds-modal ';
    @track modalBackdropClass = 'slds-backdrop ';
    @api recordId;  //Stores recordId
    @api objectApiName;   //Stores the current object API Name



      //Adds the classes that shows the Modal and does server calls to show the required data
  openModal() {
    this.modalClass = 'slds-modal slds-fade-in-open';
    this.modalBackdropClass = 'slds-backdrop slds-backdrop_open';
    fetchWrapperData({sObjectId: this.recordId})
      .then(result => {    //Returns the wrapper 
        if(result.accId != null){
          this.accountId = result.accId;
          this.isContact = true;
        }
      })
      .catch(error => {
        const event = new ShowToastEvent({
          title: 'Error Occured',
          message: 'Error: '+error.body.message,
          variant: 'error'
         });
        this.dispatchEvent(event);    //To show an error Taost if error occurred while the APEX call
        });
  }

  //Removes the classes that hides the Modal
  closeModal() {
    this.modalClass = 'slds-modal ';
    this.modalBackdropClass = 'slds-backdrop ';
  }
}