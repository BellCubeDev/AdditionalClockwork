Scriptname CLWADefaultBlock1RaceFromActivating extends ObjectReference  
{Prevents members of a specific race from activating this object
Extremely specialized version of defaultNoFollowDoorScript}

Event OnInit()
	BlockActivation()
EndEvent

Event OnActivate(ObjectReference akActionRef)
    If IsActivationBlocked()
        ActorBase aBase = akActionRef.GetBaseObject() as ActorBase
        Debug.Trace("If "+aBase+" && ("+aBase.GetRace()+" != "+CLWGildedRace+")")
        If aBase && (aBase.GetRace() != CLWGildedRace)
            Debug.Trace("Allowing "+aBase.GetName()+" to activate "+GetName())
            Activate(akActionRef, true)
        Else
            Debug.Trace("Blocking "+aBase.GetName()+" from activating "+GetName())
        EndIf
    Else
        Debug.Trace("Activation not blocked.")
    EndIf
EndEvent

Race Property CLWGildedRace  Auto
{Race to prevent from activating}
