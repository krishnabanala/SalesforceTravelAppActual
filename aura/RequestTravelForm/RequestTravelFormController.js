({
    doInit : function(component, event, helper) {
        helper.getInitData(component);
    },
    
    editTravelReqCtrl : function(component, event, helper) {
        debugger;
        component.set("v.travelReqId", event.getParam("travelReqId"));
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