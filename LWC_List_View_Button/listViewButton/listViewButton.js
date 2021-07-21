/**
 * Created by gerry on 7/20/2021.
 */

import {LightningElement, api} from 'lwc';

export default class ListViewButton extends LightningElement {
	@api listViewIds;

	close(){
		setTimeout(
			function() {
				window.history.back();
			},
			1000
		);
	}
}