/**
 * Created by gerry on 7/11/2021.
 */

import {LightningElement} from 'lwc';

export default class LwcDataAttributes extends LightningElement {
	getDataAttributes(event){
		console.log('This is the data set ::: ' + JSON.stringify(event.target.dataset));
		console.log('This is the data set turtle ::: ' + JSON.stringify(event.target.dataset.turtle));
	}
}