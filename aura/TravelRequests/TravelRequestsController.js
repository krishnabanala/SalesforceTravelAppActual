({
	editTravelReqCtrl : function(component, event, helper) {
        var tabArr = document.getElementsByClassName('slds-tabs--default__item');
        var tabArrLen = tabArr.length;
        for(var i = 0 ; i < tabArrLen ; i++){ 
            tabArr[i].className = 'slds-tabs--default__item slds-text-heading--label';
        }
        document.getElementById('travelReqFormTabliId').className = 'slds-tabs--default__item slds-text-heading--label slds-active';
        
        var tabArrContent = document.getElementsByClassName('slds-tabs--default__content');
        var tabArrContentLen = tabArr.length;
        for(var i = 0 ; i < tabArrContentLen ; i++){
            tabArrContent[i].className = 'slds-tabs--default__content slds-hide';
        }
        document.getElementById('tab-default-3').className = 'slds-tabs--default__content slds-show';
        
        var editRecordEvt = $A.get("e.c:EditTravelReq");
        editRecordEvt.setParams({ "travelReqId" : event.currentTarget.getAttribute('id')});
        debugger;
        editRecordEvt.fire();
    },    
    submitApprovTravelReqCtrl : function(component, event, helper) {
    	helper.submitApprovTravelReqHelper(component, event);		
	}
})