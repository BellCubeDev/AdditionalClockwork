Scriptname CLWAInjectAxe extends ObjectReference  
{Injects this object to CLWDisplayCont01SCRIPT (since it requires the axe to come from the player...)}

CLWDisplayCont01SCRIPT Property AxeMountCont  Auto
{The container with the display script}
Bool Property CheckCompatibility = True Auto
{Will the script check if the item is allowed first?
Default: True}

Auto State Ready
    Event OnCellAttach()
        Form baseObject = self.GetBaseObject()
        If AxeMountCont.AllowedItems(baseObject)
            AxeMountCont.MountCurrentItem(baseObject, self)
        EndIf
        GoToState("Fired")
    EndEvent
EndState

State Fired
    ; We're done here, Jim!
EndState
