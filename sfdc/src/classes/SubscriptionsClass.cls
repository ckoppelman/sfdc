/**
 * This class is a utility class that contains methods for creating subscriptions.
 * It currently has one method to subscribe hiring managers to their related positions.
 */
public class SubscriptionsClass { 
	/*
	 * For each jobApp, create a chatter subscription for the hiring manager of the associated position
	 * jobApps - the job applications to which the hiring managers should be subscribed.
	 **/
	public static void HiringManagerSubscribeNewPosition(List <Position__c> positions) {
		System.Debug('HiringManagerSubscribeNewPosition: Entering');
		//Create a list of EntitySubscription objects called subscriptions and initialize it to an empty list.
		List<EntitySubscription> subscriptions = new List<EntitySubscription>();
		
		//Loop through positions and:  
		for (Position__c pos : positions) {
			//Create an EntitySubscription object
			EntitySubscription es = new EntitySubscription();
			//Set the ParentId of the EntitySubscription to the id of the current position
		    es.ParentId = pos.Id; 
			//Set the SubscriberId of the EntitySubscription to the id of the hiring manager associated with the position.
			es.SubscriberId = pos.Hiring_Manager__c;
			//Add the EntitySubscription object to the subscriptions list.
			subscriptions.add(es);		
		}
		try {
			Database.insert(subscriptions);
		}
		catch (DMLException dmlEx) {
			//if we get an error because this user is already following this object, it's okay.
			if (dmlEx.getDmlType(0) == statusCode.DUPLICATE_VALUE) {
				System.Debug('HiringManagerSubscribeNewPosition: subscription already exists');
			} else {
				//otherwise we have a more serious error that we need to throw.
				throw dmlEx;
			}
		}
	}
}