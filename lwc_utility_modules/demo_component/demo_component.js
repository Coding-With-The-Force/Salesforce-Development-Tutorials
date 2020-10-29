import { LightningElement } from 'lwc';
import { OPEN_STATUS, showError, util_class} from 'c/util_module';

export default class Demo_component extends LightningElement 
{
    openStatus;
    returnedError;
    newStatus;

    connectedCallback()
    {
        this.openStatus = OPEN_STATUS;
        this.returnedError = showError('Tacos had an error');
        this.newStatus = new util_class().newStatus;
        new util_class().showConsoleLog();
    }
}