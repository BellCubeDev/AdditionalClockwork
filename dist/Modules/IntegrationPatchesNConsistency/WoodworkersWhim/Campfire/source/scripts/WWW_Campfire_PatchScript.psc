Scriptname WWW_Campfire_PatchScript extends ObjectReference  Conditional
{Small script to patch WWWResourceFurnitureScript to add Camptire's stuff back in.

It would be rather simple if it weren't for the fact that I'm using updates, too...}

Quest property _Camp_MainQuest auto
FormList property woodChoppingAxes auto
Actor property PlayerRef auto

weapon EquippedWeapon
Bool isPlayer

Event OnActivate(ObjectReference akActionRef)
    If akActionRef == PlayerREF
        isPlayer = True
    EndIf
EndEvent

Event OnUpdate()
	bool hasBaseObject = self.GetBaseObject()
	if !hasBaseObject
		Debug.Trace("[BCD-WWW-Campfire] Invalid registration detected. You should run 'ClearInvalidRegistrations' from the console while playing using SKSE in order to fix this.", 2)
        return
	endif

	if self.IsFurnitureInUse()
		;Debug.Trace("[BCD-WWW] I am in use by the player!")
		(_Camp_MainQuest as _Camp_ConditionValues).IsChoppingWood = true
		if woodChoppingAxes.HasForm(PlayerRef.GetEquippedWeapon())
			EquippedWeapon = PlayerRef.GetEquippedWeapon()
			PlayerRef.UnequipItem(EquippedWeapon as Form, abSilent = true)
		endif
	else
		;Debug.Trace("[BCD-WWW] I am not in use by the player!")
		(_Camp_MainQuest as _Camp_ConditionValues).IsChoppingWood = false
		if EquippedWeapon != none
			PlayerRef.EquipItem(EquippedWeapon as Form, abSilent = true)
			EquippedWeapon = none
            isPlayer = false
		endif
	endif
EndEvent
