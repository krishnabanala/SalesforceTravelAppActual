public class ApprovalWrapper{
      
        @AuraEnabled
        public Decimal sAmt {get;set;}
        @AuraEnabled
        public String sSource {get;set;} 
        @AuraEnabled
        public String sDestination {get;set;}
        @AuraEnabled
        public String sWrkItmId {get;set;}
        @AuraEnabled
        public String sStatus{get;set;}
        
        public ApprovalWrapper(Decimal sAmt, String sSource, String sDestination, String sWrkItmId, String sStatus){
            this.sAmt = sAmt;
            this.sSource = sSource;
            this.sDestination = sDestination;
            this.sWrkItmId = sWrkItmId;
            this.sStatus = sStatus;
            
        }
        
    }