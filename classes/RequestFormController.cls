public with sharing class RequestFormController {
    
    @AuraEnabled
    public static String getInitData(String travelReqId){
        
        List<String> lstTravelTypeOpts =  new List<String>();  
        List<String> lstTravelByOpts = new List<String>(); 
        List<String> lstSourceOpts = new List<String>(); 
        List<String> lstDestinationOpts = new List<String>(); 
        
        lstTravelTypeOpts = getPickListValues('Travel_Type__c');
        lstTravelByOpts = getPickListValues('Travel_By__c');
        
        for(Location__c locRec: [Select Id, Name From Location__c]){
            lstSourceOpts.add(locRec.Name);
            lstDestinationOpts.add(locRec.Name);
        }
        
        Travel_Request__c travReqObj = getTravelRequest(travelReqId);
        TravelReqFormWrapper travelReqFormWrap = new TravelReqFormWrapper(travReqObj, lstTravelTypeOpts, lstTravelByOpts, lstSourceOpts, lstDestinationOpts);
        system.debug('>>>>>>>>>>>>>>>>>> travReqObj : ' + travelReqFormWrap.travReqObj);
        system.debug('>>>>>>>>>>>>>>>>>> lstTravelTypeOpts : ' + travelReqFormWrap.lstTravelTypeOpts);
        return JSON.serialize(travelReqFormWrap);
    }
    
    @AuraEnabled
    public static Travel_Request__c saveTravelRequest(String travelReqJson){
        TravelReqWrapper travelReqWrap = (TravelReqWrapper) JSON.deserialize(travelReqJson, TravelReqWrapper.class);
        system.debug('>>>>>>>>>>>>>>>>>> travelReqWrap : ' + travelReqWrap);
        Travel_Request__c travReqObj = getTravelRequest(travelReqWrap.Id);
        travReqObj.Travel_Type__c = travelReqWrap.Travel_Type;
        travReqObj.Travel_By__c = travelReqWrap.Travel_By;
        //travReqObj.Travel_Date__c = (DateTime)JSON.deserialize(travelReqWrap.Travel_Date.split('\\+')[0] + 'Z', datetime.class);
        String sTravelReqDateTime = travelReqWrap.Travel_Date;
        String[] sTravelReqDateTimeArr = travelReqWrap.Travel_Date.split('T');
        String[] sTravelDateArr = sTravelReqDateTimeArr[0].split('-');
        String[] sTravelTimeArr = sTravelReqDateTimeArr[1].split(':');
        DateTime dtTravelDateTimeGmt = DateTime.newInstance(Integer.valueOf(sTravelDateArr[0]), 
                                                         Integer.valueOf(sTravelDateArr[1]),
                                                         Integer.valueOf(sTravelDateArr[2]),
                                                         Integer.valueOf(sTravelTimeArr[0]),
                                                         Integer.valueOf(sTravelTimeArr[1]),
                                                         0);
        travReqObj.Travel_Date__c = DateTime.newInstance(dtTravelDateTimeGmt.getTime() + UserInfo.getTimeZone().getOffset(system.today()));
        system.debug('>>>>>>>>>>>>>>>>>>>> Travel Date : ' + travReqObj.Travel_Date__c);
        Set<String> setLocNames = new Set<String>();
        setLocNames.add(travelReqWrap.SourceR.Name);
        setLocNames.add(travelReqWrap.DestinationR.Name);
        List<Location__c> lstLoc = [Select Id, Name From Location__c Where Name IN :setLocNames];
        Map<String, Id> mapLocNameVsId = new Map<String, Id>();
        for(Location__c locRec : lstLoc){
            mapLocNameVsId.put(locRec.Name, locRec.Id);
        }
        travReqObj.Source__c = mapLocNameVsId.get(travelReqWrap.SourceR.Name);
        travReqObj.Destination__c = mapLocNameVsId.get(travelReqWrap.DestinationR.Name);
        //travReqObj.Source__c = travelReqWrap.Source;
        //travReqObj.Destination__c = travelReqWrap.Destination;
        travReqObj.Expected_Revenue__c = travelReqWrap.Expected_Revenue;
        travReqObj.Status__c = 'Draft';
        upsert travReqObj;
        system.debug('>>>>>>>>>>>>>>>>>> travReqObj : ' + travReqObj);
        return travReqObj;
    } 
    
    @AuraEnabled
    public static void ApprovalSubmit(String travelReqJson){
        Travel_Request__c travelReqObj = saveTravelRequest(travelReqJson);
        Approval.ProcessSubmitRequest travelApprovalReq = new Approval.ProcessSubmitRequest();
        travelApprovalReq.setComments('Submitting request for approval.');
        travelApprovalReq.setObjectId(travelReqObj.id);
        travelApprovalReq.setSubmitterId(UserInfo.getUserId());
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(travelApprovalReq);
        
        // Verify the result
        System.assert(result.isSuccess());
    }
    
    @AuraEnabled
    public static void SubmitForApprov(String travelReqId){
        Approval.ProcessSubmitRequest travelApprovalReq = new Approval.ProcessSubmitRequest();
        travelApprovalReq.setComments('Submitting request for approval.');
        travelApprovalReq.setObjectId(travelReqId);
        travelApprovalReq.setSubmitterId(UserInfo.getUserId());
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(travelApprovalReq);
        
        // Verify the result
        System.assert(result.isSuccess());
    }
    
    @AuraEnabled
    public static List<Travel_Request__c> getTravelRequests(){
        List<Travel_Request__c> lstTravelRequest = new List<Travel_Request__c>();
        lstTravelRequest = [Select Id, Name, Travel_Type__c, Travel_By__c, Travel_Date__c,
                            Source__r.Name, Destination__r.Name, Expected_Revenue__c, Status__c 
                            From Travel_Request__c 
                            Where CreatedById = :UserInfo.getUserId() Order By LastModifiedDate Desc];
        return lstTravelRequest;
    }
    
    @AuraEnabled
    public static List<ApprovalWrapper> getApprovalRequests(){
        
        List<ProcessInstanceWorkitem> lstWrkitem = [Select Id, ProcessInstanceId, ProcessInstance.TargetObjectId    
                                                    From ProcessInstanceWorkitem Where ProcessInstance.Status = 'Pending' 
                                                    And ActorId = :UserInfo.getUserId() 
                                                    Order By ElapsedTimeInMinutes Desc];
        Set<Id> setWrkItemIds = new Set<Id>();
        for(ProcessInstanceWorkitem itm : lstWrkitem){
            setWrkItemIds.add(itm.ProcessInstance.TargetObjectId);
        }
        Map<Id, Travel_Request__c> mapIdVsTravelReq = new Map<Id, Travel_Request__c>([Select Id, Name, Travel_Type__c, Travel_By__c, Travel_Date__c,
                                                                                      Source__r.Name, Destination__r.Name, Expected_Revenue__c, Status__c 
                                                                                      From Travel_Request__c Where Id IN :setWrkItemIds]);
        
        List<ApprovalWrapper> lstApprovalWrap = new List<ApprovalWrapper>();
        for(ProcessInstanceWorkitem itm : lstWrkitem){
            Travel_Request__c travReqObj = mapIdVsTravelReq.get(itm.ProcessInstance.TargetObjectId);
            lstApprovalWrap.add(new ApprovalWrapper(travReqObj.Expected_Revenue__c, 
                                                    travReqObj.Source__r.Name,
                                                    travReqObj.Destination__r.Name, 
                                                    itm.Id,
                                                    travReqObj.Status__c));
        }
        return lstApprovalWrap;
    }
    
    @AuraEnabled
    public static void approveOrRejectTravelReq(String processInstId, String sAction, String sComments){
            system.debug('>>>>>>>>>>>>>>>>>>>> processInstId : ' +  processInstId);
            system.debug('>>>>>>>>>>>>>>>>>>>> sAction : ' +  sAction);
            system.debug('>>>>>>>>>>>>>>>>>>>> sComments : ' +  sComments);
            Approval.ProcessWorkitemRequest approveReq = new Approval.ProcessWorkitemRequest();
            approveReq.setComments(sComments);
            approveReq.setAction(sAction);
            approveReq.setWorkitemId(processInstId);
            Approval.ProcessResult result =  Approval.process(approveReq);
        
    }
    
    public class TravelReqWrapper{
        public String Id {get;set;}
        public String Name {get;set;}
        public String Travel_Type {get;set;}
        public String Travel_By {get;set;}
        public String Travel_Date {get;set;}
        public LocationWrap SourceR {get;set;}
        public LocationWrap DestinationR {get;set;} 
        public Decimal Expected_Revenue {get;set;}
    }    
    
    public class LocationWrap{
        public String Name {get;set;}
    }
    
    public static List<String> getPickListValues(String sFieldName){
        List<String> lstStrings = new List<String>();
        Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Travel_Request__c.fields.getMap().get(sFieldName).getDescribe();
        List<Schema.PicklistEntry> lstPickListEntry = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListEntryRec : lstPickListEntry)
        {
            lstStrings.add(pickListEntryRec.getValue());
        }   
        return lstStrings;
    }
    
    public static Travel_Request__c getTravelRequest(String travelReqId){
        system.debug('>>>>>>>>>>>>>> travelReqId : ' + travelReqId);
        Travel_Request__c travReqObj;
        if(travelReqId != null && travelReqId != '' && travelReqId != 'None'){
            travReqObj = [Select Id, Name, Travel_Type__c, Travel_By__c, Travel_Date__c,
                          Source__r.Name, Destination__r.Name, Expected_Revenue__c 
                          From Travel_Request__c 
                          Where Id = :travelReqId];
        }
        else{
            travReqObj = new Travel_Request__c();
        }
        return travReqObj;
    }
    
    public class TravelReqFormWrapper{
        public Travel_Request__c travReqObj {get;set;}
        public List<String> lstTravelTypeOpts {get;set;}
        public List<String> lstTravelByOpts {get;set;}
        public List<String> lstSourceOpts {get;set;}
        public List<String> lstDestinationOpts {get;set;}
        
        public TravelReqFormWrapper(Travel_Request__c travReqObj, List<String> lstTravelTypeOpts, List<String> lstTravelByOpts,
                                    List<String> lstSourceOpts, List<String> lstDestinationOpts){
                                        this.travReqObj = travReqObj;
                                        this.lstTravelTypeOpts = lstTravelTypeOpts;
                                        this.lstTravelByOpts = lstTravelByOpts;
                                        this.lstSourceOpts = lstSourceOpts;
                                        this.lstDestinationOpts = lstDestinationOpts;  
                                    }
    }
}