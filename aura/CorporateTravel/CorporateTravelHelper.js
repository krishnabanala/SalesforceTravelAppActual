({
    getTravelRequestsHelper : function(component) {
        console.log('>>>>>>>>>>>>>>>>>>>');    
        var action = component.get("c.getTravelRequests");	
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                debugger;
                component.set('v.lstTravelRequests', response.getReturnValue());
                var lstTravelReq = component.get('v.lstTravelRequests');
                console.log('>>>>>>>>>>>>>>>>>>>>>>> lstTravelReq : ' + lstTravelReq);
                //debugger;
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
    getApprovalRequestsHelper : function(component) {
        var action = component.get("c.getApprovalRequests");	
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                //debugger;
                component.set('v.lstApprovals', response.getReturnValue());
                var lstApprovals = component.get('v.lstApprovals');
                console.log('>>>>>>>>>>>>>>>>>>>>>>> lstApprovals : ' + lstApprovals);
                //debugger;
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
	
	 approvRejCtrlHelper : function(component, curProcessInstId, sAction) {
        var action = component.get("c.approveOrRejectTravelReq");
		action.setParams({ 
            "processInstId": curProcessInstId,
			"sAction": sAction,
		    "sComments" : component.get("v.approvComments")
        });		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
				var modalArr = document.getElementsByClassName('slds-modal slds-fade-in-open');
				modalArr[0].className = 'slds-modal';
				var modalBackDropArr = document.getElementsByClassName('slds-backdrop slds-backdrop--open');
				modalBackDropArr[0].className = 'slds-backdrop';
				console.log('>>>>>>>>>>>>>>>> sAction : ' + sAction);
                window.scrollTo(0,0);
				if(sAction == "Approve"){
					debugger;
					component.set('v.displayApprovMsg', "msgTrue");
					setTimeout(function(){ component.set("v.displayApprovMsg", "msgFalse"); }, 3000);
				}
				else if(sAction == "Reject"){
					debugger;
					component.set('v.displayRejectMsg', "msgTrue");
					setTimeout(function(){ component.set("v.displayRejectMsg", "msgFalse"); }, 3000);
				}				
				this.getApprovalRequestsHelper(component);
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
    
   tabClick : function(component, event, tabName) {
        console.log('clickeddddddddddddddddddddddddddd');
        //debugger;
        var tabArr = document.getElementsByClassName('slds-tabs--default__item');
        var tabArrLen = tabArr.length;
        for(var i = 0 ; i < tabArrLen ; i++){
            tabArr[i].className = 'slds-tabs--default__item slds-text-heading--label';
        }
        event.currentTarget.parentElement.className = 'slds-tabs--default__item slds-text-heading--label slds-active';
        
        var tabArrContent = document.getElementsByClassName('slds-tabs--default__content');
        var tabArrContentLen = tabArr.length;
        for(var i = 0 ; i < tabArrContentLen ; i++){
            tabArrContent[i].className = 'slds-tabs--default__content slds-hide';
        }
        document.getElementById(tabName).className = 'slds-tabs--default__content slds-show';
        
    }
})