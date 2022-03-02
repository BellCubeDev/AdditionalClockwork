Scriptname CLWAInjectAxe extends ObjectReference  
{Injects this object to CLWDisplayCont01SCRIPT (since it requires the axe to come from the player...)}

CLWDisplayCont01SCRIPT Property AxeMountCont  Auto

Event OnInit()
    Form baseObject = self.GetBaseObject()
    If AxeMountCont.AllowedItems(baseObject)
        AxeMountCont.MountCurrentItem(baseObject, self)
    EndIf
EndEvent

