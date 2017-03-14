public class UserTriggerHandler {

	/*
    * @description: delete corresponding UserClickTracker__c records for deactivated users
    * @param: newList (Trigger.new) and oldMap (Trigger.newMap)
    * @return: none
  */
	public static void handlerTrigger(List<User> newList, Map<Id, User> oldMap){

		Set<Id> deactivatedUserIdSet = new Set<Id>();

		// get Ids for deactivated users
		for(User u : newList){
			if(u.isActive == false && oldMap.get(u.Id).isActive == true){
				deactivatedUserIdSet.add(u.Id);
			}
		}

		// quick exit if no processing required
		if(deactivatedUserIdSet.size() == 0) return;

		// call future method to perform delete (avoid Mixed DML Error)
		if((Limits.getLimitFutureCalls() - Limits.getFutureCalls()) > 0){
			deleteUCTrecords(deactivatedUserIdSet);
		}
	}

	@future
	public static void deleteUCTrecords(Set<Id> deactivatedUserIdSet){
		// delete related UserClickTracker__c records
		delete [SELECT Id FROM UserClickTracker__c WHERE Clicked_By__c IN : deactivatedUserIdSet];
	}

}
