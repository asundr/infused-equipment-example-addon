Scriptname INEQ_RegisterPlugin extends Quest 
{Registers the plugin to the core INEQ Plugin and Ability Register}

;	INSTRUCTIONS
;	To use this attach it to an empty quest. On the properties window first click AutoFill
;	then fill AbilityRegister with the ReferenceAlias of the same name on the quest INEQ__MAIN
;	Fill in the quest properties of the corresponding quests in your own plugin for each 
;	AbilityToPlayer, RechargeSource and every AbilityAlias_<Slot>. Leave it blank otherwise.

;	It's recommended to use this as-is, but if you want to modify it you need to give the script
;	a uniqe name that wont conflict with INEQ or other plugins for it

;===========================================  Properties  ===========================================================================>
; The core of INEQ that handles all abilities and plugins
ReferenceAlias	Property	AbilityRegister		Auto

; Formlist containing every ability quest from the main mod and other INEQ plugins
FormList	Property	INEQ__AbilitiesToPlayerList		Auto

; Formlist containing every recharge source quest from the main mod and other INEQ plugins
Formlist	Property	INEQ__RechargeSourceList		Auto

; Formlists containing equipment slot quests from the main mod and other INEQ plugins
Formlist	Property	INEQ__Equipment_BodyQuests		Auto
Formlist	Property	INEQ__Equipment_FeetQuests		Auto
Formlist	Property	INEQ__Equipment_HandsQuests		Auto
Formlist	Property	INEQ__Equipment_HeadQuests		Auto
Formlist	Property	INEQ__Equipment_ShieldQuests	Auto
Formlist	Property	INEQ__Equipment_WBowQuests		Auto
Formlist	Property	INEQ__Equipment_WDaggerQuests	Auto
Formlist	Property	INEQ__Equipment_WSwordQuests	Auto

; The ability quest for all abilities local to this plugin
Quest	Property		AbilitiesToPlayer		Auto

; The recharge source quest for all abilities local to this plugin
Quest	Property		RechargeSource			Auto

; The slot quests that are local to this plugin
Quest	Property	AbilityAlias_Body		Auto
Quest	Property	AbilityAlias_Feet		Auto
Quest	Property	AbilityAlias_Hands		Auto
Quest	Property	AbilityAlias_Head		Auto
Quest	Property	AbilityAlias_Shield		Auto
Quest	Property	AbilityAlias_WBow		Auto
Quest	Property	AbilityAlias_WDagger	Auto
Quest	Property	AbilityAlias_WSword		Auto

;==========================================  Autoreadonly  ==========================================================================>
float	Property	WaitTime	=	1.0		Autoreadonly

;===========================================  Variables  ============================================================================>

;===============================================================================================================================
;====================================	    Maintenance			================================================
;================================================================================================

; Notifies the register that a new plugin is being installed, then atempts to install it
Event OnInit()
	Debug.Trace("[INEQ] Register plugin start...")
	; Lets the AbilityRegister know that a new plugin is being registered
	(AbilityRegister as INEQ_AbilityRegister).PluginInstallStart()
	addQuestsToLists()
	RegisterForSingleUpdate(WaitTime)
EndEvent

; Loops until every property is properly added, then notifies the Register
Event OnUpdate()
	if AllNotAdded()
		addQuestsToLists()
		RegisterForSingleUpdate(WaitTime)
	else
		Debug.Trace("[INEQ] Register plugin succeeded")
		; Forces the main plugin to update its list of available abilities
		(AbilityRegister as INEQ_AbilityRegister).PluginInstallFinish()
	endif
EndEvent

;===============================================================================================================================
;====================================			Functions			================================================
;================================================================================================

