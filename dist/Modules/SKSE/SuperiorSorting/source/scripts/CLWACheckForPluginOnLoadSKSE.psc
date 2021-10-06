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
Bool Property bIsModPresent Auto Hidden Conditional
{Toggles with the state of the specified plugin}

Event OnInit()
    RegisterForSingleUpdate(0.001) ; Registers for an update that processes almost imedieately to deffer processing
endevent

Event OnUpdate()
    ; This event is only called once by the script itself,
    ; though other scripts _can_ cause an update.
    ; It is thus not adviseable to attach alongside a script that registers updates
    int targetPluginIndex = Game.GetModByName(pPluginName)
    if targetPluginIndex > 0 && targetPluginIndex < 255 ; then the mod IS present
        bIsModPresent = True
        if pRefToEnableDisable && AllowEnableRef
            pRefToEnableDisable.EnableNoWait()
        endif
    else ; The mod is NOT present
        bIsModPresent = False
        if pRefToEnableDisable && AllowDisableRef
            pRefToEnableDisable.DisableNoWait()
        endif
    endif

    ; Check if we should process cell attachment too
    if pCheckOnAttach
        gotostate("AttachProcessing")
    endif
endevent

State AttachProcessing
    ; State used to enable processing of OnCellAttach if designated,
    ; or keep it disabled to prevent processing and reduce script load
    Event OnCellAttach()
        if Game.GetModByName(pPluginName) > 0 && pCheckOnAttachEnabled
            bIsModPresent = True
            if pRefToEnableDisable
                pRefToEnableDisable.EnableNoWait()
            endif
        else
            bIsModPresent = False
            if pRefToEnableDisable
                pRefToEnableDisable.DisableNoWait()
            endif
        endif
    endevent
endstate