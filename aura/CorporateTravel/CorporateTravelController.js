({ 	
    doInit : function(component, event, helper) { 
        //Sample Comment1 From cloud9   
        helper.getTravelRequestsHelper(component);
        //helper.getApprovalRequestsHelper(component);
    },
    approvalSubmittedEvtHndlr : function(component, event, helper) {
        window.scrollTo(0,0);
        component.set("v.displayMsg", "msgTrue");
        setTimeout(function(){ component.set("v.displayMsg", "msgFalse"); }, 3000);
        helper.getTravelRequestsHelper(component);
    },
    travelRequestsTabClick : function(component, event, helper) {
        helper.tabClick(component, event, event.currentTarget.getAttribute('aria-controls'));
		helper.getTravelRequestsHelper(component);        
    },
    approvalsTabClick : function(component, event, helper) {
        helper.tabClick(component, event, event.currentTarget.getAttribute('aria-controls'));
		helper.getApprovalRequestsHelper(component);        
    },
    newTravelReqCtrl : function(component, event, helper) { 
		helper.tabClick(component, event, 'tab-default-3');
        var editRecordEvt = $A.get("e.c:EditTravelReq");
        editRecordEvt.setParams({ "travelReqId" : "None"});
        editRecordEvt.fire(); 
    },
    approvRejCtrlOpen : function(component, event, helper) {
        var modalArr = document.getElementsByClassName('slds-modal');
		modalArr[0].className = 'slds-modal slds-fade-in-open';
		var modalBackDropArr = document.getElementsByClassName('slds-backdrop');
		modalBackDropArr[0].className = 'slds-backdrop slds-backdrop--open';
		component.set("v.curApprovalId", event.currentTarget.getAttribute('id'));  
    },
	
	approveRejModalClose : function(component, event, helper) {
        var modalArr = document.getElementsByClassName('slds-modal slds-fade-in-open');
		modalArr[0].className = 'slds-modal';
		var modalBackDropArr = document.getElementsByClassName('slds-backdrop slds-backdrop--open');
		modalBackDropArr[0].className = 'slds-backdrop'; 
    },
	approveCtrl : function(component, event, helper) {
        helper.approvRejCtrlHelper(component, component.get("v.curApprovalId"), 'Approve');
    },
	rejectCtrl : function(component, event, helper) {
        helper.approvRejCtrlHelper(component, component.get("v.curApprovalId"), 'Reject');
    },
	showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component, event, helper) {
       var spinner = component.find('spinner');
       var evt = spinner.get("e.toggle");
       evt.setParams({ isVisible : false });
       evt.fire();    
    },
    ErrorEvtHndlr : function (component, event, helper) {
       debugger;
       component.set("v.displayErrorMsg", "msgTrue");
       component.set("v.ErrorMsg", event.getParam("ErrorMsg"));
       setTimeout(function(){ component.set("v.displayErrorMsg", "msgFalse"); }, 10000);
    }
})