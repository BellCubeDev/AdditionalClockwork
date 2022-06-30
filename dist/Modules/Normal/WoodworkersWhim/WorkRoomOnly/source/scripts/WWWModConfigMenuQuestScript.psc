Scriptname WWWModConfigMenuQuestScript extends SKI_ConfigBase  
{Script to set up the MCM for Woodworker's Whim}

Bool Property allowOreVeins = false  Auto
{Included to allow the Clockwork-localized version to not use Ore Veins}

GlobalVariable[] Property WWW_SearchRadiusGlob  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Minimum
2 - Maximum
3 - Default}

GlobalVariable[] Property WWW_ChoppingBlock  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

GlobalVariable[] Property WWW_ChoppingBlock_NPCs  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

GlobalVariable[] Property WWW_OreVein  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

GlobalVariable[] Property WWW_OreVein_NPCs  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

GlobalVariable[] Property WWW_StoneQuarry  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

GlobalVariable[] Property WWW_StoneQuarry_NPCs  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

GlobalVariable[] Property WWW_ClayDeposit  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

GlobalVariable[] Property WWW_ClayDeposit_NPCs  Auto
{Global holding the range the system will search for an axe within
0 - Value-storing Global
1 - Default}

Message[] Property asLocalizationTable  Auto
{0 - Title & Header "Woodworker's Whim"
1  - WWW_SearchRadius Hint   "Range to search for an axe within.\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
2  - ChoppingBlock Hint      "Will the system search for items when interacting with Wood Chopping Blocks?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
3  - ChoppingBlock_NPCs Hint "Will the system search for items when NPCs use Wood Whopping Blocks well?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
4  - OreVein Hint            "Will the system search for items when interacting with Ore Veins?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
5  - OreVein_NPCs Hint       "Will the system search for items when NPCs use Ore Veins well?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
6  - StoneQuarry Hint        "Will the system search for items when interacting with Stone Quarries?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
7  - StoneQuarry_NPCs Hint   "Will the system search for items when NPCs use Stone Quarries well?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
8  - ClayDeposits Hint       "Will the system search for items when interacting with Clay Deposits?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
9  - ClayDeposits_NPCs Hint  "Will the system search for items when NPCs use Clay Deposits as well?\nDefault: %def%" (all occurances of %def% will be replaced with the default value as stored in the Global)
}



; Sets the Global to the default value
Event OnInit()
    ; Set the Globals to their default values
    WWW_SearchRadiusGlob[0].SetValue(WWW_SearchRadiusGlob[3].GetValue())
    WWW_ChoppingBlock[0].SetValue(WWW_ChoppingBlock[1].GetValue())
    WWW_ChoppingBlock_NPCs[0].SetValue(WWW_ChoppingBlock_NPCs[1].GetValue())
    WWW_OreVein[0].SetValue(WWW_OreVein[1].GetValue())
    WWW_OreVein_NPCs[0].SetValue(WWW_OreVein_NPCs[1].GetValue())
    WWW_StoneQuarry[0].SetValue(WWW_StoneQuarry[1].GetValue())
    WWW_StoneQuarry_NPCs[0].SetValue(WWW_StoneQuarry_NPCs[1].GetValue())
    WWW_ClayDeposit[0].SetValue(WWW_ClayDeposit[1].GetValue())
    WWW_ClayDeposit_NPCs[0].SetValue(WWW_ClayDeposit_NPCs[1].GetValue())
    parent.OnInit() ; Makes sure we don't skip SKI_ConfigBase's OnInit()
EndEvent

Event OnConfigInit()
    Debug.Trace("[BCD-WWW] OnConfigInit sent")
    ModName = asLocalizationTable[0].GetName()
    Debug.Trace("[BCD-WWW] OnConfigInit - Name Set")
EndEvent

Event OnConfigRegister()
    Debug.Trace("[BCD-WWW] OnConfigRegister sent")
EndEvent

