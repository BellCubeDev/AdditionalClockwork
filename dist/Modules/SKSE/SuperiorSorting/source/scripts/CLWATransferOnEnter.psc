Scriptname CLWATransferOnEnter extends ObjectReference  
{When the trigger is entered, transfer all items to this container
If successful, removes all items from target container, optionally sending to a second container.}

Float Property pValueToCheckAgainst = 1.0 Auto  
{Value used in the compareop to check the Global. True if equal to pGlobalToCheck's value.
Debaults to 1}
GlobalVariable Property pGlobalToCheck  Auto  
{Global used in the compareop. True if equal to pValueToCheckAgainst}
ObjectReference[] Property pRemovalContainers  Auto
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

    ; Early Return conditions
    if                       ;/
        Check for the player /; !(!pRequirePlayer || akActionRef == Game.GetPlayer()) && ;/
            Check the Global /; pGlobalToCheck.GetValue() != pValueToCheckAgainst
        return
    EndIf


    If pDestinationContainer ; If pDestinationContainer is filled, transfer the items and play the sound there
        Bool PlaySound = False ; Set to true if items are transfered

        Int i = 0
        Int iMax = pRemovalContainers.Length
        While i < iMax
            If pRemovalContainers[i].GetNumItems() > 0 
                pRemovalContainers[i].RemoveAllItems(pDestinationContainer, false, false)
            EndIf
        EndWhile
        if pSoundToPlay && PlaySound
            pSoundToPlay.Play(pDestinationContainer)
        endif
        return
    EndIf

    ; If pDestinationContainer is not filled, remove items from and play the sound at the removal containers

    Int i = 0
    Int iMax = pRemovalContainers.Length

    if pSoundToPlay ; Removes items and plays the sound
        While i < iMax
            pRemovalContainers[i].RemoveAllItems(None, None, false)
            pSoundToPlay.Play(pRemovalContainers[i])
        EndWhile
    else ; Removes items, skipping sound-playing
        While i < iMax
            pRemovalContainers[i].RemoveAllItems(None, None, false)
        EndWhile
    endif
endevent