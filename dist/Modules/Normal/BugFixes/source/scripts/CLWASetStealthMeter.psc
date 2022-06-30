Scriptname CLWASetStealthMeter Extends ObjectReference
{Script to set the "Doesn't Affect Stealth Meter" flag on the specified actor(s)}

Actor[] Property akActors  Auto
{The actors to set the flag on}
Bool Property flagState = True  Auto
{The state to set the flag to. Defaults to True

True = Don't affect stealth meter
False = Affect stealth meter}


Event OnInit()
    Int iMax = akActors.Length

    If iMax < 0
        Actor selfAsActor = (self as ObjectReference) as Actor
        If selfAsActor
            selfAsActor.SetNotShowOnStealthMeter(flagState)
        EndIf
        return
    EndIf

    Int i = 0
    While i < iMax
        akActors[i].SetNotShowOnStealthMeter(flagState)
        i = i + 1
    EndWhile
EndEvent
