Scriptname CLWA_AddPatch Extends Package
{Adds a vanilla-skyrim patch to the sorting lists.
Takes two arrays of FormLists as properties, one to add forms to and one to add them from.

Does NOT have much error checking because I assume you're not a noob. Just some basic "Oh yeah, you probably forgot that :)" is all that's included.}

FormList[] Property ListsToUse  Auto
{The FormLists to get forms from.
MAKE SURE TO USE THE SAME ORDER OF LISTS FOR BOTH PROPERTIES}
FormList[] Property ListsToAddTo  Auto
{The FormLists to add forms to.
MAKE SURE TO USE THE SAME ORDER OF LISTS FOR BOTH PROPERTIES}
FormList[] Property ListsToRemoveFrom  Auto
{Lists to remove items from in the same manner as ListsToAddTo. Useful for Superior Sorting's Sorted Lists.}

Bool Property DebugMode = False  Auto
{Log stuff to the Papyrus log?
BE SURE TO CLEAR WHEN DEBUGGING IS DONE!

Debug mode assumes SKSE is present.}

Event OnInit()

    Bool UseSKSE = skse.GetVersionRelease() && (skse.GetVersionRelease() == skse.GetScriptVersionRelease())

    DebugCheck(UseSKSE)

    If UseSKSE
        AddListsToListsSKSE(ListsToAddTo, ListsToUse)
        removeFormListContentsFromOtherListsSKSE(ListsToRemoveFrom, ListsToUse)
    Else
        AddListsToLists(ListsToAddTo, ListsToUse)
        removeFormListContentsFromOtherLists(ListsToRemoveFrom, ListsToUse)
    EndIf
EndEvent

; Prints to the log if debug mode is on.
; If SKSE is present, this will print the plugin author as well.
; Thanks to DavidJCobb (https://www.nexusmods.com/users/9663214) for the fancy hex math code!
Function DebugCheck(Bool UseSKSE)
    If !DebugMode
        return
    EndIf
    If UseSKSE
        Int MyID   = Self.GetFormID()
        Int Prefix = Math.RightShift(MyID, 0x18) ; keep only high byte
        String PluginAuthor
        String PluginName
        If Prefix == 0xFE ; If we're in an ESL...

            Prefix = Math.LogicalAnd(MyID, 0x00FFF000)
            Prefix = Math.RightShift(MyID, 0xC)
            ; your index should be (Prefix) relative to Game.GetLightModCount()
            PluginAuthor = Game.GetLightModAuthor(Prefix)
            PluginName = Game.GetLightModName(Prefix)
        Else
            ; your index is (Prefix) relative to Game.GetModCount()
            PluginAuthor = Game.GetModAuthor(Prefix)
            PluginName = Game.GetModName(Prefix)
        EndIf

        Debug.Trace("[CLWA_AddPatch - "+self+"]: DEBUG MODE IS ON! If this is left in enabled in a public release, please inform the author of \""+PluginName+"\", \""+PluginAuthor+"\"!")
        return
    EndIf
    Debug.Trace("[CLWA_AddPatch - "+self+"]: DEBUG MODE IS ON! If this is left in enabled in a public release, please inform the author of the plugin with the form "+self+"!")
EndFunction


; Removes all script-added forms from akListToRemoveFrom that are also in akListToRemove
Function removeFormListContentsFromOtherLists(FormList[] akListsToRemoveFrom, FormList[] akListsOfItemsToRemove)
    Int i = 0
    Int iMax = akListsToRemoveFrom.length

    If DebugMode
        Debug.Trace("[CLWA_AddPatch - "+self+"]: Started removing items from lists using vanilla Papyrus code")
        Form akTempForm
        while i < iMax
            Int j = 0
            Int jMax = akListsOfItemsToRemove[i].GetSize()
            Debug.Trace("[CLWA_AddPatch - "+self+"]: Removing " + jMax + " forms from list " + akListsToRemoveFrom[i])
            While j < iMax
                akTempForm = akListsOfItemsToRemove[i].GetAt(i)
                akListsToRemoveFrom[i].RemoveAddedForm(akTempForm)
                Debug.Trace("[CLWA_AddPatch - "+self+"]: Removed form "+akTempForm+" from list "+akListsToRemoveFrom[i])
                j += 1
            EndWhile
            i += 1
        EndWhile
        return
    EndIF

    while i < iMax
        Int j = 0
        Int jMax = akListsOfItemsToRemove[i].GetSize()
        While j < iMax
            akListsToRemoveFrom[i].RemoveAddedForm(akListsOfItemsToRemove[i].GetAt(i))
            j += 1
        EndWhile
        i += 1
    EndWhile

EndFunction


; Removes all script-added forms from akListToRemoveFrom that are also in akListToRemove
; Optimized with SKSE.
Function removeFormListContentsFromOtherListsSKSE(FormList[] akListsToRemoveFrom, FormList[] akListsOfItemsToRemove)
    Int i = 0
    Int iMax = akListsToRemoveFrom.length

    If DebugMode
        Debug.Trace("[CLWA_AddPatch - "+self+"]: Started removing items from lists using SKSE Papyrus code")
        while i < iMax
            Form[] akForms = akListsOfItemsToRemove[i].ToArray()
            Int j = 0
            Int jMax = akForms.Length
            Debug.Trace("[CLWA_AddPatch - "+self+"]: Removing " + jMax + " forms from list " + akListsToRemoveFrom[i])
            While j < iMax
                akListsToRemoveFrom[i].RemoveAddedForm(akForms[i])
                Debug.Trace("[CLWA_AddPatch - "+self+"]: Removed form "+akForms[i]+" from list "+akListsToRemoveFrom[i])
                j += 1
            EndWhile
            i += 1
        EndWhile
        return
    EndIF

    while i < iMax
        Form[] akForms = akListsOfItemsToRemove[i].ToArray()
        Int j = 0
        Int jMax = akForms.Length
        While j < iMax
            akListsToRemoveFrom[i].RemoveAddedForm(akForms[i])
            j += 1
        EndWhile
        i += 1
    EndWhile

EndFunction


; Adds all forms from one list to another with support for multiple options.
; Optimized with SKSE.
Function AddListsToListsSKSE(FormList[] listsToAddTo, FormList[] ListToAddFrom)
    Int ltatLength = listsToAddTo.Length
    Int ltafLength = ListToAddFrom.Length

    ; Verify list lengths
    If ltatLength != ltafLength
        Debug.TraceAndBox("[CLWA_AddPatch - "+self+"]: Lists To Add To and Lists To Use are not the same length! Perhaps you missed one?", 2)
        return
    EndIf

    Int i = 0

    If DebugMode
        ; Add lists to the other lists
        While i < ltatLength
            listsToAddTo[i].AddForms(ListToAddFrom[i].ToArray()) ; Nice, fast, and simple because SKSE
            Debug.Trace("[CLWA_AddPatch - "+self+"]: Added " + ListToAddFrom[i].GetSize() + " forms to " + listsToAddTo[i])
            i += 1
        EndWhile
        return
    EndIf

    ; Same thing as above, but with the debug message stripped out
    While i < ltatLength
        listsToAddTo[i].AddForms(ListToAddFrom[i].ToArray()) ; Nice, fast, and simple because SKSE
        i += 1
    EndWhile
EndFunction

; Adds all forms from one list to another with support for multiple options.
; Slower than the SKSE version because vanilla Papyrus is, well, vanilla.
Function AddListsToLists(FormList[] listsToAddTo, FormList[] ListToAddFrom)

    Int ltatLength = listsToAddTo.Length
    Int ltafLength = ListToAddFrom.Length

    ; Verify list lengths
    If ltatLength != ltafLength
        Debug.TraceAndBox("[CLWA_AddPatch - "+self+"]: Lists To Add To and Lists To Use are not the same length! Perhaps you missed one?", 2)
        return
    EndIf

    Int i = 0
    Int j

    ; Add lists to the other lists
    If DebugMode
        Debug.Trace("[CLWA_AddPatch - "+self+"]: Started patching using vanilla Papyrus code")
        while i < ltatLength
            Int flLength = ListToAddFrom[i].GetSize()
            Debug.Trace("[CLWA_AddPatch - "+self+"]: Adding " + flLength + " forms to list " + listsToAddTo[i])
            j = 0

            ; Ugly, slow, and much more complicated than it needs to be, because vanilla.
            While j < flLength
                listsToAddTo[i].AddForm(ListToAddFrom[i].GetAt(j))
                Debug.Trace("[CLWA_AddPatch - "+self+"]: Added form" + ListToAddFrom[i].GetAt(j) + " to " + listsToAddTo[i]+", #"+(j+1)+"/"+flLength)
                j += 1
            EndWhile
            Debug.Trace("[CLWA_AddPatch - "+self+"]: Added " + flLength + " forms to list " + listsToAddTo[i])
            i += 1
        EndWhile
        return
    EndIf

    ; Same thing as above, but with debug messages stripped out
    while i < ltatLength
        Int flLength = ListToAddFrom[i].GetSize()
        j = 0

        ; Ugly, slow, and much more complicated than it needs to be, because vanilla.
        While j < flLength
            listsToAddTo[i].AddForm(ListToAddFrom[i].GetAt(j))
            j += 1
        EndWhile
        i += 1
    EndWhile

EndFunction
