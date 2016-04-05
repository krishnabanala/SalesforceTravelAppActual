({
	submitApprovTravelReqHelper : function(component, event) {
        var action = component.get("c.SubmitForApprov");
        action.setParams({ 
            "travelReqId": event.currentTarget.getAttribute('id')
        });		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //debugger;
                console.log('>>>>>>>>>>>>>>>>> Success');
                //component.set("v.displayMsg", "msgTrue");
                //setTimeout(function(){ component.set("v.displayMsg", "msgFalse"); }, 3000);
                var cmpEvent = component.getEvent("ApprovalSubmittedEvt");
                //debugger;
                cmpEvent.fire();
                //debugger;
            }
            else if (state === "ERROR") {
                debugger;
                var errors = response.getError();
                var errorMsgEvt = component.getEvent("ErrorEvt");
                errorMsgEvt.setParams({ "ErrorMsg" : errors[0].pageErrors[0].message});
                debugger;
                errorMsgEvt.fire();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });  
        $A.enqueueAction(action);
    }
})