public class LocationTriggerHandler {
    
    @future(callout=true)
    public static void verifyAddress(string recordId) {
        Location__c loc = [
            SELECT Id, Name, Street__c, City__c, Postal_Code__c, State__c
            FROM Location__c
            WHERE Id = :recordId
        ];
        
        string baseURL = 'https://api.opencagedata.com/geocode/v1/json?q=';
        String queryString = EncodingUtil.urlEncode(
            loc.Street__c + ', ' + loc.Postal_Code__c + ', ' + loc.City__c + ', ' + loc.State__c + ', South Africa',
            'UTF-8'
        );
        
        baseURL += queryString + '&key=8faa462727874ae09b173be019a493f6';
        
        HttpRequest httpReq = new HttpRequest();
        httpReq.setMethod('GET');
        httpReq.setEndpoint(baseURL);
        httpReq.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        
        try {
            HttpResponse httpRes = http.send(httpReq);
            System.debug(' Response Body '+ httpRes.getBody());
            if (httpRes.getStatusCode() == 200) {
    			String responseBody = httpRes.getBody();

    			// Deserialize the JSON response
    			Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
    			List<Object> results = (List<Object>) result.get('results');

    if (!results.isEmpty()) {
        Map<String, Object> firstResult = (Map<String, Object>) results[0];
        Integer confidence = (Integer) firstResult.get('confidence');
        Map<String, Object> components = (Map<String, Object>) firstResult.get('components');
        
        String returnedRoad = (String) components.get('road');
        String returnedPostcode = (String) components.get('postcode');

        Boolean isMatch = confidence >= 7 &&
                          returnedRoad != null &&
                          returnedPostcode == loc.Postal_Code__c;

        if (isMatch) {
            System.debug('✅ Address match is valid and confidence is high.');
            System.debug('responseBod '+ responseBody);
            loc.Verified__c = true;
             
        } else {
            loc.Verified__c = false;
            System.debug('⚠️ Address confidence too low or mismatch.');
            TransactionLogHandler.doHandleExceptionWithError('Low confidence or partial match from OpenCage', 'LocationTriggerHandler');
        }
        System.debug('responseBod '+ responseBody);
        update loc; /*  */
    }
    else {
        System.debug('❌ No results returned from geocoding API.');
        TransactionLogHandler.doHandleExceptionWithError('No results from OpenCage', 'LocationTriggerHandler');
    }   
}

            
            else {
                TransactionLogHandler.doHandleExceptionWithError(httpRes.getBody(), 'LocationTriggerHandler');
            }
        } catch (System.CalloutException ex) {
            System.debug(' Exception Body '+ ex.getStackTraceString());
            TransactionLogHandler.doHandleException(ex, 'LocationTriggerHandler');
        }
    }
}