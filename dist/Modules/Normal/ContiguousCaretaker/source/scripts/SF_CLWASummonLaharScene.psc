;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_CLWASummonLaharScene Extends Scene Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
if pStageCheckGTRQuest.GetStage() > pStageCheckGTRValue
    pFailureMessage.Show()
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property pFailureMessage  Auto  
{Message to show if the quest stage does not meet the threshold}

Quest Property pStageCheckGTRQuest  Auto  
{Quest to check the stage of (Greater Than comparison)}

Int Property pStageCheckGTRValue  Auto  
{Stage to check for (Greater Than comparison)}
