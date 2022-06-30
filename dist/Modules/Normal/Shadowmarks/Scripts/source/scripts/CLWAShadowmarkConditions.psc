Scriptname CLWAShadowmarkConditions extends ObjectReference  
{On cell attach (NOT load), checks two quest's stage. If they are both at or above a certain stage, enable the attached ref

For info on cell attachments/detachments, see https://ck.uesp.net/wiki/OnCellAttach_-_ObjectReference}

Quest Property ThievesGuildMemberQuest  auto
{Thieves' Guild quest to get the stage of}
Int Property ThievesGuildMemberQuestStage  auto
{Thieves' Guild quest stage to check for}
Quest Property HomeOwnershipQuest  auto
{Quest to check if the player owns the home}
Int Property HomeOwnershipQuestStage  auto
{Quest stage to check if the player owns the home}

Auto State NotGuildMember
	Event OnCellAttach()
	; Fires more reliably than OnCellLoad()
		If HomeOwnershipQuest.GetStage() >= HomeOwnershipQuestStage && ThievesGuildMemberQuest.GetStage() >= ThievesGuildMemberQuestStage
			self.Enable(1)
			; Enables the reference this script is attached to
			GoToState("GuildMember")
			; See comment in GuildMember state
		EndIf
	EndEvent
EndState

State GuildMember
; Empty state used to stop the check from running and using compute power and increasing script load once the conditions have been fulfilled
EndState