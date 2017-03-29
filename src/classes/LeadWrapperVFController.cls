public with sharing class LeadWrapperVFController {

  /*
     controller class for VF page
   */

  public List<LeadWrapper> leadWrapperList {get; set;}
  public List<LeadWrapper> returnedList {get; set;}

  LeadWrapperIterable leadWrapperIterable;

  public LeadWrapperVFController() {
    leadWrapperList = new List<LeadWrapper>();

    List<Lead> leadList = new List<Lead>();
    Integer leftQuota = 0;

    /*
       query Leads separately for 3 times to make sure we have the general sorting correct (in case the first 10000 Leads all happend to be `Low` priority)

       p.s. Though the requirements can be achieved by using StandardSetController (use 3 queries to get `High`, `Medium` and `Low` priority Leads and sort them based on
       `AnnualRevenue` and `Name` respectively, merge these 3 list into one list with order, and initialize StandardSetController with this merged list of Leads), we
       chose to use Wrapper class instead, just because it can handle more complex sorting via Comparable interface;
     */

    List<Lead> leadHighList = [SELECT Id, Name, Priority__c, AnnualRevenue FROM Lead WHERE Priority__c = 'High' LIMIT 10000];

    leadList.addAll(leadHighList);
    leftQuota = 10000 - leadHighList.size();

    if(leftQuota > 0) {
      List<Lead> leadMediumList = [SELECT Id, Name, Priority__c, AnnualRevenue FROM Lead WHERE Priority__c = 'Medium' LIMIT 10000];
      leadList.addAll(leadMediumList);
      leftQuota = leftQuota - leadMediumList.size();

      if(leftQuota > 0) {
        List<Lead> leadLowList = [SELECT Id, Name, Priority__c, AnnualRevenue FROM Lead WHERE Priority__c = 'Low' LIMIT 10000];
        leadList.addAll(leadLowList);
      }
    }

    for(Lead l : leadList) {
      leadWrapperList.add(new LeadWrapper(l));
    }

    leadWrapperIterable = new LeadWrapperIterable(leadWrapperList);
    next();
  }

  public Boolean hasNext {
    get {
      return leadWrapperIterable.hasNext();
    }
    set;
  }

  public Boolean hasPrevious {
    get {
      return leadWrapperIterable.hasPrevious();
    }
    set;
  }

  public void next(){
    returnedList = leadWrapperIterable.next();
  }

  public void previous(){
    returnedList = leadWrapperIterable.previous();
  }

}