Event OnPageReset(string page)
    ; We only have one page, so 😁
    Debug.Trace("[BCD-WWW] OnPageReset sent, page: " + page)
	SetCursorFillMode(LEFT_TO_RIGHT)
    AddHeaderOption(Pages[0])
    SetCursorPosition(2)
	AddSliderOptionST("Slider_SearchRadius", "$WWWSliderSearchRadiusLabel", WWW_SearchRadiusGlob[0].GetValue(), "$WWWSliderSearchRadiusUnits")
    SetCursorPosition(6)
    AddHeaderOption("$WWWHeaderSearchTypes")
    SetCursorPosition(8)
    AddToggleOptionST("Bool_ChoppingBlock", "$WWWBoolChoppingBlockLabel", (WWW_ChoppingBlock[0].GetValue() as Bool))
    AddToggleOptionST("Bool_ChoppingBlock_NPCs", "$WWWBoolChoppingBlockNPCLabel", (WWW_ChoppingBlock_NPCs[0].GetValue() as Bool))
    if allowOreVeins
        AddToggleOptionST("Bool_OreVein", "$WWWBoolOreVeinLabel", (WWW_OreVein[0].GetValue() as Bool))
        AddToggleOptionST("Bool_OreVein_NPCs", "$WWWBoolOreVeinNPCLabel", (WWW_OreVein_NPCs[0].GetValue() as Bool))
    EndIf
    AddToggleOptionST("Bool_StoneQuarry", "$WWWBoolStoneQuarryLabel", (WWW_StoneQuarry[0].GetValue() as Bool))
    AddToggleOptionST("Bool_StoneQuarry_NPCs", "$WWWBoolStoneQuarryNPCLabel", (WWW_StoneQuarry_NPCs[0].GetValue() as Bool))
    AddToggleOptionST("Bool_ClayDeposit", "$WWWBoolClayDepositLabel", (WWW_ClayDeposit[0].GetValue() as Bool))
    AddToggleOptionST("Bool_ClayDeposit_NPCs", "$WWWBoolClayDepositNPCLabel", (WWW_ClayDeposit_NPCs[0].GetValue() as Bool))
EndEvent

;/
Bool_ChoppingBlock
Bool_ChoppingBlock_NPC
Bool_OreVein
Bool_OreVein_NPC
Bool_StoneQuarry
Bool_StoneQuarry_NPC
Bool_ClayDeposit
Bool_ClayDeposit_NPC
/;

State Slider_SearchRadius

    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[3].GetName(), "%def%", WWW_SearchRadiusGlob[3].GetValueInt()))
    EndEvent

    Event OnSliderOpenST()
        Debug.Trace("[BCD-WWW] OnOptionSliderOpen sent, state: " + GetState())
        SetSliderDialogStartValue(WWW_SearchRadiusGlob[0].GetValue())
        SetSliderDialogDefaultValue(WWW_SearchRadiusGlob[3].GetValue())
        SetSliderDialogRange(WWW_SearchRadiusGlob[1].GetValue(), WWW_SearchRadiusGlob[2].GetValue())
        SetSliderDialogInterval(10)
    EndEvent

    Event OnSliderAcceptST(float afNewValue)
        Debug.Trace("[BCD-WWW] OnOptionSliderAccept sent, state: " + GetState() + ", new value: " + afNewValue)
        WWW_SearchRadiusGlob[0].SetValue(afNewValue)
        SetSliderOptionValueST(WWW_SearchRadiusGlob[0].GetValue(), "$WWWSliderSearchRadiusUnits")
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnOptionDefault sent, state: " + GetState())
        WWW_SearchRadiusGlob[0].SetValue(WWW_SearchRadiusGlob[3].GetValue())
        SetSliderOptionValueST(WWW_SearchRadiusGlob[0].GetValue())
    EndEvent
    
EndState


