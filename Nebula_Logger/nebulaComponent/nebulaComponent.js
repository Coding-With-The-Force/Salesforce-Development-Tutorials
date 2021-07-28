/**
 * Created by gerry on 7/24/2021.
 */

import {LightningElement, api} from 'lwc';
import setNewSession from '@salesforce/apex/NebulaComponent_Controller.setupCache';
import debugLog from '@salesforce/apex/NebulaComponent_Controller.logDebug';
import warnLog from '@salesforce/apex/NebulaComponent_Controller.logWarning';

export default class NebulaComponent extends LightningElement {

	@api recordId

	connectedCallback() {
		setNewSession().then(returnVal =>{
			console.log('Success');
		}).catch(error =>{
			console.log('Error');
		});
	}

	logDebug(){
		debugLog({"recordId": this.recordId}).then(returnVal =>{
			console.log('Success');
		}).catch(error =>{
			console.log('Error');
		});
	}

	logWarning(){
		warnLog({"recordId": this.recordId}).then(returnVal =>{
			console.log('Success');
		}).catch(error =>{
			console.log('Error');
		});
	}

}