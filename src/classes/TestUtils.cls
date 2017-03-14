@isTest
public class TestUtils {

	/*
    * @description: get an unique prefix for username creation
    * @return: a unique string
  */
	private static String getUserNamePrefix(){
    return UserInfo.getOrganizationId() + System.now().millisecond();
  }

	/*
    * @description: create a User with designated parameters
		* @param: userName, used to create username
		* @param: profileId, used to assign profile
    * @return: a User
  */
	public static User createTestUser(String userName, Id profileId){
		String email = userName+'@test.com';
		String uniqueUserName = getUserNamePrefix() + email;
    User u = new User(Alias=userName.left(3), Email=email, UserName=uniqueUserName, EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles');

		return u;
	}

	/*
    * @description: assign a PermissionSet to a User
		* @param: assigneeId, Id of the User
		* @param: psId, Id of the PermissionSet
    * @return: PermissionSetAssignment
  */
	public static PermissionSetAssignment assignPermissionSet(Id assigneeId, Id psId){
		PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = assigneeId, PermissionSetId = psId);
		return psa;
	}

	/*
    * @description: a mockup sleep method
		* @param: milliSeconds, number of milliSeconds the thread need to sleep
    * @return: none
  */
	public static void sleep(Long milliSeconds){
	  Long timeDiff = 0;
	  DateTime firstTime = System.now();
	  do{
    	timeDiff = System.now().getTime() - firstTime.getTime();
	  }while(timeDiff <= milliSeconds);
	}

}
