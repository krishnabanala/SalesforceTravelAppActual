({
    getInitData : function(component, event) { 
        var travelReqId = component.get("v.travelReqId");
        console.log('>>>>>>>>>>>>>>> ' + travelReqId);
        var travelTypeOpts = [];
        var travelByOpts = [];
        var sourceOpts = [];
        var destinationOpts = [];
        
        var action = component.get("c.getInitData"); 
        action.setParams({ 
            "travelReqId": travelReqId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var travelReqFormWrap = JSON.parse(response.getReturnValue());
                console.log('>>>>>>>>>>>>>>>>>>>>>> travelReqFormWrap' + travelReqFormWrap);
                //debugger;
                component.set("v.newTravelRequest", travelReqFormWrap.travReqObj); 
                var travelTypeArrLen = travelReqFormWrap.lstTravelTypeOpts.length;
                if(travelReqId == "None"){
                    component.set("v.newTravelRequest.Travel_Date__c", new Date());   
                    component.set("v.newTravelRequest.Expected_Revenue__c",0);  
                }
                for(var i = 0 ; i < travelTypeArrLen ; i++){
                    if(travelReqId != "None" && travelReqFormWrap.travReqObj.Travel_Type__c === travelReqFormWrap.lstTravelTypeOpts[i]){
                        travelTypeOpts.push({ class: "optionClass", label: travelReqFormWrap.lstTravelTypeOpts[i], value: travelReqFormWrap.lstTravelTypeOpts[i], selected: "true" });
                    }
                    else{
                        travelTypeOpts.push({ class: "optionClass", label: travelReqFormWrap.lstTravelTypeOpts[i], value: travelReqFormWrap.lstTravelTypeOpts[i]});
                    }
                }
                
                var travelByArrLen = travelReqFormWrap.lstTravelByOpts.length;
                for(var i = 0 ; i < travelByArrLen ; i++){
                    if(travelReqId != "None" && travelReqFormWrap.travReqObj.Travel_By__c === travelReqFormWrap.lstTravelByOpts[i]){
                        travelByOpts.push({ class: "optionClass", label: travelReqFormWrap.lstTravelByOpts[i], value: travelReqFormWrap.lstTravelByOpts[i], selected: "true" });
                    }
                    else{
                        travelByOpts.push({ class: "optionClass", label: travelReqFormWrap.lstTravelByOpts[i], value: travelReqFormWrap.lstTravelByOpts[i]});
                    }
                }
                
                var sourceArrLen = travelReqFormWrap.lstSourceOpts.length;
                for(var i = 0 ; i < sourceArrLen ; i++){
                    console.log('>>>>>>>>>>>>>>>>>>> Source Name : ' + i + travelReqFormWrap.lstSourceOpts[i]);
                    console.log('>>>>>>>>>>>>>>>>>>> Source Name : ' + i + travelReqFormWrap.travReqObj.Source__r);
                    if(travelReqId != "None" && travelReqFormWrap.travReqObj.Source__r.Name === travelReqFormWrap.lstSourceOpts[i]){
                        //debugger;
                        sourceOpts.push({ class: "optionClass", label: travelReqFormWrap.lstSourceOpts[i], value: travelReqFormWrap.lstSourceOpts[i], selected: "true" });
                    }
                    else{
                        sourceOpts.push({ class: "optionClass", label: travelReqFormWrap.lstSourceOpts[i], value: travelReqFormWrap.lstSourceOpts[i]});
                    }
                }
                
                var destinationArrLen = travelReqFormWrap.lstDestinationOpts.length;
                for(var i = 0 ; i < destinationArrLen ; i++){
                    if(travelReqId != "None" && travelReqFormWrap.travReqObj.Destination__r.Name === travelReqFormWrap.lstDestinationOpts[i]){
                        destinationOpts.push({ class: "optionClass", label: travelReqFormWrap.lstDestinationOpts[i], value: travelReqFormWrap.lstDestinationOpts[i], selected: "true" });
                    }
                    else{
                        destinationOpts.push({ class: "optionClass", label: travelReqFormWrap.lstDestinationOpts[i], value: travelReqFormWrap.lstDestinationOpts[i]});
                    }
                }
                
                component.find("travelTypeId").set("v.options", travelTypeOpts);
                component.find("travelById").set("v.options", travelByOpts);
                var sourceField = component.find("sourceId");
                sourceField.set("v.options", sourceOpts);
                var destinationField = component.find("destinationId");
                destinationField.set("v.options", destinationOpts);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveTravelRequestHelper : function(component, newTravelRequest) {
        var action = component.get("c.saveTravelRequest");
        var newTravelRequestJson = JSON.stringify(newTravelRequest);
        newTravelRequestJson = newTravelRequestJson.replace(/__c/g, '')	.replace(/__r/g, 'R');;
        debugger;
        action.setParams({ 
            "travelReqJson": newTravelRequestJson
        });		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //debugger;
                component.set("v.displayMsg", "msgTrue");
                setTimeout(function(){ component.set("v.displayMsg", "msgFalse"); }, 3000);
                console.log('>>>>>>>>>>>>>>>>> Success');
                //component.set("v.travelReqId", "None");
            }
            else if (state === "ERROR") {
                debugger;
                var errors = response.getError();
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
    },
    
    submitForApprovalHelper : function(component, newTravelRequest) {
        var action = component.get("c.ApprovalSubmit");
        var newTravelRequestJson = JSON.stringify(newTravelRequest);
        newTravelRequestJson = newTravelRequestJson.replace(/__c/g, '').replace(/__r/g, 'R');
        action.setParams({ 
            "travelReqJson": newTravelRequestJson
        });		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                debugger;
                console.log('>>>>>>>>>>>>>>>>> Success');
            }
            else if (state === "ERROR") {
                debugger;
                var errors = response.getError();
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