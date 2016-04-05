<aura:application controller="RequestFormController" implements="force:appHostable">  

    <!--Sample Comment--> 
    <!--Sample Comment3-->
    <ltng:require styles="/resource/slds0120/assets/styles/salesforce-lightning-design-system.min.css"/>
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
    <aura:registerEvent name="EditTravelReq1" type="c:EditTravelReq"/>
    <aura:attribute name="lstTravelRequests" type="Travel_Request__c[]"/>
    <aura:attribute name="lstApprovals" type="ApprovalWrapper"/>
	<aura:attribute name="curApprovalId" type="String"/>
	<aura:attribute name="approvComments" type="String"/>
    <aura:attribute name="displayMsg" type="String" default="msgFalse"/> 
    <aura:attribute name="displayErrorMsg" type="String" default="msgFalse"/>
    <aura:attribute name="displayApprovMsg" type="String" default="msgFalse"/> 
    <aura:attribute name="displayRejectMsg" type="String" default="msgFalse"/> 
    <aura:attribute name="ErrorMsg" type="String" default=""/>
    <aura:handler event="aura:waiting" action="{!c.showSpinner}"/>
    <aura:handler event="aura:doneWaiting" action="{!c.hideSpinner}"/>
    <aura:handler name="ApprovalSubmittedEvt" event="c:ApprovalSubmittedEvt" action="{!c.approvalSubmittedEvtHndlr}"/>
    <aura:handler name="ErrorEvt" event="c:ErrorEvt" action="{!c.ErrorEvtHndlr}"/>
	    
    <div class="slds"> 
        <div class="slds-page-header">
            <div class="slds-grid">
                <div class="slds-col slds-has-flexi-truncate">
                    <div class="slds-grid">
                        <div class="slds-grid slds-type-focus slds-no-space">
                            <h1 class="slds-text-heading--medium slds-truncate" title="CTM">Corporate Travel Management</h1>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="slds-grid">
            <div class="slds-col slds-has-flexi-truncate">
                <div class="slds-tabs--default">
                    <ul class="slds-tabs--default__nav" role="tablist">
                        <li class="slds-tabs--default__item slds-text-heading--label slds-active" title="Item One" role="presentation"><a class="slds-tabs--default__link" href="#" onclick="{!c.travelRequestsTabClick}" role="tab" tabindex="0" aria-selected="true" aria-controls="tab-default-1">Travel Requests</a></li>
                        <li class="slds-tabs--default__item slds-text-heading--label" title="Item Two" role="presentation"><a class="slds-tabs--default__link" href="#" role="tab" onclick="{!c.approvalsTabClick}" tabindex="-1" aria-selected="false" aria-controls="tab-default-2">Approvals</a></li>
                        <li class="slds-tabs--default__item slds-text-heading--label" title="Item Three" role="presentation" id="travelReqFormTabliId"><a class="slds-tabs--default__link" href="#" role="tab" onclick="{!c.newTravelReqCtrl}" tabindex="-1" aria-selected="false" aria-controls="tab-default-3">New Travel Request</a></li>
                    </ul>
                    <center><ui:spinner aura:id="spinner" isVisible="false"/></center>
                    <div id="tab-default-1" class="slds-tabs--default__content slds-show" role="tabpanel">
                        <aura:if isTrue="{!v.displayMsg == 'msgTrue'}">
                            <ui:message title="Success !!!" severity="info" closable="true">
                                Record has been submitted for approval
                            </ui:message>
                            <aura:set attribute="else">
                                <div></div>
                            </aura:set>
                        </aura:if>
                        <aura:if isTrue="{!v.displayErrorMsg == 'msgTrue'}">
                            <ui:message title="Error !!!" severity="error" closable="true">
                                {!v.ErrorMsg}
                            </ui:message>
                            <aura:set attribute="else">
                                <div></div>
                            </aura:set>
                        </aura:if>
                        <div class="slds-grid">
                            <div class="slds-col slds-has-flexi-truncate">
                                <ul class="slds-list--vertical slds-has-cards--space has-selections">
                                    <aura:iteration items="{!v.lstTravelRequests}" var="travelReqObj">
                                        <c:TravelRequests TravelRequestObj="{!travelReqObj}"/> 
                                    </aura:iteration>
                                </ul>
                            </div>                            
                        </div>                     
                    </div>
                    <div id="tab-default-2" class="slds-tabs--default__content slds-hide" role="tabpanel">
						<aura:if isTrue="{!v.displayApprovMsg == 'msgTrue'}">
                            <ui:message title="Success !!!" severity="info" closable="true">
                                Record has been approved
                            </ui:message>
                            <aura:set attribute="else">
                                <div></div>
                            </aura:set>
                        </aura:if> 
                        <aura:if isTrue="{!v.displayRejectMsg == 'msgTrue'}">
                            <ui:message title="Rejected !!!" severity="error" closable="true">
                                Record has been rejected
                            </ui:message>
                            <aura:set attribute="else">
                                <div></div>
                            </aura:set>
                        </aura:if> 
                        <div class="slds-grid">
                            <div class="slds-col slds-has-flexi-truncate">
                                <ul class="slds-list--vertical slds-has-cards--space has-selections">
                                    <div class="slds-grid">
                                        <div class="slds-col slds-has-flexi-truncate">
                                            <ul class="slds-list--vertical slds-has-cards--space has-selections">
                                                <aura:iteration items="{!v.lstApprovals}" var="approvalObj">
                                                    <li class="slds-list__item">
                                                        <div class="slds-tile slds-tile--board">
                                                            <div class="slds-media slds-tile slds-hint-parent">
                                                                <div class="slds-media__figure">
                                                                    <c:svg class="slds-icon slds-icon-standard-contact" xlinkHref="/resource/slds0120/assets/icons/standard-sprite/svg/symbols.svg#contact" />                          
                                                                </div>
                                                                <div class="slds-media__body">
                                                                    <div class="slds-grid slds-grid--align-spread slds-has-flexi-truncate">
                                                                        <p class="slds-tile__title slds-truncate">$<ui:outputNumber value="{!approvalObj.sAmt}" format=".00"/></p>
                                                                        
                                                                        <div class="slds-dropdown-trigger">
                                                                            <button class="slds-button slds-button--icon-border-filled slds-button--icon-x-small slds-shrink-none" aria-haspopup="true">
                                                                                <c:svg class="slds-button__icon slds-button__icon--hint slds-button__icon--small"  
                                                                                       xlinkHref="/resource/slds0120/assets/icons/utility-sprite/svg/symbols.svg#down" />  															
                                                                                <span class="slds-assistive-text">Show More</span>
                                                                            </button>
                                                                            <div class="slds-dropdown slds-dropdown--right slds-dropdown--actions slds-dropdown--menu">
                                                                                <ul class="slds-dropdown__list" role="menu">
                                                                                    <li id="menu-34-0" href="#" class="slds-dropdown__item">
                                                                                        <a href="javascript:void(0)" role="menuitem">
                                                                                            <p class="slds-truncate" onclick="{!c.approvRejCtrlOpen}" id="{!approvalObj.sWrkItmId}">Approve/Reject</p>
                                                                                        </a>
                                                                                    </li>                                                                                  														 
                                                                                </ul>
                                                                            </div>
                                                                        </div>
                                                                        
                                                                    </div>
                                                                    <div class="slds-tile__detail">
                                                                        <dl class="dl--horizontal slds-text-body--small">
                                                                            <dt class="slds-dl--horizontal__label">
                                                                                <p class="slds-truncate">From:</p>
                                                                            </dt>
                                                                            <dd class="slds-dl--horizontal__detail slds-tile__meta">
                                                                                <p class="slds-truncate">{!approvalObj.sSource}</p>
                                                                            </dd>
                                                                            <dt class="slds-dl--horizontal__label">
                                                                                <p class="slds-truncate">To:</p>
                                                                            </dt>
                                                                            <dd class="slds-dl--horizontal__detail slds-tile__meta">
                                                                                <p class="slds-truncate">{!approvalObj.sDestination}</p>
                                                                            </dd>
                                                                            <dt class="slds-dl--horizontal__label">
                                                                                <p class="slds-truncate">Status:</p>
                                                                            </dt>
                                                                            <dd class="slds-dl--horizontal__detail slds-tile__meta">
                                                                                <p class="slds-truncate">{!approvalObj.sStatus}</p>
                                                                            </dd>
                                                                        </dl>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </aura:iteration>
                                                
                                                
                                            </ul>
                                        </div>
                                      
                                    </div>
                                    
                                    
                                </ul>
                            </div>
                        </div>
						
						
						<div>
  <div aria-hidden="true" role="dialog" class="slds-modal">
    <div class="slds-modal__container">
      <div class="slds-modal__header">
        <h2 class="slds-text-heading--medium">Approve / Reject</h2>
        <button class="slds-button slds-button--icon-inverse slds-modal__close" onclick="{!c.approveRejModalClose}">
				<c:svg class="slds-button__icon slds-button__icon--large"  
                                       xlinkHref="/resource/slds0120/assets/icons/action-sprite/svg/symbols.svg#close" />  		
          <span class="slds-assistive-text">Close</span>
        </button>
      </div>
      <div class="slds-modal__content">
        <div>
          <p><b>Please enter your comments below : </b></p><br/>
		  <ui:inputTextArea aura:id="comments" placeholder="My comments" rows="5" class="commentCls" value="{!v.approvComments}"/>
        </div>
      </div>
      <div class="slds-modal__footer">
        <div class="slds-x-small-buttons--horizontal">
          <button class="slds-button slds-button--neutral slds-button--brand" onclick="{!c.approveCtrl}">Approve</button>
          <button class="slds-button slds-button--neutral" onclick="{!c.rejectCtrl}">Reject</button>
		  <button class="slds-button slds-button--neutral" onclick="{!c.approveRejModalClose}">Cancel</button>
        </div>
      </div>
    </div>
  </div>
  <div class="slds-backdrop"></div>
</div>



                        
                    </div>
                    <div id="tab-default-3" class="slds-tabs--default__content slds-hide" role="tabpanel">
                        <div class="slds-grid">
                            
                            <div class="slds-col--padded slds-has-flexi-truncate">
                                <c:aeHandler1 />
                                <!--<c:RequestTravelForm travelReqId="a012800000FmNS9"/>-->
                            </div>
                        </div>
                    </div>
                </div>
            </div>    
        </div>
    </div>
    
</aura:application>