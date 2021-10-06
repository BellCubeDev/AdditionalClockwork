Scriptname CLWATransferOnEnter extends ObjectReference  
{When the attached ref is 3D loaded, runs a check using a global.
If successful, removes all items from target container, optionally sending to a second container.}

Float Property pValueToCheckAgainst = 1.0 Auto  
{Value used in the compareop to check the Global. True if equal to pGlobalToCheck's value.
Debaults to 1}
GlobalVariable Property pGlobalToCheck  Auto  
{Global used in the compareop. True if equal to pValueToCheckAgainst}
ObjectReference Property pRemovalContainer  Auto
{Container to remove all items from
Will throw Papyrus errors if not filled}
ObjectReference Property pDestinationContainer  Auto
{Optional container to transfer all items in pRemovalContainer to}
Sound Property pSoundToPlay  Auto
{Sound to play when transfer finishes
Played at pDestinationContainer if filled, otherwise at pRemovalContainer}
Bool Property pRequirePlayer = True Auto
{Only function when the player enters?
Defaults to True}

Event OnTriggerEnter(ObjectReference akActionRef)
    if;/ Check for the player /;(!pRequirePlayer || akActionRef == Game.GetPlayer()) && ;/ Heh, multi-line IF statement. That's cursed.
        Check the Global /; pGlobalToCheck.GetValue() == pValueToCheckAgainst && ;/
        Check if the container has any items/; pRemovalContainer.GetNumItems() > 0 

        if pDestinationContainer ; If pDestinationContainer is filled, transfer the items and play the sound there
            pRemovalContainer.RemoveAllItems(pDestinationContainer, false, false)
            if pSoundToPlay
                pSoundToPlay.Play(pDestinationContainer)
            endif
        else ; Otherwise delete the items and play the sound at the source container
            pRemovalContainer.RemoveAllItems(None, false, false)
            if pSoundToPlay
                pSoundToPlay.Play(pRemovalContainer)
            endif
        endif
    endif
endevent