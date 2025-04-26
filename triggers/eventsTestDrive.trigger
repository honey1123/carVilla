trigger eventsTestDrive on Test_Drive__c (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handleAfterInsert(Trigger.new);
        }
    }
    
    // Implement logic after inserting records
    //Asumption Only one records will be created, from Agent
    void handleAfterInsert(List<Test_Drive__c> newRecords) {
        if(newRecords.size()>0){
            List<Test_Drive__c> rides= [SELECT Id, Name, Customer_s_request__c, Time_slot__c, Vehicle_Assigned__c, Assigned_Ride_Driver__c,
               Assigned_Ride_Driver__r.Name, 
               Assigned_Ride_Driver__r.Email, 
               Assigned_Guest_For_Ride__c, 
               Assigned_Guest_For_Ride__r.email, 
               Assigned_Guest_For_Ride__r.MobilePhone ,
               Assigned_Guest_For_Ride__r.Name,
               Assigned_Guest_For_Ride__r.Account.BillingStreet,
               Assigned_Guest_For_Ride__r.Account.BillingCity,
               Assigned_Guest_For_Ride__r.Account.BillingState,
               Assigned_Guest_For_Ride__r.Account.BillingPostalCode,
               Assigned_Guest_For_Ride__r.Account.BillingCountry
            FROM Test_Drive__c where id=:newRecords[0].id];
             System.debug('>>>>>'+newRecords[0]);
            //Get Full Address
            String fullAddress =
            (rides[0].Assigned_Guest_For_Ride__r.Account.BillingStreet != null ? rides[0].Assigned_Guest_For_Ride__r.Account.BillingStreet + ', ' : '') +
            (rides[0].Assigned_Guest_For_Ride__r.Account.BillingCity != null ? rides[0].Assigned_Guest_For_Ride__r.Account.BillingCity + ', ' : '') +
            (rides[0].Assigned_Guest_For_Ride__r.Account.BillingState != null ? rides[0].Assigned_Guest_For_Ride__r.Account.BillingState + ' ' : '') +
            (rides[0].Assigned_Guest_For_Ride__r.Account.BillingPostalCode != null ? rides[0].Assigned_Guest_For_Ride__r.Account.BillingPostalCode + ', ' : '') +
            (rides[0].Assigned_Guest_For_Ride__r.Account.BillingCountry != null ? rides[0].Assigned_Guest_For_Ride__r.Account.BillingCountry : '');
            //For user on channel, will need UserId, and will be known in this class
            String DMmessage='👋 Hey <@userId>!, New Test Drive is booked with you!', channelMessage='📣 Public alert: New Test Drive Booking Request Received:';
            String commonMessage = '\n Test Drive Booking Details :<https://carvilla-dev-ed.develop.lightning.force.com/lightning/r/Test_Drive__c/'+
                    newRecords[0].Id+'/view|'+newRecords[0].Name+'>'+
                '\n📅 Preferred Ride Date & Time: '+newRecords[0].Time_slot__c+
                '\n👤 Customer Name: '+rides[0].Assigned_Guest_For_Ride__r.Name+
                '\n📞 Customet Phone: '+rides[0].Assigned_Guest_For_Ride__r.MobilePhone+
                '\n📧 Customer Email: '+rides[0].Assigned_Guest_For_Ride__r.email+
                '\n📍 Customer Address:'+fullAddress+
                '\n🚗Vehicle Specification: '+newRecords[0].Vehicle_Assigned__c+
                '\nAssigned Driver: ' + rides[0].Assigned_Ride_Driver__r.Name;
            System.debug('>>>> 12 >'+rides[0]);
            SlackMessenger.sendSlackNotifications(rides[0].Assigned_Ride_Driver__r.Email, 
                'test-ride-schedule', DMmessage+commonMessage, channelMessage+commonMessage);
            //'jumeirahjaipur@gmail.com': Sample email
        }
    }    
    
}