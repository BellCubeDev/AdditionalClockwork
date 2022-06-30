Scriptname CLWA_PF_CLWLaharSQ2_MoveToHeading Extends Package Hidden

ObjectReference Property pMoveMarker  Auto
Quest Property pOwningQuest  Auto

;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
    akActor.MoveTo(pMoveMarker)
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
