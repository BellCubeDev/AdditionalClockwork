Scriptname CLWA_SKSE_Sorting Extends ObjectReference
{Used to sort items from the player's inventory using special rules
Script by BellCube Dev
Feel free to modify for your own purposes}

; About 580 lines of code (NOT including blank lines or comments)

;/ Since I work is VSCode with the Minimap on, I like to generate text art to show up on my minimap
   Also, Joel Day's Papyrus extension adds colapsing for comments, so I can, for instance, colapse the Containers section.
   https://patorjk.com/software/taag/#p=display&h=0&v=0&f=Big%20Money-nw /;

Import StringUtil

; These should all be auto-fillable since I used their Editor IDs

; PARAM Keywords
Keyword Property VendorItemSpellTome  Auto
{Keyword used to detect spell tomes}
Keyword Property VendorItemRecipe  Auto
{Keyword used to detect potion recipes}
Keyword Property VendorItemFoodRaw  Auto
{Keyword used to detect raw meats}
Keyword Property VendorItemFood  Auto
{Keyword used to detect ingredients that are also food}
Keyword Property VendorItemOreIngot  Auto
{Keyword used to detect ores and ingots}
Keyword Property VendorItemAnimalHide  Auto
{Keyword used to detect hides}
Keyword Property VendorItemGem  Auto
{Keyword used to detect gems}
Keyword Property VendorItemFireword  Auto
{Keyword used to detect Firewood}
Keyword Property BYOHHouseCraftingCategorySmithing  Auto
{Keyword used to detect house building items like locks, hinges, nails, and iron fittings}
Keyword Property VendorItemIngredient  Auto
{Keyword used to detect Misc Items that are also ingredients - Not present in vanilla, but present with CACO}
Keyword Property VendorItemClutter  Auto
{Keyword used as a NOT filter (lookin' at you, VendorItemOreIngot!)}
Keyword Property VendorItemAnimalPart  Auto
{Keyword used to detect animal parts}
Keyword Property WeapTypeStaff  Auto
{Keyword used to detect staves}
Keyword Property ArmorClothing  Auto
{Keyword used to detect armor that is considered clothing}
Keyword Property ArmorJewelry  Auto
{Keyword used to detect armor that is considered jewelry}
; !PARAM

; PARAM Sounds
Sound property QSTAstrolabeButtonPressX auto
{BUTTONS: Played when the button is pressed}
Sound property CLWNPCDwarvenCenturionAttackBreathOutMarker auto
{Played when sorting is complete if aPlayTransferSound = True}
FormList Property CLWAItemPotionUse  Auto
{FormList with the SoundDescriptor ITMPotionUse at the first index (i.e. Index 0)
I was genuinely stuck on this one for a while, thanks CK wiki!}
; !PARAM

; PARAM Steam
Message Property CLWNoSteamPower01Msg Auto
{Message shown when no steam power is present}
GlobalVariable Property CLWSQ02Machines01GLOB Auto
{Has steam-power been restored? Treated as a bool}
; !PARAM



;/$$$$$\                                                          $$\                                   
|$$  __$$\                                                         $$ |                                  
|$$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$\$$$$\   $$$$$$\  $$$$$$\    $$$$$$\   $$$$$$\   $$$$$$$\ 
|$$$$$$$  | \____$$\ $$  __$$\  \____$$\ $$  _$$  _$$\ $$  __$$\ \_$$  _|  $$  __$$\ $$  __$$\ $$  _____|
|$$  ____/  $$$$$$$ |$$ |  \__| $$$$$$$ |$$ / $$ / $$ |$$$$$$$$ |  $$ |    $$$$$$$$ |$$ |  \__|\$$$$$$\  
|$$ |      $$  __$$ |$$ |      $$  __$$ |$$ | $$ | $$ |$$   ____|  $$ |$$\ $$   ____|$$ |       \____$$\ 
\$$ |      \$$$$$$$ |$$ |      \$$$$$$$ |$$ | $$ | $$ |\$$$$$$$\   \$$$$  |\$$$$$$$\ $$ |      $$$$$$$  |
 \__|       \_______|\__|       \_______|\__| \__| \__| \_______|   \____/  \_______|\__|      \_______/;
; PARAM Important Parameters (a-)
 ; Bools
 Bool Property aIsButton = False  Auto
 {Should button properties be used? Defaults to false}
 Bool Property aNeedsSteam = False  Auto
 {Should we require the global to have the value of 1? Defaults to false}
 Bool Property aPlayTransferSound = False  Auto
 {Should the transfer sound be played? Defaults to false}
 Bool Property aRequirePlayer = true  Auto
 {Is this player-only, or can anything activate this ref?
 Defaults to true}

 ; Messages
 Message Property aSortingCompleteMsg Auto
 {Message to show then sorting completes}
 
 ; Refs
 ObjectReference Property aFormToDisable  Auto
 {Form to disable on init}

 ; ANCHOR What to Sort (sort-) (x-)
 Bool Property sortBooks = false  Auto
 {Sort for books?}
 Bool Property sortArmoury = false  Auto
 {Sort for the Armoury?}
 Bool Property sortPotions = false  Auto
 {Sort for Potions?}
 Bool Property sortFood = false  Auto
 {Sort for Food?}
 Bool Property sortIngredients = false  Auto
 {Sort for Potions?}
 Bool Property sortWorkRoom = false  Auto
 {Sort for the Work Room?}

 Bool Property xDestinationArmoury = false  Auto
 {Sort for the Armoury's Pnumatic Tube}
 Bool Property xDestinationWork = false  Auto
 {Sort for the Work Room's Pnumatic Tube}
 Bool Property xDestinationStudy = false  Auto
 {Sort for the Study's Pnumatic Tube}
 Bool Property xDestinationKitchen = false  Auto
 {Sort for the Kitchen's Pnumatic Tube}

 ; ANCHOR Form Type To Sort
 Int Property pFormTypeToSort  Auto
 {Form to sort. All sorted forms will end up in zDestination01
  Types:
   ANIO = 83
   ARMA = 102
   AcousticSpace = 16
   Action = 6
   Activator = 24
   ActorValueInfo = 95
   AddonNode = 94
   Ammo = 42
   Apparatus = 33
   Armor = 26
   ArrowProjectile = 64
   Art = 125
   AssociationType = 123
   BarrierProjectile = 69
   BeamProjectile = 66
   BodyPartData = 93
   Book = 27
   CameraPath = 97
   CameraShot = 96
   Cell = 60
   Character = 62
   Class = 10
   Climate = 55
   CollisionLayer = 132
   ColorForm = 133
   CombatStyle = 80
   ConeProjectile = 68
   ConstructibleObject = 49
   Container = 28
   DLVW = 117
   Debris = 88
   DefaultObject = 107
   DialogueBranch = 115
   Door = 29
   DualCastData = 129
   EffectSetting = 18
   EffectShader = 85
   Enchantment = 21
   EncounterZone = 103
   EquipSlot = 120
   Explosion = 87
   Eyes = 13
   Faction = 11
   FlameProjectile = 67
   Flora = 39
   Footstep = 110
   FootstepSet = 111
   Furniture = 40
   GMST = 3
   Global = 9
   Grass = 37
   GrenadeProjectile = 65
   Group = 2
   Hazard = 51
   HeadPart = 12
   Idle = 78
   IdleMarker = 47
   ImageSpace = 89
   ImageSpaceModifier = 90
   ImpactData = 100
   ImpactDataSet = 101
   Ingredient = 30
   Key = 45
   Keyword = 4
   Land = 72
   LandTexture = 20
   LeveledCharacter = 44
   LeveledItem = 53
   LeveledSpell = 82
   Light = 31
   LightingTemplate = 108
   List = 91
   LoadScreen = 81
   Location = 104
   LocationRef = 5
   Material = 126
   MaterialType = 99
   MenuIcon = 8
   Message = 105
   Misc = 32
   MissileProjectile = 63
   MovableStatic = 36
   MovementType = 127
   MusicTrack = 116
   MusicType = 109
   NAVI = 59
   NPC = 43
   NavMesh = 73
   None = 0
   Note = 48
   Outfit = 124
   PHZD = 70
   Package = 79
   Perk = 92
   Potion = 46
   Projectile = 50
   Quest = 77
   Race = 14
   Ragdoll = 106
   Reference = 61
   ReferenceEffect = 57
   Region = 58
   Relationship = 121
   ReverbParam = 134
   Scene = 122
   Script = 19
   ScrollItem = 23
   ShaderParticleGeometryData = 56
   Shout = 119
   Skill = 17
   SoulGem = 52
   Sound = 15
   SoundCategory = 130
   SoundDescriptor = 128
   SoundOutput = 131
   Spell = 22
   Static = 34
   StaticCollection = 35
   StoryBranchNode = 112
   StoryEventNode = 114
   StoryQuestNode = 113
   TES4 = 1
   TLOD = 74
   TOFT = 86
   TalkingActivator = 25
   TextureSet = 7
   Topic = 75
   TopicInfo = 76
   Tree = 38
   VoiceType = 98
   Water = 84
   Weapon = 41
   Weather = 54
   WordOfPower = 118
   WorldSpace = 71
 }

 ; ANCHOR Basic Sorting Parameters
 Bool Property pBlockEquipedItems = true  Auto
 {Prevent equipped items from being sorted?
 Defaults to true}
 Bool Property pBlockFavorites = true  Auto
 {Prevent favorited items from being sorted?
 Defaults to true}
 Bool Property pBlockQuestItems = true  Auto
 {Prevent quest items from being sorted?
 Defaults to true}

 ; ANCHOR Misc script-wide variables
 Bool Running
 Actor PlayerREF

; !PARAM
 ;/$$$$$$$\                                 $$\     $$\                               
|$$  _____|                                $$ |    \__|                              
|$$ |      $$\   $$\ $$$$$$$\   $$$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\   $$$$$$$\ 
|$$$$$\    $$ |  $$ |$$  __$$\ $$  _____|\_$$  _|  $$ |$$  __$$\ $$  __$$\ $$  _____|
|$$  __|   $$ |  $$ |$$ |  $$ |$$ /        $$ |    $$ |$$ /  $$ |$$ |  $$ |\$$$$$$\  
|$$ |      $$ |  $$ |$$ |  $$ |$$ |        $$ |$$\ $$ |$$ |  $$ |$$ |  $$ | \____$$\ 
\$$ |      \$$$$$$  |$$ |  $$ |\$$$$$$$\   \$$$$  |$$ |\$$$$$$  |$$ |  $$ |$$$$$$$  |
 \__|       \______/ \__|  \__| \_______|   \____/ \__| \______/ \__|  \__|\_______/;
; SECTION Sorting Fucntions
 ; FUNCTION SortByFormType
  Function SortByFormType(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, FormList flOverridePLFormType = None, FormList flOverrideBLFormType = None)
    obSortRef.RemoveItem(flOverridePLFormType, 999999, true, zDestination02) ; Remove whitelisted items and place them into Container 2

    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, pFormTypeToSort, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
    int itemsLeft = FormsToSort.Length
    int i = 0
    if flOverrideBLFormType
        Form curForm
        while i < itemsLeft
            curForm = FormsToSort[i]
            if !flOverrideBLFormType.HasForm(curForm)
                obSortRef.RemoveItem(curForm, 999999, true, zDestination01)
            endif
            i += 1
        endwhile
    else
        while i < itemsLeft
            obSortRef.RemoveItem(FormsToSort[i], 999999, true, zDestination01)
            i += 1
        endwhile
    endif
 endfunction; !FUNCTION
 
 ; SECTION Scales
  ; FUNCTION SortForBooks
   Function SortForBooks(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, Keyword kVendorItemSpellTome, Keyword kVendorItemRecipe, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05 = None, ObjectReference obDestination06 = None, ObjectReference obDestination07 = None, ObjectReference obDestination08 = None, ObjectReference obDestination09 = None, ObjectReference obDestination10 = None, ObjectReference obDestination11 = None, ObjectReference obDestination12 = None, ObjectReference obDestination13 = None, ObjectReference obDestination14 = None, ObjectReference obDestination15 = None, ObjectReference obDestination16 = None, ObjectReference obDestination17 = None, ObjectReference obDestination18 = None, ObjectReference obDestination19 = None, ObjectReference obDestination20 = None, ObjectReference obDestination21 = None, ObjectReference obDestination22 = None, ObjectReference obDestination23 = None, ObjectReference obDestination24 = None, ObjectReference obDestination25 = None, ObjectReference obDestination26 = None, ObjectReference obDestination27) Global
    {Sorts books alphabetically (merging W/X and Y/Z)
    NOT intended for languages using a non-English alphabet}
    int i = 0
    Int j
    String ItemName
    Book CurrentBook
    String FirstChar
    String CurrentChar
    Int ItemNameLength
    Form[] BooksToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 27, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int ItemsLeft = BooksToSort.Length
    while i < itemsLeft
        CurrentBook = BooksToSort[i] as Book
        Debug.Trace(CurrentBook+" #"+(i+1)+"/"+itemsLeft+"\""+CurrentBook.GetName()+"\"")
        if obDestination26 && (CurrentBook.HasKeyword(kVendorItemSpellTome) || CurrentBook.GetSpell() != None) ; If it has a spell or the keyword, it is almost certainly a spell tome 
            Debug.trace("Sorted as a Spell Tome - Spell \""+CurrentBook.GetSpell().GetName()+"\"")
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination26)
        elseif obDestination27 && CurrentBook.HasKeyword(kVendorItemRecipe) ; If it has the Potion Recipe keyword, then send it to the new Potion Recipe container.
            Debug.Trace("Sorted as a Potion Recipe")
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination27)
        elseif obDestination25 && (Find(CurrentBook.GetWorldModelPath(), "Note") > -1 || Find(CurrentBook.GetWorldModelPath(), "note") > -1) ; Does the book have the word "note" in its model path? If so, it's probably a note.
            Debug.Trace("Sorted as a Note (NOT a Potion Recipe)")
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination25)
        else ; Here's where the techno-wizardry begins. Normally, I'd search for the first letter and categorize from there.
             ; However, Antistar decided he'd make my life miserable. He decided that the word "The" doesn't count. Fun.
            ItemName = CurrentBook.GetName()
            debug.trace("Name: "+ItemName)
            ItemNameLength = -1
            ItemNameLength = StringUtil.GetLength(ItemName)
            debug.trace("Name Length: "+ItemNameLength)
            j = 0 
            FirstChar = None as String
            CurrentChar = None as String
            Int NextChar
            While j < ItemNameLength && FirstChar == None as String
                CurrentChar = GetNthChar(ItemName, j) ; Store the current character to prevent spamming the same function over and over again
                if isLetter(CurrentChar)
                    debug.trace("Current letter: "+CurrentChar)
                    if ;/ the current word is "the", skip it /; (CurrentChar == "T" || CurrentChar == "t") && (GetNthChar(ItemName, j+1) == "h" || GetNthChar(ItemName, j+1) == "H") && (GetNthChar(ItemName, j+2) == "e" || GetNthChar(ItemName, j+2) == "E") && !isLetter(GetNthChar(ItemName, j+3))
                        j+=2
                    else
                        FirstChar = CurrentChar
                    endif
                elseif IsDigit(CurrentChar)
                    debug.trace("Current Digit: "+CurrentChar)
                    if CurrentChar == "2" || CurrentChar == "3"
                        FirstChar = "T"
                    elseif CurrentChar == "1"
                        ; English is MEAN!
                        ; Checks for numbers 10-19
                        FirstChar = "O"
                        if !isDigit(GetNthChar(ItemName, j+2))
                            NextChar = GetNthChar(ItemName, j+1) as Int
                            if NextChar == 1 || NextChar == 8
                                FirstChar = "E"
                            elseif NextChar == 2 || NextChar == 0
                                FirstChar = "T"
                                ; Top 10 Reasons to Hate English
                            elseif NextChar == 4 || NextChar == 5
                                FirstChar = "F"
                            elseif NextChar == 6 || NextChar == 7
                                FirstChar = "S"
                            elseif NextChar == 9
                                FirstChar = "N"
                            endif
                        endif
                    elseif CurrentChar == "4"|| CurrentChar == "5"
                        FirstChar = "F"
                    elseif CurrentChar == "6" || CurrentChar == "7"
                        FirstChar = "S"
                    elseif CurrentChar == "8"
                        FirstChar = "E"
                    elseif CurrentChar == "9"
                        FirstChar = "N"
                    elseif CurrentChar == "0"
                        FirstChar = "Z"
                    endif

                endif
                j += 1
            endwhile
            if FirstChar != None as String
                debug.trace("First character: " + FirstChar)
                ; This is a BIG if statement
                if obDestination01 && (FirstChar == "A" || FirstChar == "a")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination01)
                elseif obDestination02 && (FirstChar == "B" || FirstChar == "b")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination02)
                elseif obDestination03 && (FirstChar == "C" || FirstChar == "c")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination03)
                elseif obDestination04 && (FirstChar == "D" || FirstChar == "d")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination04)
                elseif obDestination05 && (FirstChar == "E" || FirstChar == "e")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination05)
                elseif obDestination06 && (FirstChar == "F" || FirstChar == "f")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination06)
                elseif obDestination07 && (FirstChar == "G" || FirstChar == "g")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination07)
                elseif obDestination08 && (FirstChar == "H" || FirstChar == "h")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination08)
                elseif obDestination09 && (FirstChar == "I" || FirstChar == "i")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination09)
                elseif obDestination10 && (FirstChar == "J" || FirstChar == "j")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination10)
                elseif obDestination11 && (FirstChar == "K" || FirstChar == "k")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination11)
                elseif obDestination12 && (FirstChar == "L" || FirstChar == "l")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination12)
                elseif obDestination13 && (FirstChar == "M" || FirstChar == "m")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination13)
                elseif obDestination14 && (FirstChar == "N" || FirstChar == "n")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination14)
                elseif obDestination15 && (FirstChar == "O" || FirstChar == "o")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination15)
                elseif obDestination16 && (FirstChar == "P" || FirstChar == "p")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination16)
                elseif obDestination18 && (FirstChar == "R" || FirstChar == "r")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination18)
                elseif obDestination19 && (FirstChar == "S" || FirstChar == "s")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination19)
                elseif obDestination20 && (FirstChar == "T" || FirstChar == "t")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination20)
                elseif obDestination21 && (FirstChar == "U" || FirstChar == "u")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination21)
                elseif obDestination22 && (FirstChar == "V" || FirstChar == "v")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination22)
                elseif obDestination23 && (FirstChar == "W" || FirstChar == "w" || FirstChar == "X" || FirstChar == "x")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination23)
                elseif obDestination24 && (FirstChar == "Y" || FirstChar == "y" || FirstChar == "Y" || FirstChar == "y")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination24)
                elseif obDestination17 && (FirstChar == "Q" || FirstChar == "q")
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination17)
                endif
            endif
        endif
        Debug.Trace("Finished with \""+CurrentBook.GetName()+"\"\n")
        i += 1
    endwhile
  endfunction ; DONE !FUNCTION

  ; FUNCTION SortForPotions
   Function SortForPotions(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, FormList flCLWASortingPLStudyPotions = None, FormList flCLWASortingPLStudyPoisons = None, FormList flCLWASortingBLStudyPotions = None, FormList flCLWASortingBLStudyPoisons = None) Global
    {Sorts potions and poisons into two seperate containers}
    
    if obDestination01 && flCLWASortingPLStudyPotions
        obSortRef.RemoveItem(flCLWASortingPLStudyPotions, 999999, false, obDestination01)
    endif
    if obDestination02 && flCLWASortingPLStudyPoisons
        obSortRef.RemoveItem(flCLWASortingPLStudyPoisons, 999999, false, obDestination02)
    endif
    Form[] PotionsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = PotionsToSort.Length
    int i = 0
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = PotionsToSort[i] as Potion
        if !CurrentPotion.IsFood()
            if (CurrentPotion.IsPoison() || CurrentPotion.IsHostile()) && (!flCLWASortingBLStudyPoisons || flCLWASortingBLStudyPoisons.HasForm(CurrentPotion))
                debug.trace(CurrentPotion+" (#"+i+") is a poison")
                if obDestination02
                    obSortRef.RemoveItem(CurrentPotion as Potion, 9999, true, obDestination02)
                endif
            elseif obDestination01 && (!flCLWASortingBLStudyPotions || flCLWASortingBLStudyPotions.HasForm(CurrentPotion))
                debug.trace(CurrentPotion+" (#"+i+") is not a poison")
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination01)
            endif
        else
            debug.Trace(CurrentPotion+" (#"+i+") is food", 1)
        endif
        i += 1
    endwhile
  endfunction ; DONE !FUNCTION

  ; FUNCTION SortForWorkRoom
   Function SortForWorkRoom(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, Keyword kVendorItemOreIngot, Keyword kVendorItemClutter, Keyword kVendorItemIngredient, Keyword kVendorItemFireword, Keyword kVendorItemGem, Keyword kVendorItemAnimalHide, Keyword kBYOHHouseCraftingCategorySmithing, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05 = None, FormList flOverrideWLIngots = None, FormList flOverrideWLOres = None, FormList flOverrideWLHides = None, FormList flOverrideWLGems = None, FormList flOverrideWLWorkRoomMisc = None, FormList flOverrideBLIngots = None, FormList flOverrideBLOres = None, FormList flOverrideBLWorkRoomMisc = None, FormList flOverrideBLHides = None, FormList flOverrideBLGems = None) Global
    {Sorts various smithing materials into their appropriate containers, including a misc. container}

    obSortRef.RemoveItem(flOverrideWLIngots, 999999, True, obDestination01)
    obSortRef.RemoveItem(flOverrideWLOres, 999999, True, obDestination02)
    obSortRef.RemoveItem(flOverrideWLHides, 999999, True, obDestination03)
    obSortRef.RemoveItem(flOverrideWLGems, 999999, True, obDestination04)
    obSortRef.RemoveItem(flOverrideWLWorkRoomMisc, 999999, True, obDestination05)

    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 32, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FormsToSort.Length
    int i = 0
    Form CurrentForm
    String CurrentFormName
    String CurrentFormNameKeywords
    String CurrentFormModelPath
    while i < itemsLeft
        CurrentForm = FormsToSort[i]
        CurrentFormName = CurrentForm.GetName()
        CurrentFormNameKeywords = CurrentForm.GetKeywords()
        CurrentFormModelPath = CurrentForm.GetWorldModelPath()
        debug.trace(CurrentForm+" \""+CurrentFormName+"\" #"+(i+1)+"/"+itemsLeft+" with form type "+CurrentForm.GetType()+" has model path \""+CurrentFormModelPath+"\"\n==================== KEYWORDS ====================\n"+CurrentFormNameKeywords)
        if obDestination01 &&      ;/                Ingots               /; !(flOverrideBLIngots && !flOverrideBLIngots.HasForm(CurrentForm)) && CurrentForm.HasKeyword(kVendorItemOreIngot) && !CurrentForm.HasKeyword(kVendorItemClutter) && (Find(CurrentFormModelPath, "Ingot") != -1 || Find(CurrentFormModelPath, "ingot") != -1)
            debug.Trace("Sorted as an Ingot")
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination01)
        elseif obDestination02 &&  ;/                 Ores                /; !(flOverrideBLOres && !flOverrideBLOres.HasForm(CurrentForm)) && CurrentForm.HasKeyword(kVendorItemOreIngot) && !CurrentForm.HasKeyword(kVendorItemClutter) && (Find(CurrentFormModelPath, "Ore") != -1 || Find(CurrentFormModelPath, "ore") != -1)
            debug.Trace("Sorted as Ore")
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination02)

        elseif                     ;/           Leather & Hides           /; CurrentForm.HasKeyword(kVendorItemAnimalHide)
            if obDestination05 &&  ;/               Leather               /; !(flOverrideBLWorkRoomMisc && !flOverrideBLWorkRoomMisc.HasForm(CurrentForm)) && (Find(CurrentFormModelPath, "Leather") != -1 || Find(CurrentFormModelPath, "leather") != -1)
                debug.Trace("Sorted as Leather")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif obDestination03 ;/                Hides                /; && !(flOverrideBLHides && !flOverrideBLHides.HasForm(CurrentForm))
                debug.Trace("Sorted as Hide")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination03)
            endif
        elseif obDestination04 &&  ;/                 Gems                /;!(flOverrideBLGems && !flOverrideBLGems.HasForm(CurrentForm)) && CurrentForm.HasKeyword(kVendorItemGem)
            debug.Trace("Sorted as a Gem")
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination04)
        elseif obDestination05 && !(flOverrideBLWorkRoomMisc && !flOverrideBLWorkRoomMisc.HasForm(CurrentForm))
            if                     ;/               Firewood              /; CurrentForm.HasKeyword(kVendorItemFireword)
                Debug.Trace("Sorted as a Misc. Item (Firewood)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/               Charcoal              /; Find(CurrentFormModelPath, "Coal") != -1 || Find(CurrentFormModelPath, "coal") != -1
                Debug.Trace("Sorted as a Misc. Item (Charcoal)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/         House Building Mats         /; CurrentForm.HasKeyword(kBYOHHouseCraftingCategorySmithing)
                Debug.Trace("Sorted as a Misc. Item (House Building Materials)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/   Ingredients that are MiscItems?   /; CurrentForm.HasKeyword(kVendorItemIngredient)
                Debug.Trace("Sorted as a Misc. Item (Ingredients)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/     Catch-All for Ores & Ingots     /;  CurrentForm.HasKeyword(kVendorItemOreIngot) && !CurrentForm.HasKeyword(kVendorItemClutter)
                Debug.Trace("Sorted as a Misc. Item (Ingredients)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            endif
        endif
        debug.trace("========================")
        i += 1
    endwhile
  endfunction ; DONE !FUNCTION

  ; FUNCTION SortForFood
   Function SortForFood(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, FormList CLWAItemPotionUse, Keyword kVendorItemFoodRaw, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05 = None, ObjectReference obDestination06 = None, FormList flOverridePLFoodMedeAndCo = None, FormList flOverridePLFoodCheeseSeasonings = None, FormList flOverridePLFoodFruitsNVeggies = None, FormList flOverridePLFoodRawMeat = None, FormList flOverridePLFoodMeelz = None, FormList flOverrideBLFoodMedeAndCo = None, FormList flOverrideBLFoodMeelz = None, FormList flOverrideBLFoodCheeseSeasonings = None, FormList flOverrideBLFoodFruitsNVeggies = None, FormList flOverrideBLFoodRawMeat = None) Global
    {Sorts foods in to 5 categories (accepts PassLists & BlackLists):
    Drinks
    Cheese & Seasonings
    Raw Meats
    Fruits and Vegetables
    Prepared Food}
    Int itemsLeft
    int i = 0

    if obDestination06
        Form[] IngsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = IngsToSort.Length
        while i < itemsLeft
            obSortRef.RemoveItem(IngsToSort[i], 9999999, true, obDestination06)
            i += 1
        endwhile
    endif

    if obDestination02 && flOverridePLFoodMedeAndCo
        obSortRef.RemoveItem(flOverridePLFoodMedeAndCo, 999999, true, obDestination02)
    endif
    if obDestination01 && flOverridePLFoodCheeseSeasonings
        obSortRef.RemoveItem(flOverridePLFoodCheeseSeasonings, 999999, true, obDestination01)
    endif
    if obDestination03 && flOverridePLFoodFruitsNVeggies
        obSortRef.RemoveItem(flOverridePLFoodFruitsNVeggies, 999999, true, obDestination03)
    endif
    if obDestination04 && flOverridePLFoodRawMeat
        obSortRef.RemoveItem(flOverridePLFoodRawMeat, 999999, true, obDestination04)
    endif
    if obDestination05 && flOverridePLFoodMeelz
        obSortRef.RemoveItem(flOverridePLFoodMeelz, 999999, true, obDestination05)
    endif
    
    if obDestination01 || obDestination02 || obDestination03 || obDestination04 || obDestination05
        Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = FoodToSort.Length
        i = 0
        Potion CurrentPotion
        String CurrentPotionKeywords
        String potName
        Form ITMPotionUse = CLWAItemPotionUse.GetAt(0)
        while i < itemsLeft
            CurrentPotion = FoodToSort[i] as Potion
            if CurrentPotion.IsFood()
                ;/ Here, since Complete Alchemy and Cooking Overhaul is a thing, I check not only with FormLists and weird ways to find fruits (HINT: none exist),
                * but also with Keywords. See, CACO adds keywords like VendorItemDrinkAlcohol (and three other "VendorItemDrink" keywords), VendorItemFruit, etc.
                * So, by adding the item's keywords into a single string, I can check it for specific occurances, and may even detect
                * foods I didn't anticipate while I'm at it! Just nobody add VendorItemNotFruit please, you can invert your bool check.
                /;

                CurrentPotionKeywords = CurrentPotion.GetKeywords() as String        
                potName = CurrentPotion.GetName()
                debug.trace(CurrentPotion+" \""+potName+"\""+" #"+(i+1)+"/"+itemsLeft+" is a food with keywords:\n====================\nUse Sound: "+CurrentPotion.GetUseSound()+"\nKeywords: "+CurrentPotionKeywords+"\n====================")

                if     obDestination02 && ;/        Drinks        /; !(flOverrideBLFoodMedeAndCo && !flOverrideBLFoodMedeAndCo.HasForm(CurrentPotion)) && Find(CurrentPotionKeywords, "Stew") == -1 && (Find(CurrentPotionKeywords, "Drink") != -1 || Find(CurrentPotionKeywords, "Drug") != -1 ;/ Gotta catch dope too! /; || CurrentPotion.GetUseSound() == ITMPotionUse)
                    obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination02)
                
                elseif obDestination05 && ;/       Prepared       /; Find(CurrentPotionKeywords, "Uncooked") == -1 && !(flOverrideBLFoodMeelz && !flOverrideBLFoodMeelz.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Cooked") != -1 || Find(CurrentPotionKeywords, "Treat") != -1 || Find(CurrentPotionKeywords, "Stew") != -1 || Find(CurrentPotionKeywords, "Bread") != -1 || Find(CurrentPotionKeywords, "Pastry") != -1 || Find(CurrentPotionKeywords, "Preserved") != -1 || Find(CurrentPotionKeywords, "Meal") != -1)
                    obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination05)
                
                elseif obDestination01 && ;/ Cheese 'n Seasonings /; !(flOverrideBLFoodCheeseSeasonings && !flOverrideBLFoodCheeseSeasonings.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Cheese") != -1 || Find(CurrentPotionKeywords, "Fat") != -1 || Find(CurrentPotionKeywords, "DryGoods") != -1 || Find(potName, "Cheese") != -1 || Find(potName, "cheese") != -1)
                    obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination01)
                
                elseif obDestination03 && ;/  Fruits and Veggies  /; !(flOverrideBLFoodFruitsNVeggies && !flOverrideBLFoodFruitsNVeggies.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Fruit") != -1 || Find(CurrentPotionKeywords, "Vegetable") != -1)
                    obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination03)
                
                elseif obDestination04 && ;/         Meat         /; !(flOverrideBLFoodRawMeat && !flOverrideBLFoodRawMeat.HasForm(CurrentPotion)) && (CurrentPotion.HasKeyword(kVendorItemFoodRaw) || Find(CurrentPotionKeywords, "Meat") != -1)
                    obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination04)
                
                elseif obDestination05 && ;/  Prepared Catch-All  /; Find(CurrentPotionKeywords, "Uncooked") == -1 && !(flOverrideBLFoodMeelz && !flOverrideBLFoodMeelz.HasForm(CurrentPotion))
                    obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination05)
                endif
            endif
            i += 1
        endwhile
    endif
  endfunction ; DONE !FUNCTION

  ; FUNCTION SortForArmoury
   Function SortForArmoury(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, Keyword kArmorJewelry, Keyword kArmorClothing, Keyword kWeapTypeStaff, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05 = None, ObjectReference obDestination06 = None, ObjectReference obDestination07 = None, ObjectReference obDestination08 = None, ObjectReference obDestination09 = None, FormList flOverrideBLArmouryArmourLight = None, FormList flOverrideBLArmouryArmourHeavy = None, FormList flOverrideBLArmouryArmourClothes = None, FormList flOverrideBLArmouryArmourJewelry = None, FormList flOverrideBLArmouryWeapons1H = None, FormList flOverrideBLArmouryWeapons2H = None, FormList flOverrideBLArmouryWeapStaves = None, FormList flOverridePLArmouryArmourLight = None, FormList flOverridePLArmouryArmourHeavy = None, FormList flOverridePLArmouryArmourClothes = None, FormList flOverridePLArmouryArmourJewelry = None, FormList flOverridePLArmouryWeapons1H = None, FormList flOverridePLArmouryWeapons2H = None, FormList flOverridePLArmouryWeapStaves = None, FormList flOverridePLArmouryAmmo = None, FormList flOverridePLArmouryWeapRanged = None) Global
    {Sorts armor and weapons into specific containers}
    
    Int itemsLeft
    int i

    if obDestination01
        Form[] ArrowsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 42, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = ArrowsToSort.Length
        i = 0
        while i < itemsLeft
            obSortRef.RemoveItem(ArrowsToSort[i], 9999999, true, obDestination01)
            i += 1
        endwhile
    endif

    if obDestination06 || obDestination07 || obDestination08 || obDestination09
        Form[] WeaponsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 41, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = WeaponsToSort.Length
        i = 0
        Weapon curWeap
        String curWeapSkill
        while i < itemsLeft
            curWeap = WeaponsToSort[i] as Weapon
            curWeapSkill = curWeap.GetSkill()
            Debug.Trace(curWeap+" Skill: \""+curWeapSkill+"\"\nKeywords: "+curWeap.GetKeywords())
            if obDestination06 &&     ;/ 1-Handed /; curWeapSkill == "OneHanded"
                obSortRef.RemoveItem(curWeap, 999999, true, obDestination06)
            elseif obDestination07 && ;/ 2-Handed /; curWeapSkill == "TwoHanded"
                obSortRef.RemoveItem(curWeap, 999999, true, obDestination07)
            elseif obDestination08 && ;/  Ranged  /; curWeapSkill == "Marksman"
                obSortRef.RemoveItem(curWeap, 999999, true, obDestination08)
            elseif obDestination09 && ;/  Staves  /; (curWeap.HasKeyword(kWeapTypeStaff) || PO3_SKSEFunctions.GetEnchantmentType(curWeap.GetEnchantment()) == 12)
                obSortRef.RemoveItem(curWeap, 999999, true, obDestination09)
            endif
            i += 1
        endwhile
    endif

    if obDestination02 || obDestination03 || obDestination04 || obDestination05
        Form[] ArmorToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 26, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = ArmorToSort.Length
        i = 0
        Armor curArmor
        Int curArmorWC
        while i < itemsLeft
            curArmor = ArmorToSort[i] as Armor
            curArmorWC = curArmor.GetWeightClass()
            Debug.Trace(curArmor+" Weight Class: "+curArmorWC+"\nKeywords: "+curArmor.GetKeywords())
            if obDestination02 && curArmorWC == 0
                obSortRef.RemoveItem(ArmorToSort[i], 9999999, true, obDestination02)
            elseif obDestination03 && curArmorWC == 1
                obSortRef.RemoveItem(ArmorToSort[i], 9999999, true, obDestination03)
            elseif obDestination04 && curArmor.HasKeyword(kArmorJewelry)
                obSortRef.RemoveItem(ArmorToSort[i], 9999999, true, obDestination04)
            elseif obDestination05 && curArmor.HasKeyword(kArmorClothing)
                obSortRef.RemoveItem(ArmorToSort[i], 9999999, true, obDestination05)
            endif
            i += 1
        endwhile
    endif
  endfunction ; DONE !FUNCTION
 ; !SECTION
 ; SECTION Destinations
  ; Sorting functions for each room
  ; FUNCTION SortForDestKitchen
   Function SortForDestKitchen(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, FormList flOverridePLFoodFruitsNVeggies = None, FormList flOverridePLFoodMedeAndCo = None, FormList flOverridePLFoodRawMeat = None, FormList flOverridePLFoodMeelz = None, FormList flOverridePLFoodCheeseSeasonings = None, FormList flOverrideBLFoodFruitsNVeggies = None, FormList flOverrideBLFoodMedeAndCo = None, FormList flOverrideBLFoodRawMeat = None, FormList flOverrideBLFoodMeelz = None, FormList flOverrideBLFoodCheeseSeasonings = None) Global
    if flOverridePLFoodFruitsNVeggies
        obSortRef.RemoveItem(flOverridePLFoodFruitsNVeggies, 999999, true, obDestination01)
    endif
    if flOverridePLFoodMedeAndCo
        obSortRef.RemoveItem(flOverridePLFoodMedeAndCo, 999999, true, obDestination01)
    endif
    if flOverridePLFoodRawMeat
        obSortRef.RemoveItem(flOverridePLFoodRawMeat, 999999, true, obDestination01)
    endif
    if flOverridePLFoodMeelz
        obSortRef.RemoveItem(flOverridePLFoodMeelz, 999999, true, obDestination01)
    endif
    if flOverridePLFoodCheeseSeasonings
        obSortRef.RemoveItem(flOverridePLFoodCheeseSeasonings, 999999, true, obDestination01)
    endif
    
    Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FoodToSort.Length
    int i = 0
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = FoodToSort[i] as Potion
        if obDestination01 && CurrentPotion.IsFood() &&  !(flOverrideBLFoodRawMeat && !flOverrideBLFoodRawMeat.HasForm(CurrentPotion))
            obSortRef.RemoveItem(CurrentPotion, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile
  endfunction ; DONE !FUNCTION
  ; FUNCTION SortForDestStudy
   Function SortForDestStudy(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, FormList flCLWASortingPLStudyPotions = None, FormList flCLWASortingPLStudyPoisons = None, FormList flCLWASortingBLStudyPotions = None, FormList flCLWASortingBLStudyPoisons = None) Global
    obSortRef.RemoveItem(flCLWASortingPLStudyPotions, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLStudyPoisons, 999999, true, obDestination01)

    Form[] ScrollsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 23, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ScrollsToSort.Length
    i = 0
    while i < itemsLeft
        obSortRef.RemoveItem(ScrollsToSort[i], 9999, true, obDestination01)
        i += 1
    endwhile

    Form[] BooksToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 27, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = BooksToSort.Length
    i = 0
    while i < itemsLeft
        obSortRef.RemoveItem(BooksToSort[i], 9999, true, obDestination01)
        i += 1
    endwhile

    Form[] IngredientsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = IngredientsToSort.Length
    i = 0
    while i < itemsLeft
        obSortRef.RemoveItem(IngredientsToSort[i], 9999, true, obDestination01)
        i += 1
    endwhile 

    Form[] sGemsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 52, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = sGemsToSort.Length
    i = 0
    while i < itemsLeft
        obSortRef.RemoveItem(sGemsToSort[i], 9999, true, obDestination01)
        i += 1
    endwhile

    Form[] PotionsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = PotionsToSort.Length
    int i = 0
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = PotionsToSort[i] as Potion
        if obDestination01 && !CurrentPotion.IsFood() && ((!flCLWASortingBLStudyPotions || flCLWASortingBLStudyPotions.HasForm(CurrentPotion)) || ((CurrentPotion.IsHostile() || CurrentPotion.IsPoison()) && (!flCLWASortingBLStudyPoisons || flCLWASortingBLStudyPoisons.HasForm(CurrentPotion))))
            obSortRef.RemoveItem(CurrentPotion, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile
  endfunction ; DONE !FUNCTION
  ; FUNCTION SortForDestArmoury
   Function SortForDestArmoury(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, Keyword kArmorClothing, Keyword kArmorJewelry, Keyword kWeapTypeStaff, ObjectReference obDestination01, FormList flCLWASortingPLArmouryAmmo = None, FormList flCLWASortingPLArmouryArmourLight = None, FormList flCLWASortingPLArmouryArmourHeavy = None, FormList flCLWASortingPLArmouryArmourClothes = None, FormList flCLWASortingPLArmouryArmourJewelry = None, FormList flCLWASortingPLArmouryWeapons1H = None, FormList flCLWASortingPLArmouryWeapons2H = None, FormList flCLWASortingPLArmouryWeaponsRanged = None, FormList flCLWASortingPLArmouryWeaponsStaves = None, FormList flCLWASortingBLArmouryAmmo = None, FormList flCLWASortingBLArmouryArmourLight = None, FormList flCLWASortingBLArmouryArmourHeavy = None, FormList flCLWASortingBLArmouryArmourClothes = None, FormList flCLWASortingBLArmouryArmourJewelry = None, FormList flCLWASortingBLArmouryWeapons1H = None, FormList flCLWASortingBLArmouryWeapons2H = None, FormList flCLWASortingBLArmouryWeaponsRanged = None, FormList flCLWASortingBLArmouryWeaponsStaves = None) Global
    obSortRef.RemoveItem(flCLWASortingPLArmouryAmmo, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryArmourLight, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryArmourHeavy, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryArmourClothes, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryArmourJewelry, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryWeapons1H, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryWeapons2H, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryWeaponsRanged, 999999, true, obDestination01)
    obSortRef.RemoveItem(flCLWASortingPLArmouryWeaponsStaves, 999999, true, obDestination01)

    Form[] ArrowsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 42, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ArrowsToSort.Length
    i = 0
    Form curForm
    while i < itemsLeft
        curForm = ArrowsToSort[i]
        if !flCLWASortingBLArmouryAmmo || flCLWASortingBLArmouryAmmo.HasForm(curForm)
            obSortRef.RemoveItem(curForm, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile
    
    Form[] WeaponsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 41, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = WeaponsToSort.Length
    int i = 0
    Weapon curWeap
    String curWeapSkill
    while i < itemsLeft
        curWeap = WeaponsToSort[i] as Weapon
        curWeapSkill = curWeap.GetSkill()
        if ;/  Staves  /;((curWeap.HasKeyword(kWeapTypeStaff) || PO3_SKSEFunctions.GetEnchantmentType(curWeap.GetEnchantment()) == 12) && (!flCLWASortingBLArmouryWeaponsStaves || flCLWASortingBLArmouryWeaponsStaves.HasForm(curWeap))) ||;/
              1-Handed /; (curWeapSkill == "OneHanded" && (!flCLWASortingBLArmouryWeapons1H || flCLWASortingBLArmouryWeapons1H.HasForm(curWeap))) ||;/
              2-Handed /; (curWeapSkill == "TwoHanded" && (!flCLWASortingBLArmouryWeapons2H || flCLWASortingBLArmouryWeapons2H.HasForm(curWeap))) ||;/
               Ranged  /; (curWeapSkill == "Marksman" && (!flCLWASortingBLArmouryWeaponsRanged || flCLWASortingBLArmouryWeaponsRanged.HasForm(curWeap)))
            obSortRef.RemoveItem(curWeap, 999999, true, obDestination01)
        endif
        i += 1
    endwhile

    Form[] ArmorToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 26, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ArmorToSort.Length
    i = 0
    Armor SortingArmour
    while i < itemsLeft
        SortingArmour = ArmorToSort[i] as Armor
        if  ;/ Normal Armor /;(SortingArmour.GetWeightClass() != 2 && (!flCLWASortingBLArmouryArmourLight || flCLWASortingPLArmouryArmourLight.HasForm(SortingArmour)) && (!flCLWASortingBLArmouryArmourHeavy || flCLWASortingPLArmouryArmourHeavy.HasForm(SortingArmour))) || ;/
               Clothing     /; (SortingArmour.HasKeyword(kArmorClothing) && (!flCLWASortingBLArmouryArmourClothes || flCLWASortingBLArmouryArmourClothes.HasForm(SortingArmour))) ||;/
               Jewelry      /; (SortingArmour.HasKeyword(kArmorJewelry) && (!flCLWASortingBLArmouryArmourJewelry || flCLWASortingBLArmouryArmourClothes.HasForm(SortingArmour)))
            obSortRef.RemoveItem(SortingArmour, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile
  endfunction ; DONE !FUNCTION
  ; FUNCTION SortForDestWorkRoom
   Function SortForDestWorkRoom(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, Keyword kVendorItemAnimalHide, Keyword kVendorItemGem, Keyword kVendorItemOreIngot, Keyword kVendorItemClutter, Keyword kVendorItemFireword, Keyword kBYOHHouseCraftingCategorySmithing, Keyword kVendorItemIngredient, ObjectReference obDestination01, FormList flOverridePLGems = None , FormList flOverridePLHides = None , FormList flOverridePLIngots = None , FormList flOverridePLOres = None , FormList flOverridePLWorkRoomMisc = None , FormList flOverrideBLGems = None , FormList flOverrideBLHides = None , FormList flOverrideBLIngots = None , FormList flOverrideBLOres = None , FormList flOverrideBLWorkRoomMisc = None) Global 

    if flOverridePLGems
        obSortRef.RemoveItem(flOverridePLGems, 999999, true, obDestination01)
    endif
    if flOverridePLHides
        obSortRef.RemoveItem(flOverridePLHides, 999999, true, obDestination01)
    endif
    if flOverridePLIngots
        obSortRef.RemoveItem(flOverridePLIngots, 999999, true, obDestination01)
    endif
    if flOverridePLOres
        obSortRef.RemoveItem(flOverridePLOres, 999999, true, obDestination01)
    endif
    if flOverridePLWorkRoomMisc
        obSortRef.RemoveItem(flOverridePLWorkRoomMisc, 999999, true, obDestination01)
    endif

    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 32, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FormsToSort.Length
    int i = 0
    Form CurrentForm
    String CurrentFormName
    String CurrentFormNameKeywords
    String CurrentFormModelPath
    while i < itemsLeft
        CurrentForm = FormsToSort[i]
        CurrentFormName = CurrentForm.GetName()
        CurrentFormNameKeywords = CurrentForm.GetKeywords()
        CurrentFormModelPath = CurrentForm.GetWorldModelPath()
        if (!(flOverrideBLHides && !flOverrideBLHides.HasForm(CurrentForm)) && CurrentForm.HasKeyword(kVendorItemAnimalHide)) || (!(flOverrideBLGems && !flOverrideBLGems.HasForm(CurrentForm)) && CurrentForm.HasKeyword(kVendorItemGem)) || (!(flOverrideBLIngots && !flOverrideBLIngots.HasForm(CurrentForm)) && CurrentForm.HasKeyword(kVendorItemOreIngot) && !CurrentForm.HasKeyword(kVendorItemClutter)) || (!(flOverrideBLWorkRoomMisc && !flOverrideBLWorkRoomMisc.HasForm(CurrentForm)) && (CurrentForm.HasKeyword(kVendorItemFireword) || CurrentForm.HasKeyword(kBYOHHouseCraftingCategorySmithing) || CurrentForm.HasKeyword(kVendorItemIngredient) || (CurrentForm.HasKeyword(kVendorItemOreIngot) && !CurrentForm.HasKeyword(kVendorItemClutter)) || Find(CurrentFormModelPath, "Coal") != -1 || Find(CurrentFormModelPath, "coal") != -1))
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination01)
        endif
        i += 1
    endwhile
  endfunction ; DONE !FUNCTION
 ; !SECTION
; !SECTION
 ;/$$$$$\            $$$$$$\           $$\   $$\       $$$\ $$$\   
$$  __$$\           \_$$  _|          \__|  $$ |     $$  _| \$$\  
$$ /  $$ |$$$$$$$\    $$ |  $$$$$$$\  $$\ $$$$$$\   $$  /    \$$\ 
$$ |  $$ |$$  __$$\   $$ |  $$  __$$\ $$ |\_$$  _|  $$ |      $$ |
$$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |$$ |  $$ |    $$ |      $$ |
$$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |$$ |  $$ |$$\ \$$\     $$  |
\$$$$$$  |$$ |  $$ |$$$$$$\ $$ |  $$ |$$ |  \$$$$  | \$$$\ $$$  / 
 \______/ \__|  \__|\______|\__|  \__|\__|   \____/   \___|\___/;
; EVENT On Init

 Event OnInit()
    ; Check if SKSE is not installed
    if SKSE.GetVersionRelease() < 0
        Debug.TraceAndBox("SKSE not tinstalled!\nAdditional Clockwork's Superior Sorting will not work and will spam Papyrus logs if attempted.\n\nSorry for the message spam!\n\nWarning Sender:\n"+self, 2)
    endif

    ; Check if Papyrus Extender is installed
    if PO3_SKSEFunctions.StringToInt("128") != 128
        Debug.TraceAndBox("powerofthree's Papyrus Extender not tinstalled!\nAdditional Clockwork's Superior Sorting will not work and will spam Papyrus logs if attempted.\n\nSorry for the message spam!\n\nWarning Sender:\n"+self, 2)
    endif

    ; Optionally disable a form on startup (used to allow mid-game installs)
    if aFormToDisable
        aFormToDisable.DisableNoWait()
    endif

    ; Fill a property now to eliminate unnecessary processing
    PlayerREF = Game.GetPlayer()
 endevent
; !EVENT
;/$$$$$\             $$$$$$\              $$\     $$\                        $$\                 $$$\ $$$\   
$$  __$$\           $$  __$$\             $$ |    \__|                       $$ |               $$  _| \$$\  
$$ /  $$ |$$$$$$$\  $$ /  $$ | $$$$$$$\ $$$$$$\   $$\ $$\    $$\  $$$$$$\  $$$$$$\    $$$$$$\  $$  /    \$$\ 
$$ |  $$ |$$  __$$\ $$$$$$$$ |$$  _____|\_$$  _|  $$ |\$$\  $$  | \____$$\ \_$$  _|  $$  __$$\ $$ |      $$ |
$$ |  $$ |$$ |  $$ |$$  __$$ |$$ /        $$ |    $$ | \$$\$$  /  $$$$$$$ |  $$ |    $$$$$$$$ |$$ |      $$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |        $$ |$$\ $$ |  \$$$  /  $$  __$$ |  $$ |$$\ $$   ____|\$$\     $$  |
\$$$$$$  |$$ |  $$ |$$ |  $$ |\$$$$$$$\   \$$$$  |$$ |   \$  /   \$$$$$$$ |  \$$$$  |\$$$$$$$\  \$$$\ $$$  / 
 \______/ \__|  \__|\__|  \__| \_______|   \____/ \__|    \_/     \_______|   \____/  \_______|  \___|\___/;
; EVENT On Activate
 Event OnActivate(ObjectReference akActionRef)    
    Debug.Trace("Started sorting using SKSE")
    if !Running && (akActionRef == PlayerREF || !aRequirePlayer)

        ; Prevent further processing (likely initiated by player impatience)
        ; NOTE Block Processing
        Running = TRUE
        self.BlockActivation(true)

        ; NOTE Button Handling #1
        if aIsButton ; Push button and play sound
            QSTAstrolabeButtonPressX.Play(self)
            PlayAnimation("down")
            Utility.Wait(0.2)
        endif

        ; NOTE Steam Handling
        if aNeedsSteam && akActionRef == PlayerREF && CLWSQ02Machines01GLOB.GetValue() != 1 ; Check if a machine needs Steam and execute the prevention. Also inform the player of why nothing happens
            CLWNoSteamPower01Msg.Show()
        else ; SECTION Sort Functions

            ; Sorting for the sort buttons
            ; NOTE Destinations
             if xDestinationStudy
                 Debug.Trace("Begin sorting ingredients")
                 SortForDestStudy(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01)
                 Debug.Trace("Finished sorting ingredients")
             endif
             if xDestinationWork
                 Debug.Trace("Begin sorting smithing materials")
                 SortForDestWorkRoom(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, VendorItemAnimalHide, VendorItemGem, VendorItemOreIngot, VendorItemClutter, VendorItemFireword, BYOHHouseCraftingCategorySmithing, VendorItemIngredient, zDestination01, CLWASortingPLWorkRoomGems, CLWASortingPLWorkRoomHides, CLWASortingPLWorkRoomIngots, CLWASortingPLWorkRoomOres, CLWASortingPLWorkRoomMisc, CLWASortingBLWorkRoomGems, CLWASortingBLWorkRoomHides, CLWASortingBLWorkRoomIngots, CLWASortingBLWorkRoomOres, CLWASortingBLWorkRoomMisc)
                 Debug.Trace("Finished sorting smithing materials")
             endif
             if xDestinationKitchen
                 Debug.Trace("Begin sorting food")
                 SortForDestKitchen(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, CLWASortingPLFoodFruitsNVeggies, CLWASortingPLFoodMedeAndCo, CLWASortingPLFoodRawMeat, CLWASortingPLFoodMeelz, CLWASortingPLFoodCheeseSeasonings, CLWASortingBLFoodFruitsNVeggies, CLWASortingBLFoodMedeAndCo, CLWASortingBLFoodRawMeat, CLWASortingBLFoodMeelz, CLWASortingBLFoodCheeseSeasonings)
                 Debug.Trace("Finished sorting food")
             endif
             if xDestinationArmoury
                 Debug.Trace("Begin sorting Armoury items")
                 SortForDestArmoury(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, ArmorClothing, ArmorJewelry, WeapTypeStaff, zDestination01, CLWASortingPLArmouryAmmo, CLWASortingPLArmouryArmourLight, CLWASortingPLArmouryArmourHeavy, CLWASortingPLArmouryArmourClothes, CLWASortingPLArmouryArmourJewelry, CLWASortingPLArmouryWeapons1H, CLWASortingPLArmouryWeapons2H, CLWASortingPLArmouryWeaponsRanged, CLWASortingPLArmouryWeaponsStaves, CLWASortingBLArmouryAmmo, CLWASortingBLArmouryArmourLight, CLWASortingBLArmouryArmourHeavy, CLWASortingBLArmouryArmourClothes, CLWASortingBLArmouryArmourJewelry, CLWASortingBLArmouryWeapons1H, CLWASortingBLArmouryWeapons2H, CLWASortingBLArmouryWeaponsRanged, CLWASortingBLArmouryWeaponsStaves)
                 Debug.Trace("Finished sorting Armoury items")
             endif

            ; NOTE Scales
             if SortBooks
                debug.trace("Begin sorting books")
                SortForBooks(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, VendorItemSpellTome, VendorItemRecipe, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, zDestination06, zDestination07, zDestination08, zDestination09, zDestination10, zDestination11, zDestination12, zDestination13, zDestination14, zDestination15, zDestination16, zDestination17, zDestination18, zDestination19, zDestination20, zDestination21, zDestination22, zDestination23, zDestination24, zDestination25, zDestination26, zDestination27)
                debug.trace("Finished sorting books")
             endif
             if SortPotions
                Debug.Trace("Begin sorting potions")
                SortForPotions(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02, CLWASortingPLStudyPotions, CLWASortingPLStudyPoisons, CLWASortingBLStudyPotions, CLWASortingBLStudyPoisons)
                Debug.Trace("Finished sorting potions")
             endif
             if sortFood
                Debug.Trace("Begin sorting food")
                SortForFood(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, CLWAItemPotionUse, VendorItemFoodRaw, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, zDestination06, CLWASortingPLFoodMedeAndCo, CLWASortingPLFoodCheeseSeasonings, CLWASortingPLFoodFruitsNVeggies, CLWASortingPLFoodRawMeat, CLWASortingPLFoodMeelz, CLWASortingBLFoodMedeAndCo, CLWASortingBLFoodMeelz, CLWASortingBLFoodCheeseSeasonings, CLWASortingBLFoodFruitsNVeggies, CLWASortingBLFoodRawMeat)
                Debug.Trace("Finished sorting food")
             endif
             if sortWorkRoom
                Debug.Trace("Begin sorting smithing materials")
                SortForWorkRoom(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, VendorItemOreIngot, VendorItemClutter, VendorItemIngredient, VendorItemFireword, VendorItemGem, VendorItemAnimalHide, BYOHHouseCraftingCategorySmithing, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, CLWASortingPLWorkRoomIngots, CLWASortingPLWorkRoomOres, CLWASortingPLWorkRoomHides, CLWASortingPLWorkRoomGems, CLWASortingPLWorkRoomMisc, CLWASortingBLWorkRoomIngots, CLWASortingBLWorkRoomOres, CLWASortingBLWorkRoomMisc, CLWASortingBLWorkRoomHides, CLWASortingBLWorkRoomGems)
                Debug.Trace("Finished sorting smithing materials")
             endif
             if sortArmoury
                Debug.Trace("Begin sorting Armoury items")
                SortForArmoury(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, ArmorJewelry, ArmorClothing, WeapTypeStaff, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, zDestination06, zDestination07, zDestination08, zDestination09, CLWASortingBLArmouryArmourLight, CLWASortingBLArmouryArmourHeavy, CLWASortingBLArmouryArmourClothes, CLWASortingBLArmouryArmourJewelry, CLWASortingBLArmouryWeapons1H, CLWASortingBLArmouryWeapons2H, CLWASortingBLArmouryWeaponsStaves, CLWASortingPLArmouryArmourLight, CLWASortingPLArmouryArmourHeavy, CLWASortingPLArmouryArmourClothes, CLWASortingPLArmouryArmourJewelry, CLWASortingPLArmouryWeapons1H, CLWASortingPLArmouryWeapons2H, CLWASortingPLArmouryWeaponsStaves, CLWASortingPLArmouryAmmo, CLWASortingPLArmouryWeaponsRanged)
                Debug.Trace("Finished sorting Armoury items")
             endif

            if pFormTypeToSort ; NOTE Form Type
                SortByFormType(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02, pOverridePLFormType, pOverrideBLFormType)
            endif
            ; !SECTION

            if aPlayTransferSound ; NOTE Sound
                CLWNPCDwarvenCenturionAttackBreathOutMarker.Play(self)
            endif

            if akActionRef == PlayerREF ; NOTE Message
                if aSortingCompleteMsg
                    aSortingCompleteMsg.Show()
                else
                    Debug.Trace("No completion message is set for "+self, 1)
                endif
            endif
            
        endif

        ; NOTE Button Handling #2
        if aIsButton ; Release the button to let the player know it can be activated again
            playAnimation("up")
            Utility.Wait(2.0)
        endif

        ; NOTE Unlock Processing
        self.BlockActivation(false)
        Running = FALSE
    endif
 endevent
; !EVENT
;/$$$$$\                        $$\               $$\                                         
$$/ __$$\                       $$ |              \__|                                        
$$ /  \__| $$$$$$\  $$$$$$$\  $$$$$$\    $$$$$$\  $$\ $$$$$$$\   $$$$$$\   $$$$$$\   $$$$$$$\ 
$$ |      $$  __$$\ $$  __$$\ \_$$  _|   \____$$\ $$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  _____|
$$ |      $$ /  $$ |$$ |  $$ |  $$ |     $$$$$$$ |$$ |$$ |  $$ |$$$$$$$$ |$$ |  \__|\$$$$$$\  
$$ |  $$\ $$ |  $$ |$$ |  $$ |  $$ |$$\ $$  __$$ |$$ |$$ |  $$ |$$   ____|$$ |       \____$$\ 
\$$$$$$/ |\$$$$$$  |$$ |  $$ |  \$$$$  |\$$$$$$$ |$$ |$$ |  $$ |\$$$$$$$\ $$ |      $$$$$$$  |
 \______/  \______/ \__|  \__|   \____/  \_______|\__|\__|  \__| \_______|\__|      \_______/;
; PARAM Containers

 ; If we're being completely honest, the labels for the zDestinations are more for me than for anyone else.
 ; Seriously, how am I supposed to remember which barrel to point zDestination03 to?

 ObjectReference Property zDestination01  Auto
 {Destination container. Will be sorted in to.
 
 Books:        A
 Armoury:      Arrows
 Work Room:    Ingots
 Food:         Cheese and Seasonings
 Potions:      Beneficial (Potions)
 Sort by Type: Primary}
 ObjectReference Property zDestination02  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:       B
 Armoury:     Light Armor
 Work Room:   Ores
 Food:        Drinks
 Potions:     Harmful (Poisons)
 Sort by Type: Passlist}
 ObjectReference Property zDestination03  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:     C
 Armoury:   Heavy Armor
 Food:      Fruits and Veggies
 Work Room: Hides}
 ObjectReference Property zDestination04  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:     D
 Armoury:   Jewellery
 Food:      Meat
 Work Room: Gems}
 ObjectReference Property zDestination05  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:     E
 Armoury:   Clothing
 Food:      Prepared Food/Meals
 Work Room: Assorted Prepared Materials (Misc.)}
 ObjectReference Property zDestination06  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:   F
 Armoury: 1-Handed
 Food: Ingredients}
 ObjectReference Property zDestination07  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:   G
 Armoury: 2-Handed}
 ObjectReference Property zDestination08  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:   H
 Armoury: Ranged}
 ObjectReference Property zDestination09  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:   I
 Armoury: Staves}
 ObjectReference Property zDestination10  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: J}
 ObjectReference Property zDestination11  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: K}
 ObjectReference Property zDestination12  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: L}
 ObjectReference Property zDestination13  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: M}
 ObjectReference Property zDestination14  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: N}
 ObjectReference Property zDestination15  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: O}
 ObjectReference Property zDestination16  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: P}
 ObjectReference Property zDestination17  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: Q}
 ObjectReference Property zDestination18  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: R}
 ObjectReference Property zDestination19  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: S}
 ObjectReference Property zDestination20  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: T}
 ObjectReference Property zDestination21  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: U}
 ObjectReference Property zDestination22  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: V}
 ObjectReference Property zDestination23  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: W, X}
 ObjectReference Property zDestination24  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: Y, Z}
 ObjectReference Property zDestination25  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: Notes and Letters}
 ObjectReference Property zDestination26  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: Spell Tomes}
 ObjectReference Property zDestination27  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: Potion Recipes}

