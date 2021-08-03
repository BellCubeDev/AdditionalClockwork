Scriptname CLWATakeAxe extends ObjectReference  
{Grabs a required item from the surrounding area. Attach to the same object ResourceFurnitureScript is attached to.}

formlist Property requiredItemList Auto
{List of items for the attached ResourceFurnitureScript that the script will take if needed}
Formlist Property preferredItemList Auto  
{List of items that the script will prefer to take}
Message Property TookItemMessage Auto  
{Message to say that a required item was grabbed from somewhere nearby}
Message Property FailureMessage Auto  
{Message to show when the script cannot find any required item. Make sure to use an empty message in ResourceFurnitureScript!}
Int Property SearchRadius Auto
{How far to search for a viable item}
ObjectReference ThatItem

Event OnUnload()
	UnRegisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")
endEvent

auto state Ready
    Event OnActivate(ObjectReference akActionRef)
        ThatItem = None
        If Game.GetPlayer() == akActionRef
            If akActionRef.GetItemCount(requiredItemList) == 0
                if preferredItemList
                    ThatItem = Game.FindClosestReferenceOfAnyTypeInListFromRef(preferredItemList, akActionRef, SearchRadius)          
                endif
                if ThatItem == None
                    ThatItem = Game.FindClosestReferenceOfAnyTypeInListFromRef(requiredItemList, akActionRef, SearchRadius)
                endif
                if ThatItem
                    TookItemMessage.Show()
                    akActionRef.AddItem(ThatItem.GetBaseObject(), 1, 1)
                    ThatItem.Disable(1)
                    Activate(akActionRef, 1)
                    RegisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")
                    gotoState("Working")
                else
                    FailureMessage.Show()
                endif
            endif
        endif
    endEvent
endState

state working
    Event OnAnimationEvent(ObjectReference akSource, string asEventName)
        if Game.GetPlayer() == akSource && asEventName && asEventName == "IdleFurnitureExit"
            if ThatItem
                akSource.RemoveItem(ThatItem.GetBaseObject(), 1)
                ThatItem.Enable(1)
                ThatItem = None
            endif
            UnRegisterForAnimationEvent(akSource, asEventName)
            gotoState("Ready")
        endif
    endEvent
endState