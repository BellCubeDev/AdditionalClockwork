;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname CLWA_TIF__LaharPnumaticSystemDG Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
refToEnable.EnableNoWait(1)
CLWADGLaharBuildGemTransferState.SetValueInt(2)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Player.GetReference().RemoveItem(IngotDwarven, 13)
Player.GetReference().RemoveItem(IngotIron, 1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property Lahar  Auto  

ReferenceAlias Property Player  Auto  

MiscObject Property IngotDwarven  Auto

MiscObject Property IngotIron  Auto

ObjectReference Property RefToEnable  Auto  

GlobalVariable Property CLWADGLaharBuildGemTransferState  Auto  