; !PARAM
;/$$$$$$\                                $$\ $$\             $$\               
|$$  __$$\                               $$ |\__|            $$ |              
|$$ |  $$ | $$$$$$\   $$$$$$$\  $$$$$$$\ $$ |$$\  $$$$$$$\ $$$$$$\    $$$$$$$\ 
|$$$$$$$  | \____$$\ $$  _____|$$  _____|$$ |$$ |$$  _____|\_$$  _|  $$  _____|
|$$  ____/  $$$$$$$ |\$$$$$$\  \$$$$$$\  $$ |$$ |\$$$$$$\    $$ |    \$$$$$$\  
|$$ |      $$  __$$ | \____$$\  \____$$\ $$ |$$ | \____$$\   $$ |$$\  \____$$\ 
\$$ |      \$$$$$$$ |$$$$$$$  |$$$$$$$  |$$ |$$ |$$$$$$$  |  \$$$$  |$$$$$$$  |
 \__|       \_______|\_______/ \_______/ \__|\__|\_______/    \____/ \_______/; 
; PARAM Passlists

 FormList Property CLWASortingPLFoodCheeseSeasonings  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLFoodRawMeat  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.} 
 FormList Property CLWASortingPLFoodFruitsNVeggies  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLFoodMedeAndCo  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLFoodMeelz  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyPotions  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyPoisons  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLWorkRoomIngots  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLWorkRoomOres  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLWorkRoomGems  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLWorkRoomHides  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLWorkRoomMisc  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryAmmo  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryArmourLight  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryArmourHeavy  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryArmourClothes  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryArmourJewelry  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryWeapons1H  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryWeapons2H  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryWeaponsRanged  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLArmouryWeaponsStaves  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLFormType  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.
 This particular one can be used for situations like the soul gem, which only sorts a few base forms.}

