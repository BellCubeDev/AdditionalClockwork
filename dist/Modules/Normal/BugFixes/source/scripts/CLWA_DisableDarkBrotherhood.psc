Scriptname CLWA_DisableDarkBrotherhood Extends ReferenceAlias
{A simple-enough script to prevent the Dark Brotherhood from abducting the player during the Clockwork questline.}

pDBEntranceQuestScript Property DBEntranceQuest  Auto
Quest Property CLWStory04Quest  Auto

Location Property CLWClockworkCastleIntLocation  Auto
Location Property CLWClockworkCastleExtLocation  Auto
Location Property CLWNurnduralInt01Location  Auto
Location Property CLWVelothiTunnelsIntLocation  Auto

Int sleepyTime_stored = 8311

function changeState(bool shouldDarkBrotherhoodBeDisabled, bool doStateCheck = true)
    if (shouldDarkBrotherhoodBeDisabled)
        if (DBEntranceQuest.pSleepyTime == 8311)
            Debug.Trace("[BCD-CLWA] Dark Brotherhood quest still disabled while on Clockwork's inaccessible land.")
            return
        endIf
    else
        if (sleepyTime_stored == 8311)
            ;Debug.Trace("[BCD-CLWA] Setting abandoned - we're still not in Clockwork-added ground")
            return
        endIf
    endIf

    If (doStateCheck && CLWStory04Quest.IsCompleted())
        if (GetState() != "questFinished") ; don't enter into an infinite loop attempting the next line
            GoToState("questFinished") ; stop getting events after we handle this
        endIf
        shouldDarkBrotherhoodBeDisabled = false ; make sure we reconcile state correctly
        Debug.trace("[BCD-CLWA] Deactivating CLWA_DisableDarkBrotherhood event listener. Enjoy the reclaimed Papryus script budget!")
    EndIf

    if (shouldDarkBrotherhoodBeDisabled)
        sleepyTime_stored = DBEntranceQuest.pSleepyTime
        DBEntranceQuest.pSleepyTime = 8311
        Debug.Trace("[BCD-CLWA] Dark Brotherhood quest is now disabled.")
    else
        DBEntranceQuest.pSleepyTime = sleepyTime_stored
        sleepyTime_stored = 8311
        Debug.Trace("[BCD-CLWA] Dark Brotherhood quest has been re-enabled.")
    endIf

    ;Debug.Trace("[BCD-CLWA] After setting shouldDarkBrotherhoodBeDisabled="+shouldDarkBrotherhoodBeDisabled+" - sleepyTime_stored: " + sleepyTime_stored + ", DBEntranceQuest.pSleepyTime: " + DBEntranceQuest.pSleepyTime)
endFunction

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
EndEvent

Auto State normal
    Event OnLocationChange(Location akOldLoc, Location akNewLoc)
        ;Debug.Trace("[BCD-CLWA] CLWA_DisableDarkBrotherhood: OnLocationChange: " + akOldLoc.GetName() + " -> " + akNewLoc.GetName())
        ;Debug.Trace("[BCD-CLWA] Before setting - sleepyTime_stored: " + sleepyTime_stored + ", DBEntranceQuest.pSleepyTime: " + DBEntranceQuest.pSleepyTime)

        bool isOnClockworkGrounds = \
            akNewLoc == CLWClockworkCastleIntLocation \
            || akNewLoc == CLWClockworkCastleExtLocation \
            || akNewLoc == CLWNurnduralInt01Location \
            || akNewLoc == CLWVelothiTunnelsIntLocation

        changeState(isOnClockworkGrounds)
    EndEvent

    event OnEndState()
        changeState(false, false) ; for some extra safety
    endEvent
EndState

State questFinished
    ; Empty state used when quest is completed to prevent the script from causing any more unnecessary script lag
EndState
