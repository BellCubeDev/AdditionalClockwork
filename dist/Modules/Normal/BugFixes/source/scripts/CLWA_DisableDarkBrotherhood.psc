Scriptname CLWA_DisableDarkBrotherhood Extends ReferenceAlias
{A simple-enough script to prevent the Dark Brotherhood from abducting the player during the Clockwork questline.}

pDBEntranceQuestScript Property DBEntranceQuest  Auto
Quest Property CLWStory04Quest  Auto

Location Property CLWClockworkCastleIntLocation  Auto
Location Property CLWClockworkCastleExtLocation  Auto
Location Property CLWNurnduralInt01Location  Auto
Location Property CLWVelothiTunnelsIntLocation  Auto

Int sleepyTime_stored = 8311

Event OnInit()
    DBEntranceQuest = DBEntranceQuest as pDBEntranceQuestScript
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
EndEvent

Auto State normal

    ; Since
    Event OnLocationChange(Location akOldLoc, Location akNewLoc)
        ;Debug.Trace("[BCD-CLWA] CLWA_DisableDarkBrotherhood: OnLocationChange: " + akOldLoc.GetName() + " -> " + akNewLoc.GetName())
        ;Debug.Trace("[BCD-CLWA] Before setting - sleepyTime_stored: " + sleepyTime_stored + ", DBEntranceQuest.pSleepyTime: " + DBEntranceQuest.pSleepyTime)
        If akNewLoc == CLWClockworkCastleIntLocation || akNewLoc == CLWClockworkCastleExtLocation || akNewLoc == CLWNurnduralInt01Location || akNewLoc == CLWVelothiTunnelsIntLocation
            If DBEntranceQuest.pSleepyTime == 8311
                ;Debug.Trace("[BCD-CLWA] Setting abandoned - we're still on Clockwork Castle land")
                return
            EndIf

            ; I put these checks at the last layer because they are the only function calls in the whole script - and therefore contribute to script lag.
            If CLWStory04Quest.IsCompleted()
                GoToState("questFinished")
                return
            EndIf

            sleepyTime_stored = DBEntranceQuest.pSleepyTime
            DBEntranceQuest.pSleepyTime = 8311
            ;Debug.Trace("[BCD-CLWA] After setting - sleepyTime_stored: " + sleepyTime_stored + ", DBEntranceQuest.pSleepyTime: " + DBEntranceQuest.pSleepyTime)
            return
        EndIf

        If sleepyTime_stored == 8311
            ;Debug.Trace("[BCD-CLWA] Setting abandoned - we're still not in Clockwork-added ground")
            return
        EndIf

        ; I put these checks at the last layer because they are the only function calls in the whole script - and therefore contribute to script lag.
        If CLWStory04Quest.IsCompleted()
            GoToState("questFinished")
            return
        EndIf

        DBEntranceQuest.pSleepyTime = sleepyTime_stored
        sleepyTime_stored = 8311
        ;Debug.Trace("[BCD-CLWA] After setting - sleepyTime_stored: " + sleepyTime_stored + ", DBEntranceQuest.pSleepyTime: " + DBEntranceQuest.pSleepyTime)
    EndEvent
EndState

State questFinished
    ; Empty state used when quest is completed to prevent the script from causing any more  unnecessary script lag
EndState