; !PARAM
;/$$$$$$\  $$\                     $$\       $$\ $$\             $$\               
|$$  __$$\ $$ |                    $$ |      $$ |\__|            $$ |              
|$$ |  $$ |$$ | $$$$$$\   $$$$$$$\ $$ |  $$\ $$ |$$\  $$$$$$$\ $$$$$$\    $$$$$$$\ 
|$$$$$$$\ |$$ | \____$$\ $$  _____|$$ | $$  |$$ |$$ |$$  _____|\_$$  _|  $$  _____|
|$$  __$$\ $$ | $$$$$$$ |$$ /      $$$$$$  / $$ |$$ |\$$$$$$\    $$ |    \$$$$$$\  
|$$ |  $$ |$$ |$$  __$$ |$$ |      $$  _$$<  $$ |$$ | \____$$\   $$ |$$\  \____$$\ 
\$$$$$$$  |$$ |\$$$$$$$ |\$$$$$$$\ $$ | \$$\ $$ |$$ |$$$$$$$  |  \$$$$  |$$$$$$$  |
 \_______/ \__| \_______| \_______|\__|  \__|\__|\__|\_______/    \____/ \_______/; 
; PARAM Blacklists
 FormList Property CLWASortingBLFoodCheeseSeasonings  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLFoodRawMeat  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.} 
 FormList Property CLWASortingBLFoodFruitsNVeggies  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLFoodMedeAndCo  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLFoodMeelz  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyPotions  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyPoisons  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomIngots  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomOres  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomGems  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomHides  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomMisc  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryAmmo  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourLight  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourHeavy  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourClothes  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourJewelry  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeapons1H  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeapons2H  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeaponsRanged  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeaponsStaves  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLFormType  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.
 This particular one can be used for situations like the soul gem, which only sorts a few base forms.}
; !PARAM


