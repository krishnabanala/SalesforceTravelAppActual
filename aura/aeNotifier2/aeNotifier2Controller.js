/* aeNotifierController.js */
{
    fireApplicationEvent : function(cmp, event) {
        // Get the application event by using the
        // e.<namespace>.<event> syntax
        debugger;
        var appEvent = $A.get("e.c:EditTravelReq");
        appEvent.setParams({
            "travelReqId" : "An application event fired me. " +
            "It all happened so fast. Now, I'm everywhere!" });
        appEvent.fire(); 
    }
}