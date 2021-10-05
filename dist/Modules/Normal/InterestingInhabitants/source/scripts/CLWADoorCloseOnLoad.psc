Scriptname CLWADoorCloseOnLoad extends ObjectReference  
{Opens or closes the attached ref on cell load
Inspired by MGGateTriggerScript}

Bool Property pOpenOrClosedBool = false  Auto
{Whether the door should be open instead of closed.

True = Open
False = Closed}
ObjectReference Property pRefToDisable  Auto
{Included to allow for mid-game installs. Disables target ref on init}

Event OnInit()
    if pRefToDisable
        pRefToDisable.DisableNoWait(false)
    endif
EndEvent

Event OnCellAttach()
    if (self as ObjectReference).GetOpenState() != 3
        (self as ObjectReference).SetOpen(false)
    endif
EndEvent
