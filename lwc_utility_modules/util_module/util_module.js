
//DISCLAIMER: There are many different ways available in ES6 JS to export variables, functions and classes
//you can find out more about exports here: https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export

//How to export a variable and make it available when importing your module
//in other components
export const OPEN_STATUS = 'Open';

//How to export a method and make it available when importing your module
//in other components
export function showError(error) {
    return 'This is an error ' + error;
}

//How to export a class and make it available when importing your module
//in other components
export class util_class {

    newStatus = 'New';

    showConsoleLog(){
        console.log('This is the console log ::: ');
    }

}