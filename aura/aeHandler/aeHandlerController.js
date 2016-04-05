({
    doInit : function(component, event, helper) {
        helper.getInitData(component);
    },
    
    handleApplicationEvent : function(cmp, event, helper) {
        debugger;
        cmp.set("v.travelReqId", event.getParam("travelReqId"));
        helper.getInitData(component);
    },
    
    saveTravelRequestCtrl : function(component, event, helper) {
        var newTravelRequest = component.get("v.newTravelRequest");
        helper.saveTravelRequestHelper(component, newTravelRequest);
    },
    
    submitForApproval : function(component, event, helper) {
        var newTravelRequest = component.get("v.newTravelRequest");
        helper.submitForApprovalHelper(component, newTravelRequest);
    }
    
})