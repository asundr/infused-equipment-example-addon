Scriptname XMPL_FireTrail extends INEQ_AbilityBase 
{Example ability script that makes use of AbilityBase}

;	If the ability is for a shield or 1h weapon, extend INEQ_AbilityBaseShield or INEQ_AbilityBase1H
;	otherwise extend INEQ_AbilityBase

;	INEQ_AbilityBase is the script that checks an equipped item to see if it's infused with this ability
;	That script then extends INEQ_EventListenerBase which contains behavior for native custom event
;	such as those concerning the DistanceTravelled, MagickaSiphon and SharedCharges charging mechanics

;	If you you want to make the most of these two parent scripts, read their source files form the
;	main plugin which describes thier behavior and the properties they contain

;===========================================  Properties  ===========================================================================>
Message	Property	MainMenu	Auto

; Reference alias from a new recharge source not in the original mod
ReferenceAlias	Property	TestRechargeAlias	Auto

ImpactDataset	property	TrailSet			Auto
Hazard			property	TrailHazard			Auto

float	Property	ChargeCostDT			Auto	Hidden	; distance in feet
float	Property	ChargeCostMS			Auto	Hidden	; magicka needed from magicka siphon
int		Property	ChargePriorityMS		Auto	Hidden	; larger priorities are charge before lower priority abilities
int 	Property	ChargeTimeTR			Auto	Hidden

;==========================================  Autoreadonly  ==========================================================================>
; autoreadonly properties do no add to the memory of the active script
float	Property	DEFChargeCostDT		=	250.0		Autoreadonly
float	Property	DEFChargeCostMS		=	200.0		Autoreadonly
int		Property	DEFChargePriorityMS	=	50			Autoreadonly
int		Property	DEFChargeTimeTR		=	10			Autoreadonly

String	Property	FootSprintLeft	=	"FootSprintLeft"	Autoreadonly
String	Property	FootSprintRight	=	"FootSprintRight"	Autoreadonly

;===========================================  Variables  ============================================================================>
bool bBalanced
bool exampleBool
bool bRegisteredTR = False

; makes it easeir to interract with the TestRecharge script
XMPL_TestRechargeSource TestRecharge

;===============================================================================================================================
;====================================	    Maintenance			================================================
;================================================================================================

; The Parent class defines OnEffectStart so if you override it you must start it with parent.EffectStart(akTarget, akCaster)
Event OnEffectStart(Actor akTarget, Actor akCaster)

	; Read the source code for AbilityBase and EventListenerBase to see how/why this is implemented
	parent.EffectStart(akTarget, akCaster)
	
	; Initializes properties to default values
	RestoreDefaultFields()	
	; Used to communicate with custom recharge sources. Make sure this is defined before Recharge register
	
	TestRecharge = TestRechargeAlias as XMPL_TestRechargeSource
	
	; This funciton currently enables menu specific to this ability accessed through AbilityMenu() below
	; Make sure you fill AbilityAliasProperties property with the AbilityAlias_Slot that contains this
	; ability's keyword and AbilityAliasProperties.psc
	RegisterAbilityToAlias()
EndEvent
;___________________________________________________________________________________________________________________________

; The Same is true for OnEffectFinish, however the call to the parent should generally be at the end
Event OnEffectFinish(Actor akTarget, Actor akCaster)
	TestRecharge.UnregisterForTestRechargeEvent(self)
	bRegisteredTR = False
	parent.EffectFinish(akTarget, akCaster)
EndEvent
;___________________________________________________________________________________________________________________________

; This function is also used by the main menu while resetting all abilities to default values
function RestoreDefaultFields()
	bBalanced		= True
	exampleBool		= False
	ChargeCostDT	= DEFChargeCostDT
	ChargeCostMS	= DEFChargeCostMS
	ChargePriorityMS = DEFChargePriorityMS
	ChargeTimeTR	= DEFChargeTimeTR
EndFunction

;===============================================================================================================================
;====================================			States			================================================
;================================================================================================

; This is the initial state of every ability and DOES NOT need to be included unless you intend to
; add or override behavior from the state. I only recommend including it if you understand exactly 
; how the parent scripts work and why it is defined the way it is
; If overriding OnObjectEquipped() , make sure you include EquipCheckKW(akReference)
Auto State Unequipped
EndSTate


; If you extend from INEQ_AbilityBase, this state has behaviour for when the infused item is equipped
; For more compliced scripts, you may need to have multiple states, but the Equipped state must be one of them
State Equipped

	Event OnBeginState()
		RegisterForAnimationEvent(selfRef, FootSprintLeft)
		RegisterForAnimationEvent(selfRef, FootSprintRight)
		
		; The following is used to register for recharge sources
		; See the function definition below for the funcitons native to the main mod
		RegisterForRecharge()
	EndEVent
	
	; This event contains the main effect which is activated every footstep
	Event OnAnimationEvent( ObjectReference akSelfRef, string asEventName )
		akSelfRef.PlaceAtMe(TrailHazard)
	endEvent

	Event OnEndState()
		UnregisterForAnimationEvent(selfRef, FootSprintLeft)
		UnregisterForAnimationEvent(selfRef, FootSprintRight)
	EndEvent
	;___________________________________________________________________________________________________________________________