State Bool_ChoppingBlock
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[2].GetName(), "%def%", (WWW_ChoppingBlock[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_ChoppingBlock[0].SetValue(WWW_ChoppingBlock[3].GetValue())
        SetSliderOptionValueST(WWW_ChoppingBlock[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_ChoppingBlock[0].SetValue((!(WWW_ChoppingBlock[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_ChoppingBlock[0].GetValue() as Bool))
    endEvent
EndState


State Bool_ChoppingBlock_NPCs
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[3].GetName(), "%def%", (WWW_ChoppingBlock_NPCs[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_ChoppingBlock_NPCs[0].SetValue(WWW_ChoppingBlock_NPCs[3].GetValue())
        SetSliderOptionValueST(WWW_ChoppingBlock_NPCs[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_ChoppingBlock_NPCs[0].SetValue((!(WWW_ChoppingBlock_NPCs[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_ChoppingBlock_NPCs[0].GetValue() as Bool))
    endEvent
EndState


State Bool_OreVein
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[4].GetName(), "%def%", (WWW_OreVein[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_OreVein[0].SetValue(WWW_OreVein[3].GetValue())
        SetSliderOptionValueST(WWW_OreVein[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_OreVein[0].SetValue((!(WWW_OreVein[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_OreVein[0].GetValue() as Bool))
    endEvent
EndState


State Bool_OreVein_NPCs
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[5].GetName(), "%def%", (WWW_OreVein_NPCs[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_OreVein_NPCs[0].SetValue(WWW_OreVein_NPCs[3].GetValue())
        SetSliderOptionValueST(WWW_OreVein_NPCs[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_OreVein_NPCs[0].SetValue((!(WWW_OreVein_NPCs[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_OreVein_NPCs[0].GetValue() as Bool))
    endEvent
EndState


State Bool_StoneQuarry
    
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[6].GetName(), "%def%", (WWW_ChoppingBlock_NPCs[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_SearchRadiusGlob[0].SetValue(WWW_SearchRadiusGlob[3].GetValue())
        SetSliderOptionValueST(WWW_SearchRadiusGlob[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_ChoppingBlock_NPCs[0].SetValue((!(WWW_ChoppingBlock_NPCs[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_ChoppingBlock_NPCs[0].GetValue() as Bool))
    endEvent
EndState


State Bool_StoneQuarry_NPCs
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[7].GetName(), "%def%", (WWW_StoneQuarry_NPCs[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_StoneQuarry_NPCs[0].SetValue(WWW_StoneQuarry_NPCs[3].GetValue())
        SetSliderOptionValueST(WWW_StoneQuarry_NPCs[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_StoneQuarry_NPCs[0].SetValue((!(WWW_StoneQuarry_NPCs[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_StoneQuarry_NPCs[0].GetValue() as Bool))
    endEvent
EndState


State Bool_ClayDeposit
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[8].GetName(), "%def%", (WWW_ClayDeposit[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_ClayDeposit[0].SetValue(WWW_ClayDeposit[3].GetValue())
        SetSliderOptionValueST(WWW_ClayDeposit[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_ClayDeposit[0].SetValue((!(WWW_ClayDeposit[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_ClayDeposit[0].GetValue() as Bool))
    endEvent
EndState


State Bool_ClayDeposit_NPCs
    Event OnHighlightST()
        Debug.Trace("[BCD-WWW] OnHighlightST sent, state: " + GetState())
        SetInfoText(Replace(asLocalizationTable[9].GetName(), "%def%", (WWW_ClayDeposit_NPCs[1].GetValue() as Bool)))
    EndEvent

    Event OnDefaultST()
        Debug.Trace("[BCD-WWW] OnDefaultST sent, state: " + GetState())
        WWW_ClayDeposit_NPCs[0].SetValue(WWW_ClayDeposit_NPCs[3].GetValue())
        SetSliderOptionValueST(WWW_ClayDeposit_NPCs[0].GetValue())
    EndEvent

    Event OnSelectST()
        Debug.Trace("[BCD-WWW] OnSelectST sent, state: " + GetState())
        WWW_ClayDeposit_NPCs[0].SetValue((!(WWW_ClayDeposit_NPCs[0].GetValue() as Bool)) as Float)
        SetToggleOptionValueST((WWW_ClayDeposit_NPCs[0].GetValue() as Bool))
    endEvent
EndState


; Replaces the specified string with another string for the specified number of times
; 0 will not replace anything, and any negative number will replace all occurrences
String Function Replace(String str, String strFind, String strReplacement, Int aiMaxReplaces = -1) Global
    Int iStartPos = StringUtil.Find(str, strFind, iStartPos + iFindStrLength) 
    Int iStrLength = StringUtil.GetLength(str)
    Int iFindStrLength = StringUtil.GetLength(strFind)
    Debug.Trace("[BCD-WWW] Replace - Started replacement. Parameters:\nReplace: " + strFind + "\nReplacement: " + strReplacement + "\nMax Replacements: " + aiMaxReplaces + "\nstr: " + str)
    String strBase
    Int replacesDone = 0

    While iStartPos >= 0 && replacesDone != aiMaxReplaces
        Debug.Trace("[BCD-WWW] Replace - Replacing from position " + iStartPos)
        If iStartPos > 0
            strBase = StringUtil.Substring(str, 0, iStartPos)
        Else
            strBase = ""
        EndIf
        str = strBase + strReplacement + StringUtil.Substring(str, iStartPos + iFindStrLength, 0)
        replacesDone += 1
        Debug.Trace("[BCD-WWW] Replace - Finished replace #" + replacesDone + " at position " + iStartPos + ", product:\n" + str)
        iStartPos = StringUtil.Find(str, strFind, iStartPos + iFindStrLength)
    EndWhile
    return str
EndFunction