; Attempts to add each Quest to the main INEQ Formlist it corresponds to
Function addQuestsToLists()

	; Adds recharges sources in this mod to the main plugins's formlist
	if RechargeSource && INEQ__RechargeSourceList.Find(RechargeSource) == -1
		INEQ__RechargeSourceList.AddForm(RechargeSource)
	endif
	; Add abilities in this mod to the main plugins's formlist
	if AbilitiesToPlayer && INEQ__AbilitiesToPlayerList.Find(AbilitiesToPlayer) == -1
		INEQ__AbilitiesToPlayerList.AddForm(AbilitiesToPlayer)
	endif
	
	; Add the quests of each equipment slot to their corresponding formlist from the main plugin
	if AbilityAlias_Body && INEQ__Equipment_BodyQuests.Find(AbilityAlias_Body) == -1
		INEQ__Equipment_BodyQuests.AddForm(AbilityAlias_Body)
	endif
	if AbilityAlias_Feet && INEQ__Equipment_FeetQuests.Find(AbilityAlias_Feet) == -1
		INEQ__Equipment_FeetQuests.AddForm(AbilityAlias_Feet)
	endif
	if AbilityAlias_Hands && INEQ__Equipment_HandsQuests.Find(AbilityAlias_Hands) == -1
		INEQ__Equipment_HandsQuests.AddForm(AbilityAlias_Hands)
	endif
	if AbilityAlias_Head && INEQ__Equipment_HeadQuests.Find(AbilityAlias_Head) == -1
		INEQ__Equipment_HeadQuests.AddForm(AbilityAlias_Head)
	endif
	if AbilityAlias_Shield && INEQ__Equipment_ShieldQuests.Find(AbilityAlias_Shield) == -1
		INEQ__Equipment_ShieldQuests.AddForm(AbilityAlias_Shield)
	endif
	if AbilityAlias_WBow && INEQ__Equipment_WBowQuests.Find(AbilityAlias_WBow) == -1
		INEQ__Equipment_WBowQuests.AddForm(AbilityAlias_WBow)
	endif
	if AbilityAlias_WDagger && INEQ__Equipment_WDaggerQuests.Find(AbilityAlias_WDagger) == -1
		INEQ__Equipment_WDaggerQuests.AddForm(AbilityAlias_WDagger)
	endif
	if AbilityAlias_WSword && INEQ__Equipment_WSwordQuests.Find(AbilityAlias_WSword) == -1
		INEQ__Equipment_WSwordQuests.AddForm(AbilityAlias_WSword)
	endif

EndFunction
;___________________________________________________________________________________________________________________________

; Checks to see if the Quests passed as parameters were properly added
bool Function AllNotAdded()

	if RechargeSource && INEQ__RechargeSourceList.Find(RechargeSource) == -1
		return true
	endif
	if AbilitiesToPlayer && INEQ__AbilitiesToPlayerList.Find(AbilitiesToPlayer) == -1
		return true
	endif
	
	
	if AbilityAlias_Body && INEQ__Equipment_BodyQuests.Find(AbilityAlias_Body) == -1
		return true
	endif
	if AbilityAlias_Feet && INEQ__Equipment_FeetQuests.Find(AbilityAlias_Feet) == -1
		return true
	endif
	if AbilityAlias_Hands && INEQ__Equipment_HandsQuests.Find(AbilityAlias_Hands) == -1
		return true
	endif
	if AbilityAlias_Head && INEQ__Equipment_HeadQuests.Find(AbilityAlias_Head) == -1
		return true
	endif
	if AbilityAlias_Shield && INEQ__Equipment_ShieldQuests.Find(AbilityAlias_Shield) == -1
		return true
	endif
	if AbilityAlias_WBow && INEQ__Equipment_WBowQuests.Find(AbilityAlias_WBow) == -1
		return true
	endif
	if AbilityAlias_WDagger && INEQ__Equipment_WDaggerQuests.Find(AbilityAlias_WDagger) == -1
		return true
	endif
	if AbilityAlias_WSword && INEQ__Equipment_WSwordQuests.Find(AbilityAlias_WSword) == -1
		return true
	endif
	
	return false
EndFunction
