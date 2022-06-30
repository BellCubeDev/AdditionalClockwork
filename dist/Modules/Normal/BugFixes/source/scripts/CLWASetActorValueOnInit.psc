Scriptname CLWASetActorValueOnInit extends ActiveMagicEffect  
{Sets the specified actor values on init, up to 2}

String[] Property pAVsToSet  Auto
{ActorValues to set}
Float[] Property pNewValues  Auto
{New values for the above-defined Actor Values}

; Event received when this effect is first started (OnInit may not have been run yet!)
Event OnEffectStart(Actor akTarget, Actor akCaster)
    Int iMax = pAVsToSet.length
    
    If iMax != pNewValues.length
        Debug.trace("[BCD-CLWA] Error: Number of Actor Values to set does not match number of new values", 2)
        return
    EndIf

    Int i = 0
    While i < iMax
        Debug.Trace("[BCD-CLWA] Forcing Actor Value " + pAVsToSet[i] + " to " + pNewValues[i] + "on Actor " + akTarget +"(\"" + akTarget.GetName() + "\")")
        ;akTarget.ForceActorValue(pAVsToSet[i], pNewValues[i])
        i += 1
    EndWhile
EndEvent
