Scriptname CLWATransferOnEnter extends ObjectReference
{Empty script to allow the newer version of the script to work in older saves.
The new script is "CLWATransferOnEnter_.psc"

This script contains properties in an attempt to prevent some log spam}

Float Property pValueToCheckAgainst = 1.0 Auto
GlobalVariable Property pGlobalToCheck = None Auto
Bool Property pRequirePlayer = True Auto
Actor Property PlayerREF = None Auto
Sound Property pSoundToPlay = None Auto
ObjectReference[] Property pRemovalContainers = None Auto
ObjectReference Property pDestinationContainer = None Auto
