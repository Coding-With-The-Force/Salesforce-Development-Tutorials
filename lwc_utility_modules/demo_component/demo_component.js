import { LightningElement } from 'lwc';

//Importing in our javascript utility module. The import variable names (OPEN_STATUS, showError, util_class)
//are the names of the exported variable, method and class in our util_module component
import { OPEN_STATUS, showError, util_class} from 'c/util_module';

export default class Demo_component extends LightningElement 
{
    openStatus;
    returnedError;
    newStatus;

    //The connectedCallback method runs on component load
    connectedCallback()
    {
        //assigning our imported OPEN_STATUS value to our local openStatus variable
        this.openStatus = OPEN_STATUS;

        //assigning our imported showError methods return value to our local returnedError variable 
        this.returnedError = showError('Tacos had an error');

        //assigning our imported class's newStatus variable to our local newStatus variable
        this.newStatus = new util_class().newStatus;

        //Calling our imported class's showConsoleLog method
        new util_class().showConsoleLog();
    }
}