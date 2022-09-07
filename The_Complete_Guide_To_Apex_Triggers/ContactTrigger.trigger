/**
 * Created by gerry on 9/6/2022.
 */

trigger ContactTrigger on Contact (before update, after update)
{
	if(Trigger.isAfter && Trigger.isInsert){
		System.debug('This ran yea!!!');
	}

	if(Trigger.isBefore && Trigger.isUpdate){
		kewlMethod();
	}

	public static void kewlMethod(){
		for(Contact cont: trigger.new){
			Contact oldContact = Trigger.oldMap.get(cont.Id);
			if(cont.Birthdate != oldContact.Birthdate)
			{
				cont.addError('You can\'t change the birthday sorry bro');
			}
		}
	}
}