;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname CLWA_TIF__LaharInitBuildGemTransfer Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
CLWADGLaharBuildGemTransferState.SetValueInt(1)
(XMarkerConvoChecker as CLWACheckForPluginOnLoadSKSE).pCheckOnAttachEnabled = False
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property CLWADGLaharBuildGemTransferState  Auto  

ObjectReference Property XMarkerConvoChecker  Auto  
