/* aeNotifierController.js */
{
    fireApplicationEvent : function(cmp, event) {
        // Get the application event by using the
        // e.<namespace>.<event> syntax
        var appEvent = $A.get("e.c:aeEvent");
        appEvent.setParams({ "travelReqId" : event.currentTarget.getAttribute('id')});
        debugger;
        appEvent.fire();
    }
}