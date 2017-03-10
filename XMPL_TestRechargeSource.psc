Scriptname XMPL_TestRechargeSource extends INEQ_RechargeBase  

; This is a very simple recharge script to demonstrate how you can create a custom recharge event
; for your abilities. As it's written, it is effectively reduntant with RegisterForSingleUpdate()
; This can only deal with one ability at a time, to handle multiple abilities use an array to store the
; INEQ_EventListenerBases. And you'll need to manage the requests and send event with states.
; To see examples of this look at the INEQ_DistanceTravelled script and the INEQ_MagickaSiphon script
; which is slightly more complicated but also more robust as of writing this

;===========================================  Properties  ===========================================================================>

;==========================================  Autoreadonly  ==========================================================================>

;===========================================  Variables  ============================================================================>
bool bTestToggle = False
INEQ_EventListenerBase asker

;===============================================================================================================================
;====================================	    Maintenance			================================================
;================================================================================================

;	This script doesn't require the following maintenence functions and could actually be
;	left out entirely, however in case you need to add additional behavior to them use this format

Event OnInit()
	parent.Init()
	; do stuff
EndEvent

Event OnPlayerLoadGame()
	parent.PlayerLoadGame()
	; do stuff
EndEvent

Function Maintenance()
	parent.Maintenance()
	; do stuff
EndFunction

Function RestoreDefaultFields()
	parent.RestoreDefaultFields()
	; do stuff
EndFunction

Function FullReset()
	parent.FullReset()
	; do stuff
EndFunction

;===============================================================================================================================
;====================================			Functions			================================================
;================================================================================================

; Used by an ability to register for a Test Recharge update after a given time
Function RegisterForTestRechargeEvent(INEQ_EventListenerBase akAsker, int akTime)
	asker = akAsker
	RegisterForSingleUpdate(akTime)
EndFunction
;___________________________________________________________________________________________________________________________

; Uneregisters for an update if asker is currently registered
Function UnregisterForTestRechargeEvent(INEQ_EventListenerBase akAsker)
	if akAsker == asker
		UnregisterForUpdate()
		asker = None
	endif
EndFunction
;___________________________________________________________________________________________________________________________

Event OnUpdate()
	SendEvent()
EndEvent

; Sends update to asker and removes it from register
Function SendEvent()
	INEQ_EventListenerBase temp = asker
	asker = None
	temp.OnCustomRechargeEvent(Name)
EndFunction

;===============================================================================================================================
;====================================		    Menus			================================================
;================================================================================================

; If your ability has options they must be accessed through this function. The parameters pass usefull references:
;	Button: see the description for SetButtonMain() below
;	ListenerMenu: Contains premade functions for common menus. See XMPL_FireTrail
;	MenuActive: is a global variable used to fast-quit the menu instead of going to the previous window
Function ChargeMenu(INEQ_MenuButtonConditional Button, INEQ_ListenerMenu ListenerMenu, GlobalVariable MenuActive)
	bool abMenu = True
	int aiButton
	while abMenu && MenuActive.Value
		SetButtonMain(Button)
		aiButton = MainMenu.Show()
		if aiButton == 0
			abMenu = False
		elseif aiButton == 9		; Cancel menu
			MenuActive.SetValue(0)
		elseif aiButton == 1		; bTestToggle -> ON
			bTestToggle = True
		elseif aiButton == 2		; bTestToggle -> OFF
			bTestToggle = False
		endif
	endwhile
EndFunction

; The Button object is useful for selectively displaying buttons without having to deal with
; multiple conditional scripts. To use, first clear the button then set the index of the button
; you wish to display. Make sure the actual menu object from the CK uses GetVMQuestVariable conditions
; for the buttons, its probably easier just to copy and existing menu and rewriting only the item text
Function SetButtonMain(INEQ_MenuButtonConditional Button)
	Button.clear()
	if bTestToggle
		Button.set(2)
	else
		Button.set(1)
	endif
	Button.set(9)
EndFunction
