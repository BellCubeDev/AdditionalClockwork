;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname CLW0_QF_CLWKicker01Quest_0205F6C9 Extends Quest Hidden

;BEGIN ALIAS PROPERTY TRIGGER
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TRIGGER Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldImperial
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldImperial Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldContested
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldContested Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CenterMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CenterMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Note
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Note Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myHoldSons
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_myHoldSons Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY IsidorAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_IsidorAlias Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Scene_Marker2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Scene_Marker2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Scene_Marker1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Scene_Marker1 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
    ;Debug.MessageBox("CLWKicker stage 255")
    ; debug.trace(self + "stage 255, calling DeleteWhenAble() on created aliases")
    Alias_IsidorAlias.GetReference().DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
    SetObjectiveCompleted(10)
    SetObjectiveDisplayed(20, 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
    SetObjectiveDisplayed(10, 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
    CompleteAllObjectives()
    Alias_IsidorAlias.GetReference().Disable()
    Alias_IsidorAlias.GetReference().DeleteWhenAble()
    pMyQuest.Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
    Alias_IsidorAlias.GetReference().AddItem(Alias_Note.GetReference())
    ;Debug.MessageBox("CLWKicker stage 0")
    pStage40Trigger.enable()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE

    ; BellCube - Fixes the bug where the note would set the stage directly to 30, leaving the Objective at stage 10 as incomplete.
    SetObjectiveCompleted(10)

    SetObjectiveCompleted(20)
    SetObjectiveDisplayed(30, 1)
    pMapMarker.AddToMap()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property pMapMarker  Auto

Quest Property pMyQuest  Auto

ObjectReference Property pStage40Trigger  Auto
