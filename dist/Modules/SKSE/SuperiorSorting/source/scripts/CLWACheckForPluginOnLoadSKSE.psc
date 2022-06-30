Scriptname CLWACheckForPluginOnLoadSKSE Extends ObjectReference Conditional
{Checks for a plugin on init, and optionally on cell attach.
Sets a property and optionally enables/disables a ref
Assumes that you are not checking for the plugin at index 0}

Bool Property pCheckOnAttach = False Auto
{If false, onyl checks once. If true, checks every time.}
Bool Property pCheckOnAttachEnabled = True Auto Conditional
{Used to dynamicaly enable/disable the Attachment check}
String Property pPluginName Auto
{Will alway fail if name is "Skyrim.esp" (even if SKSE is not installed)}
ObjectReference Property pRefToEnableDisable Auto
{Optional ref to disable}
Bool Property AllowDisableRef = True Auto
{Allow the script to disable this ref?}
Bool Property AllowEnableRef = True Auto
{Allow the script to enable this ref?}
Bool Property bIsModPresent Hidden
{Toggles with the state of the specified plugin}
    Bool Function Get()
        return Game.IsPluginInstalled(pPluginName)
    EndFunction
EndProperty

Float Property pValueToCheckAgainst = 1.0 Auto  
{GOPTIONAL. Value used in the compareop to check the Global. True if equal to pGlobalToCheck's value.
Debaults to 1}
GlobalVariable Property pGlobalToCheck  Auto  
{OPTIONAL. Global used in the compareop. True if equal to pValueToCheckAgainst}


Event OnInit()    
    DoEnableDisableToggle(bIsModPresent && (!pGlobalToCheck || pGlobalToCheck.GetValue() == pValueToCheckAgainst))

    if pCheckOnAttach
        gotostate("AttachProcessing")
    endif
endevent

State AttachProcessing
    ; State used to enable processing of OnCellAttach if designated,
    ; or keep it disabled to prevent processing and reduce script load
    Event OnCellAttach()
        if !pCheckOnAttachEnabled
            return
        EndIf

        DoEnableDisableToggle(bIsModPresent && (!pGlobalToCheck || pGlobalToCheck.GetValue() == pValueToCheckAgainst))
    EndEvent
EndState

Function DoEnableDisableToggle(Bool abCondition = true)
    if abCondition
        if pRefToEnableDisable && AllowEnableRef
            pRefToEnableDisable.EnableNoWait()
        endif
    else
        if pRefToEnableDisable && AllowDisableRef
            pRefToEnableDisable.DisableNoWait()
        endif
    endif
EndFunction