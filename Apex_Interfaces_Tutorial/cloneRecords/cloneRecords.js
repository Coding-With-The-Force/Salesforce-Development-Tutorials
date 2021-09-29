/**
 * Created by gerry on 9/28/2021.
 */

import {LightningElement, api} from 'lwc';
import cloneRecordsController from '@salesforce/apex/CloneRecordsController.cloneRecords';
import cloneRelatedRecordsController from '@salesforce/apex/CloneRecordsController.cloneRelatedRecords';

export default class CloneRecords extends LightningElement {
	@api recordId;
	@api className;

	cloneRecord(){
		cloneRecordsController({"recordId": this.recordId, "className": this.className}).then(()=>{
			console.log('Success');
			this.cloneRelatedRecords();
		});
	}

	cloneRelatedRecords(){
		cloneRelatedRecordsController({"recordId": this.recordId, "className": this.className}).then(()=>{
			console.log('Success');
		});
	}
}