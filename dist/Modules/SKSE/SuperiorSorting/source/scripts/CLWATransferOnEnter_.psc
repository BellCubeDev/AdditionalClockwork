Scriptname CLWATransferOnEnter_ extends ObjectReference
{When the trigger is entered, transfer all items to this container
If successful, removes all items from target container, optionally sending to a second container.}

Float Property pValueToCheckAgainst = 1.0 Auto
{Value used in the compareop to check the Global. True if equal to pGlobalToCheck's value.
Debaults to 1}
GlobalVariable Property pGlobalToCheck  Auto
{Global used in the compareop. True if equal to pValueToCheckAgainst}

Bool Property pRequirePlayer = True Auto
{Only function when the player enters?
Defaults to True}
Actor Property PlayerREF  Auto
{Reference to the Player. Only used if pRequirePlayer is True}

Sound Property pSoundToPlay  Auto
{Sound to play when transfer finishes
Played at pDestinationContainer if filled, otherwise at pRemovalContainer}

ObjectReference[] Property pRemovalContainers  Auto
{Container to remove all items from
Will throw Papyrus errors if not filled}
ObjectReference Property pDestinationContainer  Auto
{Optional container to transfer all items in pRemovalContainer to}

Event OnTriggerEnter(ObjectReference akActionRef)

    ; Early Return conditions
    If                       ;/
        Check for the player /; (!pRequirePlayer || akActionRef == PlayerREF) && ;/
            Check the Global /; pGlobalToCheck.GetValue() != pValueToCheckAgainst
        return
    EndIf


    If pDestinationContainer ; If pDestinationContainer is filled, transfer the items and then play the sound there

        Bool doPlaySound = \
        removeFromContainersAndPlaySound(pRemovalContainers, akSound = pSoundToPlay)

        If pSoundToPlay && doPlaySound
            pSoundToPlay.Play(pDestinationContainer)
        EndIf

        return
    EndIf

    ; If pDestinationContainer is not filled, remove items from and play the sound at the removal containers
    removeFromContainersAndPlaySound(pRemovalContainers, akSound = pSoundToPlay)

EndEvent

Bool Function removeFromContainersAndPlaySound(ObjectReference[] akContainers, ObjectReference akDestination = None, Sound akSound = None)
    Bool returnValue = False
    Int i = 0
    Int iMax = akContainers.Length


    if akSound ; We have a sound to play!
        While i < iMax
            If pRemovalContainers[i].GetNumItems() > 0
                akContainers[i].RemoveAllItems(akDestination, false, false)
                akSound.Play(akContainers[i])
                returnValue = True
            EndIf
        EndWhile


    Else ; no sound was passed
        While i < iMax
            If pRemovalContainers[i].GetNumItems() > 0
                akContainers[i].RemoveAllItems(akDestination, false, false)
                returnValue = True
            EndIf
        EndWhile


    EndIf

    return returnValue
EndFunction