;		THESE ARE UNRELATED TO THE SPRINT TRAIL ABILITY. THEY'RE HERE TO DEMONSTRATE RECHARGE MECHANICS

	; Recives events after registering for magicka siphon event
	; NOTE that while this acts like an event, it is written as a function
	Function OnMagickaSiphonEvent()
		Debug.Notification("Magicka siphon event while " +GetState())
		RegisterForMagickaSiphonEvent(ChargeCostMS, ChargePriorityMS)
	EndFunction

	; Recives events after registering for distance travelled event
	; NOTE that while this acts like an event, it is written as a function
	Function OnDistanceTravelledEvent()
		Debug.Notification("Distance travelled event while " +GetState())
		RegisterForDistanceTravelledEvent(ChargeCostDT)
	EndFunction

	; Recives events after registering for custom recharge source Test Recharge
	; Custom events must manually turn off charging bool
	Function OnCustomRechargeEvent(String asEventName)
		if asEventName == "Test Recharge"
			Debug.Notification("Test Recharge event while " +GetState())
			bRegisteredTR = False
			TestRecharge.RegisterForTestRechargeEvent(self, ChargeTimeTR)
		endif
	EndFunction

EndState

;===============================================================================================================================
;====================================		   Functions		================================================
;================================================================================================
;				Catches charge event without registering for another charge
Function OnMagickaSiphonEvent()
	Debug.Notification("Magicka siphon event while " +GetState())
EndFunction

Function OnDistanceTravelledEvent()
	Debug.Notification("Distance travelled event while " +GetState())
EndFunction

Function OnCustomRechargeEvent(String asEventName)
	if asEventName == "Test Recharge"
		Debug.Notification("Test Recharge event while " +GetState())
		bRegisteredTR = False
	endif
EndFunction
;___________________________________________________________________________________________________________________________

; This is a useful function for requesting an event from recharge sources
; If the parameter is left empty, bForced is false, meaning that it will be ignored
; if this ability is alrady charging. If True is passed into the function, this is will
; cancel and replace any previous register for a charge. This option is useful for menus
; if the playper updates any of the fields as shown below
Function RegisterForRecharge(bool bForced = False)
	RegisterForDistanceTravelledEvent(ChargeCostDT, bForced)
	RegisterForMagickaSiphonEvent(ChargeCostMS, ChargePriorityMS, bForced)
	
	; Registers with a custom recharge source and sets this ability as currently recharging it
	if !bRegisteredTR || bForced
		bRegisteredTR = True
		TestRecharge.RegisterForTestRechargeEvent(self, ChargeTimeTR)
	endif
EndFunction

;===============================================================================================================================
;====================================		    Menus			================================================
;================================================================================================

; If your ability has options they must be accessed through this function. The parameters pass usefull references:
;	Button: see the description for SetButtonMain() below
;	ListenerMenu: Contains premade functions for common menus. Syntax for use in buttons 5, 6, 7 and 8
;	MenuActive: is a global variable used to fast-quit the menu instead of going to the previous window
Function AbilityMenu(INEQ_MenuButtonConditional Button, INEQ_ListenerMenu ListenerMenu, GlobalVariable MenuActive)
	bool abMenu = True
	int aiButton
	while abMenu && MenuActive.Value
		SetButtonMain(Button)
		aiButton = MainMenu.Show()
		if aiButton == 0			; Back (previous window)
			abMenu = False
		elseif aiButton == 9		; Cancel Menu (fast quit)
			MenuActive.SetValue(0)
		elseif aiButton == 1		; Turn on Balanced (common option for abilities)
			RestoreDefaultFields()
		elseif aiButton == 2		; Turn off Balanced (common option for abilities)
			bBalanced = False
		elseif aiButton == 3		; Example Bool -> On (example toggle)
			exampleBool = True
		elseif aiButton == 4		; Example Bool -> Off (example toggle)
			exampleBool = False
		elseif aiButton == 5		; Set Time for recharge from Test Recharge source
			ChargeTimeTR = ListenerMenu.ChargeTime(ChargeTimeTR, DEFChargeTimeTR)
		elseif aiButton == 6		; Set Distance Cost	(allows player to set distance for next charge)
			ChargeCostDT = ListenerMenu.DistanceTravelledCost(ChargeCostDT, DEFChargeCostDT)
		elseif aiButton == 7		; Set Magicka Siphon Cost (player can set magicka needed for charge)
			ChargeCostMS = ListenerMenu.MagickaSiphonCost(ChargeCostMS, DEFChargeCostMS)
		elseif aiButton == 8		; Set Magicka Siphon Priority (determines priority of charge over other abilities)
			ChargePriorityMS = ListenerMenu.MagickaSiphonPriority(ChargePriorityMS, DEFChargePriorityMS)
		endif
	endwhile
	RegisterForRecharge(True)	; Forces a recharge even if already recharging since fields might have been updated
EndFunction

; The Button object is useful for selectively displaying buttons without having to deal with
; multiple conditional scripts. To use, first clear the button then set the index of the button
; you wish to display. Make sure the actual menu object from the CK uses GetVMQuestVariable conditions
; for the buttons, its probably easier just to copy and existing menu and rewriting only the item text
Function SetButtonMain(INEQ_MenuButtonConditional Button)
	Button.clear()
	if bBalanced
		Button.set(2)
	else
		Button.set(1)
		if exampleBool
			Button.set(4)
		else
			Button.set(3)
		endif
		Button.set(5)
		Button.set(6)
		Button.set(7)
	endif
	Button.set(8)
	Button.set(9)
EndFunction
