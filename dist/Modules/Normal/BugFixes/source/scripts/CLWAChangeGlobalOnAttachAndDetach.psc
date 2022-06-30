Scriptname CLWAChangeGlobalOnAttachAndDetach extends ObjectReference
{Changes a Global (variable) when the attached object's cell is attached or detached.
Globals and values to set are determined using properties

For info on cell attachments/detachments, see https://ck.uesp.net/wiki/OnCellAttach_-_ObjectReference}

GlobalVariable Property AttachGlobal  auto
{Global to set on attach}
Float Property AttachValue = 0.0 auto
{Value to set AttachGlobal to on attach}

GlobalVariable Property DetachGlobal  auto
{Global to set on detach}
Float Property DetachValue = 1.9 auto
{Value to set DetachGlobal to on detach. Overridden when RevertToPreviousValue is True}

Bool Property RevertToPreviousValue = true auto
{**ENABLED BY DEFAULT**
Whether or not to store the value of AttachGlobal inside DetachValue when attached and set DetachGlobal to it when detached}

; The function to call on OnCellAttach
Function Attach()
    If AttachGlobal.GetValue() == AttachValue
        return
    EndIf

    If RevertToPreviousValue == true
        DetachValue = AttachGlobal.GetValue()
    EndIf
    AttachGlobal.SetValue(AttachValue)
    GotoState("Attached")
EndFunction

; The function to call on OnCellDetach
Function Detach()
    DetachGlobal.SetValue(DetachValue)
    GotoState("Detached")
EndFunction


; And now, we do some WIZARDRY!
; Basically, don't allow another Attach event if we're already attached, and vice versa

; Default State
Auto State init
    Event OnCellAttach()
        Attach()
    EndEvent
    Event OnLoad()
        Attach()
    EndEvent

    Event OnCellDetach()
        Detach()
    EndEvent
    Event OnUnload()
        Detach()
    EndEvent
EndState

; State for when we're already attached
State Attached
    Event OnCellDetach()
        Detach()
    EndEvent
    Event OnUnload()
        Detach()
    EndEvent
EndState

; State for when we're not attached
State Detached
    Event OnCellAttach()
        Attach()
    EndEvent
    Event OnLoad()
        Attach()
    EndEvent
EndState
