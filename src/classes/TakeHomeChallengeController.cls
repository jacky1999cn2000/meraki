public with sharing class TakeHomeChallengeController {

	/* properties used for pagination */
	public Integer noOfRecords{ get; set; }
  public Integer size{ get; set; }

	/* StandardSetController for pagination */
	public ApexPages.StandardSetController setCon {
		get{
			if(setCon == null){
				size = 5;
				String queryString = 'SELECT Id, Name, Clicked_By__c, Clicked_By__r.Name, TimeStamp__c FROM UserClickTracker__c ORDER BY CreatedDate DESC';
				setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
				setCon.setPageSize(size);
				noOfRecords = setCon.getResultSize();
			}

			return setCon;
		}
		set;
	}

	/*
		get function for UserClickTracker records
	*/
	public List<UserClickTracker__c> getUserClickTrackers(){
		List<UserClickTracker__c> uctList = new List<UserClickTracker__c>();
		if(setCon != null){
			for(UserClickTracker__c uct : (List<UserClickTracker__c>)setCon.getRecords())
				uctList.add(uct);
		}

		return uctList;
	}

	/*
		add an UserClickTracker__c record when user click the button
	*/
	public pageReference userClick(){

		DateTime dateTimeNow = dateTime.now();
		String unixTime = ''+dateTimeNow.getTime()/1000;

		UserClickTracker__c uct = new UserClickTracker__c();
		uct.Clicked_By__c = UserInfo.getUserId();
		uct.TimeStamp__c = unixTime;

		insert uct;

		setCon = null;
    getUserClickTrackers();
    setCon.setPageNumber(1);
		return null;
	}

}
