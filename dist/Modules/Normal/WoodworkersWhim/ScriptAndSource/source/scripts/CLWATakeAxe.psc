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
ObjectReference TrackedItem

Event OnUnload()
	UnRegisterForAnimationEvent(Game.GetPlayer(), "IdleFurnitureExit")
endEvent

auto state Ready
    Event OnActivate(ObjectReference akActionRef)
        TrackedItem = None
        If Game.GetPlayer() == akActionRef
            If akActionRef.GetItemCount(requiredItemList) == 0

                if preferredItemList
                    TrackedItem = Game.FindClosestReferenceOfAnyTypeInListFromRef(preferredItemList, akActionRef, SearchRadius)          
                endif

                if !TrackedItem
                    TrackedItem = Game.FindClosestReferenceOfAnyTypeInListFromRef(requiredItemList, akActionRef, SearchRadius)
                endif
                
                if TrackedItem
                    TookItemMessage.Show()
                    akActionRef.AddItem(TrackedItem.GetBaseObject(), 1, 1)
                    TrackedItem.DisableNoWait(True)
                    Utility.Wait(0.1)
                    Activate(akActionRef, True)

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
            if TrackedItem
                akSource.RemoveItem(TrackedItem.GetBaseObject(), 1)
                TrackedItem.Enable(1)
                TrackedItem = None
            endif
            UnRegisterForAnimationEvent(akSource, asEventName)
            gotoState("Ready")
        endif
    endEvent
endState