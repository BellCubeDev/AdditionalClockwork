Scriptname CLWACourierDetectorTrigger extends ObjectReference
{Trigger used to detect the presence of the one-and-only Courier}

Location Property HoldingCell  Auto
{Auto-fillable location that the Courier is placed in by default}
ActorBase Property WICourierNPC  Auto
{Auto-fillable property for the Courier's base ref}

Function HandleCourier(ObjectReference akActionRef)
    If (akActionRef.GetEditorLocation() == HoldingCell) || ((akActionRef.GetBaseObject() as ActorBase) == WICourierNPC)
        akActionRef.MoveToMyEditorLocation()
    EndIf
EndFunction

Event OnTrigger(ObjectReference akActionRef)
    HandleCourier(akActionRef)
EndEvent

Event OnTriggerEnter(ObjectReference akActionRef)
    HandleCourier(akActionRef)
EndEvent
