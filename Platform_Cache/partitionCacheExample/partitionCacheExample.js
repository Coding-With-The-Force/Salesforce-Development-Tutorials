/**
 * Created by gerry on 9/21/2021.
 */

import {LightningElement} from 'lwc';
import retrieveDataCacheController from '@salesforce/apex/PartitionCacheExampleController.retrieveDataCacheController';
import retrieveDataSOQLController from '@salesforce/apex/PartitionCacheExampleController.retrieveDataSOQLController';
import storeDataController from '@salesforce/apex/PartitionCacheExampleController.storeDataController';

export default class PartitionCacheExample extends LightningElement {

	connectedCallback() {
		this.storeData()
	}

	storeData(){
		storeDataController().then(()=>{
			console.log('We stored the data');
		})
	}


	retrieveDataCache(){
		retrieveDataCacheController().then(data =>{
			console.log('This is the data ::: ' + data);
		})
	}

	retrieveDataSOQL(){
		retrieveDataSOQLController().then(data =>{
			console.log('This is the data ::: ' + data);
		})
	}
}