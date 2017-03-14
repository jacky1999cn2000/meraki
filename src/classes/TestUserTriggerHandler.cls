@isTest
private class TestUserTriggerHandler {

	/*
    * @scenario: verify

  */
	@isTest static void handler_test() {
		Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		// create an admin user
		User adminUser = TestUtils.createTestUser('adminUser',adminProfile.Id);
		insert adminUser;

		// create 20 standard users
		List<User> stdUserList = new List<User>();
		for(Integer i = 0; i < 20; i++){
			stdUserList.add(TestUtils.createTestUser('stdUser'+i,stdUserProfile.Id));
		}
		insert stdUserList;

		// assign 'TakeHomeChallenge' PermissionSet to all standard users
 		PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'TakeHomeChallenge'];
		List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();

		for(User stdUser : stdUserList){
			psaList.add(TestUtils.assignPermissionSet(stdUser.Id, ps.Id));
		}
		insert psaList;

		// each standard user click once
		for(User stdUser : stdUserList){
			System.runAs(stdUser){
				PageReference pageRef = Page.TakeHomeChallenge;
				Test.setCurrentPage(pageRef);
				TakeHomeChallengeController controller = new TakeHomeChallengeController();
				controller.userClick();
			}
		}

		List<UserClickTracker__c> uctList = new List<UserClickTracker__c>();

		// verify the initial setup data
		System.runAs(adminUser){
			uctList.clear();
			PageReference pageRef = Page.TakeHomeChallenge;
			Test.setCurrentPage(pageRef);
			TakeHomeChallengeController controller = new TakeHomeChallengeController();

			while(true){
				uctList.addAll(controller.getUserClickTrackers());
				if(!controller.setCon.getHasNext()){
					break;
				}else{
					controller.setCon.next();
				}
			}

			System.assertEquals(uctList.size(), 20);
		}


		Test.startTest();
		// deactivate 10 standard users
		for(Integer i = 0; i < 10; i++){
			stdUserList[i].isActive = false;
		}
		update stdUserList;

		Test.stopTest();

		// verify data after trigger 
		System.runAs(adminUser){
			uctList.clear();
			PageReference pageRef = Page.TakeHomeChallenge;
			Test.setCurrentPage(pageRef);
			TakeHomeChallengeController controller = new TakeHomeChallengeController();

			while(true){
				uctList.addAll(controller.getUserClickTrackers());
				if(!controller.setCon.getHasNext()){
					break;
				}else{
					controller.setCon.next();
				}
			}

			System.assertEquals(uctList.size(), 10);
		}
	}

}
