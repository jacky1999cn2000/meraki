@isTest
private class TestTakeHomeChallengeController {

	/*
    * @scenario: verify users with different profiles and permission sets have correct access to certain Apex Class and VF Page
		1. user with System Administrator Profile has access to "TakeHomeChallenge" VF and "TakeHomeChallengeController" Apex Class
		2. user with Standard User Profile NOT have access to "TakeHomeChallenge" VF and "TakeHomeChallengeController" Apex Class
		3. user with TakeHomeChallenge permission set has access to "TakeHomeChallenge" VF and "TakeHomeChallengeController" Apex Class
  */
	@isTest static void access_test() {
		Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		// create users with different profiles
		User adminUser = TestUtils.createTestUser('adminUser',adminProfile.Id);
		User stdUser = TestUtils.createTestUser('stdUser',stdUserProfile.Id);
		User stdUserWithPermissionSet = TestUtils.createTestUser('stdUserWithPermissionSet',stdUserProfile.Id);

		List<User> userList = new List<User>();
		userList.add(adminUser);
		userList.add(stdUser);
		userList.add(stdUserWithPermissionSet);
		insert userList;

		// assign 'TakeHomeChallenge' PermissionSet to User 'stdUserWithPermissionSet'
		PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'TakeHomeChallenge'];
		PermissionSetAssignment psa = TestUtils.assignPermissionSet(stdUserWithPermissionSet.Id, ps.Id);
		insert psa;

		List<SetupEntityAccess> adminUserSEAList_ApexPage;
		List<SetupEntityAccess> adminUserSEAList_ApexClass;
		List<SetupEntityAccess> stdUserSEAList_ApexPage;
		List<SetupEntityAccess> stdUserSEAList_ApexClass;
		List<SetupEntityAccess> stdUserWithPermissionSetSEAList_ApexPage;
		List<SetupEntityAccess> stdUserWithPermissionSetSEAList_ApexClass;

		Test.startTest();

		System.runAs(adminUser){
			adminUserSEAList_ApexPage = [SELECT Id FROM SetupEntityAccess WHERE Parent.Profile.Id = :UserInfo.getProfileId() AND SetupEntityId in (SELECT Id FROM ApexPage WHERE Name = 'TakeHomeChallenge' AND NamespacePrefix = null)];
			adminUserSEAList_ApexClass = [SELECT Id FROM SetupEntityAccess WHERE Parent.Profile.Id = :UserInfo.getProfileId() AND SetupEntityId in (SELECT Id FROM ApexClass WHERE Name = 'TakeHomeChallengeController' AND NamespacePrefix = null)];
		}

		System.runAs(stdUser){
			stdUserSEAList_ApexPage = [SELECT Id FROM SetupEntityAccess WHERE Parent.Profile.Id = :UserInfo.getProfileId() AND SetupEntityId in (SELECT Id FROM ApexPage WHERE Name = 'TakeHomeChallenge' AND NamespacePrefix = null)];
			stdUserSEAList_ApexClass = [SELECT Id FROM SetupEntityAccess WHERE Parent.Profile.Id = :UserInfo.getProfileId() AND SetupEntityId in (SELECT Id FROM ApexClass WHERE Name = 'TakeHomeChallengeController' AND NamespacePrefix = null)];
		}

		System.runAs(stdUserWithPermissionSet){
			stdUserWithPermissionSetSEAList_ApexPage = [SELECT Id FROM SetupEntityAccess WHERE ParentId In (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()) AND SetupEntityId in (SELECT Id FROM ApexPage WHERE Name = 'TakeHomeChallenge' AND NamespacePrefix = null)];
			stdUserWithPermissionSetSEAList_ApexClass = [SELECT Id FROM SetupEntityAccess WHERE ParentId In (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()) AND SetupEntityId in (SELECT Id FROM ApexClass WHERE Name = 'TakeHomeChallengeController' AND NamespacePrefix = null)];
		}

		Test.stopTest();

