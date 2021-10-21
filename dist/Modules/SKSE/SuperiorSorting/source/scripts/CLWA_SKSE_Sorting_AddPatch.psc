Scriptname CLWA_SKSE_Sorting_AddPatch Extends ObjectReference
{Takes two FormLists and adds the items from one into the other}

FormList Property pListToAddFrom  Auto
{FormList that is emptied on event}
FormList Property pFormListToAddTo Auto

Event OnInit()
    CLWARegisterPatches("Register Patches", "CLWARegisterPatches", 0, self)
    RegisterForModEvent("Register Patches", "CLWARegisterPatches") ; This event is sent on game load.
endevent
 
Event CLWARegisterPatches(string eventName, string strArg, float numArg, Form sender)
    Form[] Forms = pListToAddFrom.ToArray()
    int arrayLength = Forms.Length
    int i = 0
    bool needsPLReset = false

    ; Checks if everything is already in the PassLists. If not, order a reset of the PassedLists and add everything to 
    while i < arrayLength && !needsPLReset
        if !pFormListToAddTo.HasForm(Forms[i])
            needsPLReset = true
        endif
        i += 1
    endwhile

    if needsPLReset
        CLWA_SKSE_Sorting.ResetPassedLists()
        pFormListToAddTo.AddForms(Forms)
    endif
EndEvent
