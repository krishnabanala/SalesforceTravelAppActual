/* aeHandlerController.js */
{
    handleApplicationEvent : function(cmp, event) {
        var message = event.getParam("message");

        // set the handler attributes based on event data 
        cmp.set("v.messageFromEvent", message);
        var numEventsHandled = parseInt(cmp.get("v.numEvents")) + 1;
        cmp.set("v.numEvents", numEventsHandled);
    },
    doInit : function(component, event, helper) { 
        helper.getInitData(component, event);
    },
    
    editTravelReqCtrl : function(component, event, helper) {
        //debugger;
        component.set("v.travelReqId", event.getParam("travelReqId"));
        helper.getInitData(component);
    },
    
    saveTravelRequestCtrl : function(component, event, helper) {
        var newTravelRequest = component.get("v.newTravelRequest");
		var expRevCmp = component.find("expRevId");
		var expRevVal = expRevCmp.get("v.value");
        var bError = false;
        if (isNaN(expRevVal)) {
            expRevCmp.set("v.errors", [{message:"Expected Revenue not a number: " + expRevVal}]);
            bError = true;
        } else {
            expRevCmp.set("v.errors", null);
        }
		
		var travelDtCmp = component.find("travelDateId");
		var travelDtVal = travelDtCmp.get("v.value");
		console.log('>>>>>>>>>>>>>>> travelDtVal : ' + travelDtVal);
        if (!travelDtVal) {
            travelDtCmp.set("v.errors", [{message:"Please select a Date And Time"}]);
            bError = true;
        } else {
            travelDtCmp.set("v.errors", null);
        }
        if(bError == true){
            return
        }
        helper.saveTravelRequestHelper(component, newTravelRequest);
    },
    
    submitForApproval : function(component, event, helper) {
        var newTravelRequest = component.get("v.newTravelRequest");
        helper.submitForApprovalHelper(component, newTravelRequest);
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
    }
}