		// verify access
		System.assertEquals(adminUserSEAList_ApexPage.size(), 1);
		System.assertEquals(adminUserSEAList_ApexClass.size(), 1);
		System.assertEquals(stdUserSEAList_ApexPage.size(), 0);
		System.assertEquals(stdUserSEAList_ApexClass.size(), 0);
		System.assertEquals(stdUserWithPermissionSetSEAList_ApexPage.size(), 1);
		System.assertEquals(stdUserWithPermissionSetSEAList_ApexClass.size(), 1);
	}

	/*
    * @scenario: verify StandardSetController works correctly (return correct number of records with accurate order)
  */
	@isTest static void controller_test() {
		Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		Profile stdUserProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

		// create users with different profiles
		User adminUser = TestUtils.createTestUser('adminUser',adminProfile.Id);
		User stdUser1 = TestUtils.createTestUser('stdUser1',stdUserProfile.Id);
		User stdUser2 = TestUtils.createTestUser('stdUser2',stdUserProfile.Id);

		List<User> userList = new List<User>();
		userList.add(adminUser);
		userList.add(stdUser1);
		userList.add(stdUser2);
		insert userList;

		// assign 'TakeHomeChallenge' PermissionSet to standard users
		PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'TakeHomeChallenge'];
		PermissionSetAssignment psa1 = TestUtils.assignPermissionSet(stdUser1.Id, ps.Id);
		PermissionSetAssignment psa2 = TestUtils.assignPermissionSet(stdUser2.Id, ps.Id);

		List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
		psaList.add(psa1);
		psaList.add(psa2);
		insert psaList;

		Test.startTest();

		List<UserClickTracker__c> uctList = new List<UserClickTracker__c>();

		// click the button user by user and verify data
		System.runAs(stdUser1){
			uctList.clear();
			PageReference pageRef = Page.TakeHomeChallenge;
			Test.setCurrentPage(pageRef);
			TakeHomeChallengeController controller = new TakeHomeChallengeController();
			controller.userClick();
			controller.userClick();

			while(true){
				uctList.addAll(controller.getUserClickTrackers());
				if(!controller.setCon.getHasNext()){
					break;
				}else{
					controller.setCon.next();
				}
			}

			System.assertEquals(uctList.size(), 2);
			System.assertEquals(uctList[0].Clicked_By__c, stdUser1.Id);
			System.assertEquals(uctList[1].Clicked_By__c, stdUser1.Id);
		}

		TestUtils.sleep(1000);

		System.runAs(stdUser2){
			uctList.clear();
			PageReference pageRef = Page.TakeHomeChallenge;
			Test.setCurrentPage(pageRef);
			TakeHomeChallengeController controller = new TakeHomeChallengeController();
			controller.userClick();
			controller.userClick();

			while(true){
				uctList.addAll(controller.getUserClickTrackers());
				if(!controller.setCon.getHasNext()){
					break;
				}else{
					controller.setCon.next();
				}
			}

			System.assertEquals(uctList.size(), 4);
			System.assertEquals(uctList[0].Clicked_By__c, stdUser2.Id);
			System.assertEquals(uctList[1].Clicked_By__c, stdUser2.Id);
			System.assertEquals(uctList[2].Clicked_By__c, stdUser1.Id);
			System.assertEquals(uctList[3].Clicked_By__c, stdUser1.Id);
		}

		TestUtils.sleep(1000);

		System.runAs(adminUser){
			uctList.clear();
			PageReference pageRef = Page.TakeHomeChallenge;
			Test.setCurrentPage(pageRef);
			TakeHomeChallengeController controller = new TakeHomeChallengeController();
			controller.userClick();
			controller.userClick();

			while(true){
				uctList.addAll(controller.getUserClickTrackers());
				if(!controller.setCon.getHasNext()){
					break;
				}else{
					controller.setCon.next();
				}
			}

			System.assertEquals(uctList.size(), 6);
			System.assertEquals(uctList[0].Clicked_By__c, adminUser.Id);
			System.assertEquals(uctList[1].Clicked_By__c, adminUser.Id);
			System.assertEquals(uctList[2].Clicked_By__c, stdUser2.Id);
			System.assertEquals(uctList[3].Clicked_By__c, stdUser2.Id);
			System.assertEquals(uctList[4].Clicked_By__c, stdUser1.Id);
			System.assertEquals(uctList[5].Clicked_By__c, stdUser1.Id);
		}

		Test.stopTest();
	}

}
