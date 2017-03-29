# meraki

* **Assignment One**
  * Requirements
    * Add a VisualForce page, featuring a single button.
    * Record the timestamp of each user's click.
    * Delete all the user's click records whenever the user is deactivated.
    * Add unit tests.

  * Solution
    * Classes
      * TakeHomeChallengeController.cls
      * UserTriggerHandler.cls
      * TestTakeHomeChallengeController.cls
      * TestUserTriggerHandler.cls
      * TestUtils.cls
    * Pages
      * TakeHomeChallenge.page
    * Triggers
      * UserTrigger.trigger
    * Tabs
      * TakeHomeChallenge
    * Permission Set
      * TakeHomeChallenge
    * Static Resource
      * css.zip
    * Custom Object
      * UserClickTracker__c

    * Miscellaneous
      * The Organization-Wide Defaults for UserClickTracker__c was set to Public Read/Write;
      * Non System Administrator users assigned with TakeHomeChallenge Permission Set would have access to TakeHomeChallenge.page and TakeHomeChallengeController.cls;
      * Besides the System Administrator user, I created another user called “tuser@jz.com” with Standard User profile and “TakeHomeChallenge” Permission Set for testing purpose, and granted its account login access to System Administrator for a year;
      * I added “0.0.0.0 - 255.255.255.255” IP login range for System Administrator profile to skip Identity Verification;
      * Due to the time limit and the nature of this assignment, when the following code tried to make a future call in trigger handler class, I didn’t handle potential failure situations such as when future call limit was already reached, or when the trigger code was already executed inside a future call.
      * For production code, some industrial robust async architectures should be used to handle all these situations.
      ```
      if(!System.isFuture() && (Limits.getLimitFutureCalls() - Limits.getFutureCalls()) > 0){
        deleteUCTrecords(deactivatedUserIdSet);
      }
      ```
  * Demo
    * ![1.gif](/screenshots/1.gif)
    * ![2.gif](/screenshots/2.gif)

* **Notes**
  * [Add IP whitelist to Profile 1](https://developer.salesforce.com/forums/?id=906F0000000AhIUIA0)
  * [Add IP whitelist to Profile 2](https://help.salesforce.com/articleView?id=login_ip_ranges.htm&type=0&language=en_US)
