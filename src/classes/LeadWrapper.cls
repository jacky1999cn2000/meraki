global class LeadWrapper implements Comparable {

								/*
								   a wrapper class for Lead, so we can implement Comparable interface to compare text field 
								 */

								/* properties used by this wrapper class for comparison */
								public String name {get; set;}
								public Double revenue {get; set;}
								public String priority {get; set;}

								public LeadWrapper(Lead l){
																name = l.Name;
																revenue = l.AnnualRevenue;
																priority = l.Priority__c;
								}

								/* implements compareTo method */
								public Integer compareTo(Object compareTo) {

																LeadWrapper compareToObj = (LeadWrapper)compareTo;

																if(comparePriority(priority, compareToObj.priority) == 0) {

																								if(compareRevenue(revenue, compareToObj.revenue) == 0) {
																																return compareName(name, compareToObj.name);
																								}else{
																																return compareRevenue(revenue, compareToObj.revenue);
																								}

																}else{
																								return comparePriority(priority, compareToObj.priority);
																}

																return -1;
								}

								/* compare desicription */
								private Integer comparePriority(String priority1, String priority2){
																Integer rank1 = priority1.toUpperCase().contains('HIGH') ? 3 : ( priority1.toUpperCase().contains('MEDIUM') ? 2 : 1 );
																Integer rank2 = priority2.toUpperCase().contains('HIGH') ? 3 : ( priority2.toUpperCase().contains('MEDIUM') ? 2 : 1 );

																if(rank1 == rank2) return 0;
																if(rank1 > rank2) return 1;
																return -1;
								}

								/* compare revenue */
								private Integer compareRevenue(Double rev1, Double rev2){
																if(rev1 == rev2) return 0;
																if(rev1 > rev2) return 1;
																return -1;
								}

								/* compare name */
								private Integer compareName(String name1, String name2){
																if(name1.toUpperCase().compareTo(name2.toUpperCase()) == 0) return 0;
																if(name1.toUpperCase().compareTo(name2.toUpperCase()) > 0) return 1;
																return -1;
								}

}
