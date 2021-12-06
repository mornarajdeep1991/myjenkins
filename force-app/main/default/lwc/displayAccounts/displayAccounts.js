import { LightningElement ,api, wire, track} from 'lwc';
import getAccountWrapperList from '@salesforce/apex/DisplayAccountHierarchyController.fetchAccounts';
//new branch
export default class LightningDatatableLWCExample extends LightningElement {
    @track columns = [{
            /*label: 'Account name',
            fieldName: 'Name',
            type: 'text',
            sortable: true*/
            label: 'Account Name',
            fieldName: 'accName',
            type: 'url',
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}
        },
       /* {
            label: 'Referrer Name',
            fieldName: 'Broker_Name1__c',
            type: 'text'
        },*/
        {
            label: 'Type',
            fieldName: 'Type__c',
            type: 'text'
        },
        {
            label: 'Office',
            fieldName: 'Owner_Office__c',
            type: 'text'
        },
        {
            label: 'IB Name',
            fieldName: 'Broker_Name1__c',
            type: 'text'
        },
        {
            label: 'Funded',
            fieldName: 'IB_Clients_Funded_Account_New__c',
            type: 'checkbox'
        },
        {
            label: 'Net Amount',
            fieldName: 'netAmount',
            type: 'currency',
            sortable: true,
            cellAttributes: { alignment: 'left' }
        }
    ];
 
    @track error;
    @track accWrapperList ;
    @track fromDate;
    @track toDate;
    countFunded = 0;
    countUnfunded = 0;
    subTotal = 0;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;

    @wire(getAccountWrapperList, { fDate: '$fromDate',  tDate: '$toDate'})
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
            let accWrapList = [];
                data.forEach(acct => {
                    console.log('++acct++'+JSON.stringify(acct));
                    let accWrap = {};
                    accWrap.Name = acct.acc.Name;
                    accWrap.accName = '/' + acct.acc.Id;
                  //  accWrap.Broker_Name1__c = acct.acc.Broker_Name1__r.Name;
                    accWrap.Type__c = acct.acc.Type__c;
                    accWrap.Owner_Office__c = acct.acc.Owner_Office__c;
                    accWrap.Broker_Name1__c = acct.acc.Broker_Name1__r.Name;
                    accWrap.Funded_Account_Formula__c = acct.acc.Funded_Account_Formula__c;
                    accWrap.netAmount = acct.netAmount;
                    this.subTotal = this.subTotal + acct.netAmount;
                    //if(acct.acc.Funded_Account_Formula__c){
                    if(acct.netAmount > 0){
                        this.countFunded++;
                    }else{
                        this.countUnfunded++;
                    }
                    if( accWrap.netAmount>0 || accWrap.netAmount<0 )accWrapList.push(accWrap);
                });
                this.accWrapperList = accWrapList;
                console.log('++accList++'+JSON.stringify(this.accWrapperList));
        } else if (error) {
            this.error = error;
        }
    }

    connectedCallback(){
        var today = new Date();
        this.toDate=today.toISOString();
        console.log('++toDate++'+JSON.stringify(this.toDate));
        var fromDate = new Date(new Date().setDate(today.getDate()-30));
        this.fromDate=fromDate.toISOString();
        console.log('++fromDate1++'+JSON.stringify(this.fromDate));
    }

    handleFromDateChange(event){
        this.fromDate = event.target.value;
        getAccountWrapperList({fDate : this.fromDate, tDate : this.toDate})
        .then(result =>{
                this.accWrapperList = null;
                console.log('++this.subTotal+++'+this.subTotal);
                this.countFunded = 0;
                this.countUnfunded = 0;
                this.subTotal = 0;
                console.log('++this.subTotal+++'+this.subTotal);
                let accWrapList = [];
                result.forEach(acct => {
                    console.log('++acct1++'+JSON.stringify(acct));
                    let accWrap = {};
                    accWrap.Name = acct.acc.Name;
                    accWrap.accName = '/' + acct.acc.Id;
                    accWrap.Type__c = acct.acc.Type__c;
                    accWrap.Owner_Office__c = acct.acc.Owner_Office__c;
                    accWrap.Broker_Name1__c = acct.acc.Broker_Name1__r.Name;
                    console.log('++this.subTotal+++'+this.subTotal);
                    console.log('++acc.netAmount+++'+acct.netAmount);
                    accWrap.netAmount = acct.netAmount;
                    this.subTotal = this.subTotal + acct.netAmount;
                    //if(acct.acc.IB_Clients_Funded_Account_New__c){
                    if(acct.netAmount > 0){
                        this.countFunded++;
                    }else{
                        this.countUnfunded++;
                    }
                    if( accWrap.netAmount>0 || accWrap.netAmount<0 )accWrapList.push(accWrap);
                });
                console.log('++this.subTotal+++'+this.subTotal);
                this.subTotal = this.subTotal;
                this.accWrapperList = accWrapList;
                console.log('++accList++'+JSON.stringify(this.accWrapperList));
        })
        .catch(error=>{
            error = JSON.stringify(error);
            console.log('++error++'+JSON.stringify(error));
        })
    }

    handleToDateChange(event){
        this.toDate = event.target.value;
        getAccountWrapperList({fDate : this.fromDate, tDate : this.toDate})
        .then(result =>{
                this.accWrapperList = null;
                console.log('++this.subTotal+++'+this.subTotal);
                this.countFunded = 0;
                this.countUnfunded = 0;
                this.subTotal = 0;
                console.log('++this.subTotal+++'+this.subTotal);
                let accWrapList = [];
                result.forEach(acct => {
                    console.log('++acct++'+JSON.stringify(acct));
                    let accWrap = {};
                    accWrap.Name = acct.acc.Name;
                    accWrap.accName = '/' + acct.acc.Id;
                    accWrap.Type__c = acct.acc.Type__c;
                    accWrap.Owner_Office__c = acct.acc.Owner_Office__c;
                    accWrap.Broker_Name1__c = acct.acc.Broker_Name1__r.Name;
                    console.log('++this.subTotal+++'+this.subTotal);
                    console.log('++acc.netAmount+++'+acct.netAmount);
                    accWrap.netAmount = acct.netAmount;
                    this.subTotal = this.subTotal + acct.netAmount;
                    //if(acct.acc.IB_Clients_Funded_Account_New__c){
                    if(acct.netAmount > 0){
                        this.countFunded++;
                    }else{
                        this.countUnfunded++;
                    }
                    if( accWrap.netAmount>0 || accWrap.netAmount<0 )accWrapList.push(accWrap);
                });
                console.log('++this.subTotal+++'+this.subTotal);
                this.subTotal = this.subTotal;
                this.accWrapperList = accWrapList;
                console.log('++accList++'+JSON.stringify(this.accWrapperList));
        })
        .catch(error=>{
            error = JSON.stringify(error);
            console.log('++error++'+JSON.stringify(error));
        })
    }

    // Used to sort the 'Age' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.accWrapperList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.accWrapperList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    displayTransactions(event) {
        alert('++hello++');
    }
}