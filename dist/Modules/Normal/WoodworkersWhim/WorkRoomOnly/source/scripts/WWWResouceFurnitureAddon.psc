Scriptname WWWResouceFurnitureAddon extends ResourceFurnitureScript  Conditional
{Grabs a required item from the surrounding area. Attach in place of ResourceFurnitureScript.

This script effectively prepends code to ResourceFurnitureScript's own. It is 100% compatible with edits to ResourceFurnitureScript.}

Message Property ItemTakenMsg Auto  
{Message to say that a required item was grabbed from somewhere nearby}

Actor Property PlayerREF  Auto
ObjectReference[] lastActionRefs
Int lastActionRefIndexBackend
Int Property lastActionRefIndex Hidden
    Int Function Get()
        DebugTest()
        return lastActionRefIndexBackend
    EndFunction
    Function Set(Int aiNewValue)
        DebugTest()
        If aiNewValue < 0 || aiNewValue > 15
            lastActionRefIndexBackend = 0
        else
            lastActionRefIndexBackend = aiNewValue
        EndIf
    EndFunction
EndProperty

Keyword Property WWWQuestStartKWD  Auto
{Keyword used to send the event}

Quest Property WWWBackendQuest  Auto
{Backend quest that we expect to start with the script}
ReferenceAlias akAxe
ObjectReference akAxeRef
ReferenceAlias akBlockAlias

Bool working = true

GlobalVariable Property ConditionBool  Auto
{Global bool that is used to check if we should run the system at all}

GlobalVariable Property ConditionBoolNPCs  Auto
{Global bool that is used to check If we should run the system for NPCs too}

Event OnInit()
    Debug.StartScriptProfiling("CLWATakeAxe")
    DebugTest()
    ;Utility.WaitMenuMode(1)
    ;RegisterForModEvent("ModUpdateEvent15", "ModUpdateEvent15")
    Debug.Trace("[BCD-WWW] Registering For Updates at 15 second intervals...")
    ;SendModEvent("ModUpdateEvent15", "")
    lastActionRefs = new ObjectReference[8]
    akBlockAlias = WWWBackendQuest.GetAlias(1) as ReferenceAlias
    akAxe = WWWBackendQuest.GetAlias(2) as ReferenceAlias
    working = false
EndEvent

Event OnCellAttach()
    DebugTest()
    Debug.Trace("[BCD-WWW] Cell attached. Resetting.")
    preReturn()
EndEvent

Event OnCellDetach()
    DebugTest()
    Debug.Trace("[BCD-WWW] Cell detached. Resetting.")
    preReturn()
EndEvent

Function preReturnOnActivate(ObjectReference akActionRef)
    DebugTest()
    preReturn()
EndFunction

auto STATE normal
    Event OnBeginState()
        DebugTest()
    EndEvent

    Event OnEndState()
        DebugTest()
    EndEvent

    Function preReturnOnActivate(ObjectReference akActionRef)
        Debug.Trace("[BCD-WWW] Running ResourceFurnitureScript's OnActivate event...")
        (self as ResourceFurnitureScript).OnActivate(akActionRef)
        Debug.Trace("[BCD-WWW] Running ResourceFurnitureScript's OnActivate event finished.")
        preReturn()
    EndFunction

    Event OnActivate(ObjectReference akActionRef)
        DebugTest()
        Debug.Trace("[BCD-WWW] OnActivate received. akActionRef: " + akActionRef)
        If working || akAxeRef || IsFurnitureInUse()
            ;Debug.Trace("[BCD-WWW] Already working/in use. Returning. CAUSE:\n                          CAUSE:\n                                    working: " + working + "\n                                    akAxeRef: " + akAxeRef + "\n                                    IsFurnitureInUse: " + IsFurnitureInUse())
            return
        EndIf
        If ConditionBool.GetValue() == 0.0
            Debug.Trace("[BCD-WWW] MCM setting for this object is false. Returning.")
            preReturnOnActivate(akActionRef)
            return
        EndIf
        If akActionRef.GetItemCount(RequiredItemList) > 0
            preReturnOnActivate(akActionRef)
            return
        EndIf
        If !(akActionRef == PlayerREF || ConditionBoolNPCs.GetValue())
            Debug.Trace("[BCD-WWW] akActionRef is not PlayerREF and the MCM setting for NPCs on this object is false. Aborting action. akActionRef: " + akActionRef)
            preReturnOnActivate(akActionRef)
            return
        EndIf
        Debug.Trace("[BCD-WWW] Starting to look for a reference. Hold on tight!")
        working = true
        lastActionRefs[lastActionRefIndex] = akActionRef
        lastActionRefIndex += 1

        ; Begin Reference Aqqusition

        Debug.Trace("[BCD-WWW] Starting quest...")
        ; Send the start message with this refernce, waiting until the OK is recieved
        WWWQuestStartKWD.SendStoryEventAndWait(akRef1 = Self)

        ; ========================
        ; Failsafe - Quest Start
        ; ========================

            Int i = 10
            While !(WWWBackendQuest.IsStarting() || WWWBackendQuest.IsRunning()) && i
                i -= 1
                Debug.Trace("[BCD-WWW] Waiting for quest to enter startup. Tries left: " + i)
                Utility.WaitMenuMode(0.1)
            EndWhile

            If i == 0
                Debug.Trace("[BCD-WWW] Quest failed to start. Returning. akActionRef = " + akActionRef)
                preReturnOnActivate(akActionRef)
                return
            EndIf

            Debug.Trace("[BCD-WWW] Quest is at least starting.")

            i = 10
            While !WWWBackendQuest.IsRunning() && i
                i -= 1
                Debug.Trace("[BCD-WWW] Waiting for quest to start completely. Tries left: " + i)
                Utility.WaitMenuMode(0.1)
            EndWhile

            If i == 0
                Debug.Trace("[BCD-WWW] Failed to fully start quest. Returning. akActionRef = " + akActionRef)
                preReturnOnActivate(akActionRef)
                return
            EndIf

            Debug.Trace("[BCD-WWW] Quest started!")
            DebugTest()

        ; ========================
        ; Failsafe - Alias Retrieval
        ; ========================

            i = 3
            akAxeRef = akAxe.GetReference()
            While !akAxeRef && i
                akAxeRef = akAxe.GetReference()
                i -= 1
                Debug.Trace("[BCD-WWW] Trying to get axe reference, got " + akAxeRef + " (" + akAxeRef.GetBaseObject().GetName() + "), tries left: " + i)
                Utility.WaitMenuMode(0.1)
            EndWhile

            ; Stop the quest so it can be used again

            ; Stop Reference Aqqusition
        
            ; If we failed to find a reference, abandon ship!
            If !akAxeRef
                Debug.Trace("[BCD-WWW] Failed to get tracked item. ABANDOMING SHIP. akActionRef = " + akActionRef)
                preReturnOnActivate(akActionRef)
                return
            EndIf
            DebugTest()

        ; ========================
        ; Meat & Potatoes
        ; ========================
            
        Debug.Trace("[BCD-WWW] Got Reference: " + akAxeRef + " (" + akAxeRef.GetBaseObject().GetName() + ")")

        ; Show message
        If akActionRef == PlayerREF
            ItemTakenMsg.Show()
            Debug.Trace("[BCD-WWW] Player took item. Message show.")
        EndIf

        Debug.Trace("[BCD-WWW] Stopping quest.")
        WWWBackendQuest.Stop()
        DebugTest()

        ; Register for animation and *really* activate
        Debug.Trace("[BCD-WWW] Registering for animation and entering chopping mode...")

        ; Ensure that the script is ready for activation
        i = 10
        Debug.Trace("[BCD-WWW] Waiting for the script to be ready...")
        While GetState() != "normal" && i
            Debug.Trace("[BCD-WWW] Waiting for the script to be ready. Tries left: " + i)
            Utility.Wait(0.05)
            i -= 1
        EndWhile
        DebugTest()
        ; Go directly to ResourceFurnitureScript and pass the OnActivate.
        Debug.Trace("[BCD-WWW] Furniture interaction started. Finalizing OnActivate()")

        ; "Pick Up" the item
        Debug.Trace("[BCD-WWW] Picking up axe...")
        akActionRef.AddItem(akAxeRef.GetBaseObject(), 1,  ;/silent = /;true)
        akAxeRef.DisableNoWait()
        
        working = false

        parent.OnActivate(akActionRef)
    EndEvent
EndState

State busy
    Event OnBeginState()
        DebugTest()
        Debug.Trace("[BCD-WWW] Entered Busy state")
    EndEvent
    Event OnEndState()
        DebugTest()
        Debug.Trace("[BCD-WWW] Exited Busy state. So long and thanks for all the fish.")
    EndEvent
    ; Talk to the hand
EndState

; Will run regardless of the current state
Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    DebugTest()
    Debug.Trace("[BCD-WWW] Animation Event " + asEventName + " received from " + akSource)
    If asEventName == "IdleFurnitureExit"
        Debug.Trace("[BCD-WWW] Furniture interaction ended. Tieing up loose ends.")
        preReturn()
    EndIf
    parent.OnAnimationEvent(akSource, asEventName)
EndEvent

; Used to "take out the trash"

; Centralization - Return

Function preReturn()
    DebugTest()
    Debug.Trace("[BCD-WWW] Calling pre-return function.")
    working = true

    WWWBackendQuest.Stop()

    ObjectReference tempHoldAxeRef = akAxeRef
    
    If tempHoldAxeRef
        akAxeRef = None
        int i = 0
        int iMax = lastActionRefs.length
        while i < iMax
            if lastActionRefs[i]
                lastActionRefs[i].RemoveItem(tempHoldAxeRef.GetBaseObject(), 1, ;/silent = /;true)
            EndIf
            i += 1
            EndWhile
        Debug.Trace("[BCD-WWW] Replaced axe "+tempHoldAxeRef+". Clearing variable...")
    EndIf

    ;/
    Debug.Trace("[BCD-WWW] Unregestering for animation events.")
    int i = 0
    int iMax = lastActionRefs.length
    while i < iMax
        if lastActionRefs[i]
            UnRegisterForAnimationEvent(lastActionRefs[i], "IdleFurnitureExit")
        EndIf
        i += 1
    EndWhile
    /;

    Debug.Trace("[BCD-WWW] No longer working.")
    int i = 0
    int iMax = lastActionRefs.length
    while i < iMax
        lastActionRefs[i] = None
        i += 1
    EndWhile
    working = false
    
    ; Fancy disable!
    If tempHoldAxeRef
        tempHoldAxeRef.EnableNoWait()
    EndIf
EndFunction

;//;

Event ModUpdateEvent15(string eventName, string strArg, float numArg, Form sender)
    Debug.Trace("[BCD-WWW] ModUpdateEvent15 - Sending Debug info.")
    DebugTest()
    Utility.Wait(15)
    SendModEvent("ModUpdateEvent15", "", 15)
    Game.GetPlayer()

EndEvent

Function DebugTest()
    ;Debug.Trace("[BCD-WWW] Debug test.\nIs furniture in use? " + self.IsFurnitureInUse(false) + ". And ignoring reserved? " + self.IsFurnitureInUse(true) + "\nIs working? " + working + "\nLast action refs: " + lastActionRefs + "\nLast action ref index: " + lastActionRefIndex + "\nAkAxeRef: " + akAxeRef + "\nCurrent State: " + GetState() + "\nIs Quest Running? " + WWWBackendQuest.IsRunning())
EndFunction
;//;
;  + "\nParen's State: " + parent.GetState()
