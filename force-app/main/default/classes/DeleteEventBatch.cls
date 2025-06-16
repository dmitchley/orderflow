global class DeleteEventBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext batchContext) {
        String Query  = 'Select Id, Name From Event__c Where Live__c = true AND END_DATE_TIME__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext batchContext, List<Event__c> eventList) {
        if(!eventList.isEmpty()) {
            List<Database.DeleteResult> deleteResult = Database.delete(eventList);
            for(Database.DeleteResult dr : deleteResult) {
                if(!dr.isSuccess()) {
                    List<Database.Error> errors = dr.getErrors();
                    String errorsInString = String.join(errors,',');
                    TransactionLogHandler.doHandleExceptionWithError(errorsInString, 'DeleteEventBatch');
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext batchContext) {
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setSubject('Batch Processing Complete');
            List<String> toAddress = new List<String>();
            toAddress.add('dylanmitchley1994@gmail.com');
            mail.setToAddresses( toAddress );
            mail.setSenderDisplayName('Dylan Mitchley');
            
          
            
            mail.setHtmlBody('The DeleteEventBatch Batch Processing has been completed! ');
         //   emailList.add(mail);
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});        
    }
}