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

Message Property pSortingCompleteMsg Auto
{Message to show then sorting completes}

; Sounds
Sound property QSTAstrolabeButtonPressX auto
{BUTTONS: Played when the button is pressed}
Sound property pItemsSentSound auto
{Played when items are sent to zDestination00PnumoTube}

; Steam
Message Property CLWNoSteamPower01Msg Auto
{Message shown when no steam power is present}
GlobalVariable Property CLWSQ02Machines01GLOB Auto
{Has steam-power been restored? Treated as a bool}



;/$$$$$\                                                          $$\                                   
$$  __$$\                                                         $$ |                                  
$$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$\$$$$\   $$$$$$\  $$$$$$\    $$$$$$\   $$$$$$\   $$$$$$$\ 
$$$$$$$  | \____$$\ $$  __$$\  \____$$\ $$  _$$  _$$\ $$  __$$\ \_$$  _|  $$  __$$\ $$  __$$\ $$  _____|
$$  ____/  $$$$$$$ |$$ |  \__| $$$$$$$ |$$ / $$ / $$ |$$$$$$$$ |  $$ |    $$$$$$$$ |$$ |  \__|\$$$$$$\  
$$ |      $$  __$$ |$$ |      $$  __$$ |$$ | $$ | $$ |$$   ____|  $$ |$$\ $$   ____|$$ |       \____$$\ 
$$ |      \$$$$$$$ |$$ |      \$$$$$$$ |$$ | $$ | $$ |\$$$$$$$\   \$$$$  |\$$$$$$$\ $$ |      $$$$$$$  |
\__|       \_______|\__|       \_______|\__| \__| \__| \_______|   \____/  \_______|\__|      \_______/;
 
 Bool Property aIsButton = False  Auto
 {Should button properties be used? Defaults to false}
 Bool Property aNeedsSteam = False  Auto
 {Should button properties be used? Defaults to false}
 Bool Property aRequirePlayer = true  Auto
 {Is this player-only, or can anything activate this ref?
 Defaults to true}
 
 ObjectReference Property aFormToDisable  Auto
 {Form to disable on init}

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
 Bool Property sortSoulGems = false  Auto
 {Sort for Soul Gems?}
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

 Bool Property pBlockEquipedItems = true  Auto
 {Prevent equipped items from being sorted?
 Defaults to true}
 Bool Property pBlockFavorites = true  Auto
 {Prevent favorited items from being sorted?
 Defaults to true}
 Bool Property pBlockQuestItems = true  Auto
 {Prevent quest items from being sorted?
 Defaults to true}
 
 Bool Running
 ObjectReference PlayerREF

;/$$$$$$$\                                 $$\     $$\                               
$$  _____|                                $$ |    \__|                              
$$ |      $$\   $$\ $$$$$$$\   $$$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\   $$$$$$$\ 
$$$$$\    $$ |  $$ |$$  __$$\ $$  _____|\_$$  _|  $$ |$$  __$$\ $$  __$$\ $$  _____|
$$  __|   $$ |  $$ |$$ |  $$ |$$ /        $$ |    $$ |$$ /  $$ |$$ |  $$ |\$$$$$$\  
$$ |      $$ |  $$ |$$ |  $$ |$$ |        $$ |$$\ $$ |$$ |  $$ |$$ |  $$ | \____$$\ 
$$ |      \$$$$$$  |$$ |  $$ |\$$$$$$$\   \$$$$  |$$ |\$$$$$$  |$$ |  $$ |$$$$$$$  |
\__|       \______/ \__|  \__| \_______|   \____/ \__| \______/ \__|  \__|\_______/;



 Function SortBooks(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05 = None, ObjectReference obDestination06 = None, ObjectReference obDestination07 = None, ObjectReference obDestination08 = None, ObjectReference obDestination09 = None, ObjectReference obDestination10 = None, ObjectReference obDestination11 = None, ObjectReference obDestination12 = None, ObjectReference obDestination13 = None, ObjectReference obDestination14 = None, ObjectReference obDestination15 = None, ObjectReference obDestination16 = None, ObjectReference obDestination17 = None, ObjectReference obDestination18 = None, ObjectReference obDestination19 = None, ObjectReference obDestination20 = None, ObjectReference obDestination21 = None, ObjectReference obDestination22 = None, ObjectReference obDestination23 = None, ObjectReference obDestination24 = None, ObjectReference obDestination25 = None, ObjectReference obDestination26 = None, ObjectReference obDestination27)
    int i = 0
    Int j = 0
    String ItemName
    Form CurrentBook
    String FirstChar
    String CurrentChar
    Int ItemNameLength
    Form[] BooksToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 27, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int ItemsLeft = BooksToSort.Length
    while i < itemsLeft
        Debug.Trace("while "+i+" < "+itemsLeft+" && "+BooksToSort[i]+" != None")
        Debug.Trace("Sorting book number "+(i+1)+"/"+itemsLeft)
        CurrentBook = None
        CurrentBook = BooksToSort[i]
        Debug.Trace("Current Book: "+CurrentBook)
        if obDestination26 && CurrentBook.HasKeyword(VendorItemSpellTome) || (CurrentBook as Book).GetSpell() != None ; If it has a spell or the keyword, it is almost certainly a spell tome 
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination26)
        elseif obDestination27 && CurrentBook.HasKeyword(VendorItemRecipe) ; If it has the Potion Recipe keyword, then send it to the new Potion Recipe container.
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination27)
        elseif obDestination25 && Find(CurrentBook.GetWorldModelPath(), "Note") > -1 || Find(CurrentBook.GetWorldModelPath(), "note") > -1 ; Does the book have the word "note" in its model path? If so, it's probably a note. 
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination25)
        else ; Here's where the techno-wizardry begins. Normally, I'd search for the first letter and categorize from there.
             ; However, Antistar decided he'd make my life miserable. He decided that the word "The" doesn't count. Fun.
            ItemName = None
            ItemName = CurrentBook.GetName()
            debug.trace("Name: "+ItemName)
            ItemNameLength = -1
            ItemNameLength = StringUtil.GetLength(ItemName)
            debug.trace("Name Length: "+ItemNameLength)
            j = 0 
            FirstChar = None as String
            CurrentChar = None as String
            While j < ItemNameLength && FirstChar == None as String
                CurrentChar = GetNthChar(ItemName, j)
                if isLetter(CurrentChar)
                    debug.trace("Current letter: "+CurrentChar)
                    if (CurrentChar == "T" || CurrentChar == "t") && (GetNthChar(ItemName, j+1) == "h" || GetNthChar(ItemName, j+1) == "H") && (GetNthChar(ItemName, j+2) == "e" || GetNthChar(ItemName, j+2) == "E") && (isLetter(GetNthChar(ItemName, j+3)) == False)
                        j+=2
                    else
                        FirstChar = CurrentChar
                    endif
                elseif IsDigit(CurrentChar)
                    debug.trace("Current Digit: "+CurrentChar)
                    if CurrentChar == "1"
                        FirstChar = "o"
                    elseif CurrentChar == "2"
                        FirstChar = "t"
                    elseif CurrentChar == "3"
                        FirstChar = "t"
                    elseif CurrentChar == "4"
                        FirstChar = "f"
                    elseif CurrentChar == "5"
                        FirstChar = "f"
                    elseif CurrentChar == "6"
                        FirstChar = "s"
                    elseif CurrentChar == "7"
                        FirstChar = "s"
                    elseif CurrentChar == "8"
                        FirstChar = "e"
                    elseif CurrentChar == "9"
                        FirstChar = "n"
                    elseif CurrentChar == "0"
                        FirstChar = "z"
                    endif
                endif
                j += 1
            endwhile
            if FirstChar != None as String
                debug.trace("First character: " + FirstChar)
                ; This is a BIG if statement
                if obDestination01 && FirstChar == "a" || FirstChar == "A"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination01)
                elseif obDestination02 && FirstChar == "b" || FirstChar == "B"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination02)
                elseif obDestination03 && FirstChar == "c" || FirstChar == "C"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination03)
                elseif obDestination04 && FirstChar == "d" || FirstChar == "D"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination04)
                elseif obDestination05 && FirstChar == "e" || FirstChar == "E"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination05)
                elseif obDestination06 && FirstChar == "f" || FirstChar == "F"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination06)
                elseif obDestination07 && FirstChar == "g" || FirstChar == "G"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination07)
                elseif obDestination08 && FirstChar == "h" || FirstChar == "H"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination08)
                elseif obDestination09 && FirstChar == "i" || FirstChar == "I"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination09)
                elseif obDestination10 && FirstChar == "j" || FirstChar == "J"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination10)
                elseif obDestination11 && FirstChar == "k" || FirstChar == "K"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination11)
                elseif obDestination12 && FirstChar == "l" || FirstChar == "L"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination12)
                elseif obDestination13 && FirstChar == "m" || FirstChar == "M"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination13)
                elseif obDestination14 && FirstChar == "n" || FirstChar == "N"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination14)
                elseif obDestination15 && FirstChar == "o" || FirstChar == "O"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination15)
                elseif obDestination16 && FirstChar == "p" || FirstChar == "P"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination16)
                elseif obDestination17 && FirstChar == "q" || FirstChar == "Q"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination17)
                elseif obDestination18 && FirstChar == "r" || FirstChar == "R"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination18)
                elseif obDestination19 && FirstChar == "s" || FirstChar == "S"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination19)
                elseif obDestination20 && FirstChar == "t" || FirstChar == "T"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination20)
                elseif obDestination21 && FirstChar == "u" || FirstChar == "U"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination21)
                elseif obDestination22 && FirstChar == "v" || FirstChar == "V"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination22)
                elseif obDestination23 && FirstChar == "w" || FirstChar == "W" || FirstChar == "x" || FirstChar == "X"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination23)
                elseif obDestination24 && FirstChar == "y" || FirstChar == "Y" || FirstChar == "y" || FirstChar == "Y"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination24)
                endif
            endif
        endif
        Debug.Trace("Finished with \""+CurrentBook.GetName()+"\"\n")
        i += 1
    endwhile
 endfunction ; DONE
 
 Function SortPotions(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02)
    Form[] PotionsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = PotionsToSort.Length
    int i = 0
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = PotionsToSort[i] as Potion
        if CurrentPotion.IsFood() == false
            if CurrentPotion.IsPoison() || CurrentPotion.IsHostile()
                debug.trace(CurrentPotion+" (#"+i+") is a poison")
                obSortRef.RemoveItem(CurrentPotion as Potion, 9999, true, obDestination02)
            else
                debug.trace(CurrentPotion+" (#"+i+") is not a poison")
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination01)
            endif
        else
            debug.Trace(CurrentPotion+" (#"+i+") is food", 1)
        endif
        i += 1
    endwhile
 endfunction ; DONE

 Function SortIngredients(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02)
    Form[] IngredientsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = IngredientsToSort.Length
    int i = 0
    Form CurrentIngredient
    while i < itemsLeft
        CurrentIngredient = IngredientsToSort[i]
        if obDestination02 && CurrentIngredient.HasKeyword(VendorItemFood) || ((pOverridePLFoodCheeseSeasonings && pOverridePLFoodCheeseSeasonings && pOverridePLFoodCheeseSeasonings && pOverridePLFoodCheeseSeasonings.HasForm(CurrentIngredient)))
            obSortRef.RemoveItem(CurrentIngredient, 9999, true, obDestination02)
        elseif obDestination01 && CurrentIngredient
            obSortRef.RemoveItem(CurrentIngredient, 9999, true, obDestination01)
        endif
        i += 1
    endwhile
 endfunction ; DONE

 Function SortWorkRoom(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05 = None, ObjectReference obDestination06)
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
        debug.trace(CurrentForm+" \""+CurrentFormName+"\" #"+(i+1)+"/"+itemsLeft+" has model path \""+CurrentFormModelPath+"\"\n==================== KEYWORDS ====================\n"+CurrentFormNameKeywords+"\n==================================================")
        if obDestination02 &&      ;/               Ingots               /; !(pOverrideBLIngots && !pOverrideBLIngots.HasForm(CurrentForm)) && CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter) && (Find(CurrentForm.GetWorldModelPath(), "Ingot") != -1 || Find(CurrentForm.GetWorldModelPath(), "ingot" != -1) || Find(CurrentForm.GetWorldModelPath(), "Dwarven") != -1 || Find(CurrentForm.GetWorldModelPath(), "dwarven") != -1)
            debug.Trace("Sorted as an Ingot")
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination01)
        elseif obDestination01 &&  ;/                Ores                /; !(pOverrideBLOres && !pOverrideBLOres.HasForm(CurrentForm)) && CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter) && (Find(CurrentForm.GetWorldModelPath(), "Ore") != -1 || Find(CurrentForm.GetWorldModelPath(), "ore") != -1)
            debug.Trace("Sorted as Ore")
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination02)
        elseif                     ;/          Leather &  Hides          /; CurrentForm.HasKeyword(VendorItemAnimalHide)
            if obDestination05 &&  ;/               Leather /; !(pOverrideBLWorkRoomMisc && !pOverrideBLWorkRoomMisc.HasForm(CurrentForm)) && (Find(CurrentForm.GetWorldModelPath(), "Leather") != -1 || Find(CurrentForm.GetWorldModelPath(), "leather") != -1)
                debug.Trace("Sorted as Leather")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif obDestination03 ;                 Hides 
                debug.Trace("Sorted as Hide")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination03)
            endif
        elseif obDestination04 &&  ;/                Gems                 /;!(pOverrideBLGems && !pOverrideBLGems.HasForm(CurrentForm)) && CurrentForm.HasKeyword(VendorItemGem)
            debug.Trace("Sorted as a Gem")
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination04)
        elseif obDestination05 && !(pOverrideBLWorkRoomMisc && !pOverrideBLWorkRoomMisc.HasForm(CurrentForm))
            if                     ;/              Overrides              /; (pOverridePLWorkRoomMisc && pOverridePLWorkRoomMisc.HasForm(CurrentForm))
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/               Firewood              /; CurrentForm.HasKeyword(VendorItemFireword)
                Debug.Trace("Sorted as a Misc. Item (Firewood)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/               Charcoal              /; Find(CurrentForm.GetWorldModelPath(), "Coal") != -1 || Find(CurrentForm.GetWorldModelPath(), "coal") != -1
                Debug.Trace("Sorted as a Misc. Item (Charcoal)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/         House Building Mats         /; CurrentForm.HasKeyword(BYOHHouseCraftingCategorySmithing)
                Debug.Trace("Sorted as a Misc. Item (House Building Materials)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/   Ingredients that are MiscItems?   /; CurrentForm.HasKeyword(VendorItemIngredient)
                Debug.Trace("Sorted as a Misc. Item (Ingredients)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            elseif                 ;/     Catch-All for Ores & Ingots     /;  CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter)
                Debug.Trace("Sorted as a Misc. Item (Ingredients)")
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            endif
        endif
        i += 1
    endwhile
 endfunction

 Function SortFood(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05)
   {Sorts foods in to 5 categories (accepts PassLists & BlackLists):
   Drinks
   Cheese & Seasonings
   Raw Meats
   Fruits and Vegetables
   Prepared Food}
    if obDestination02 && pOverridePLFoodMedeAndCo
        obSortRef.RemoveItem(pOverridePLFoodMedeAndCo, 999999, true, obDestination02)
    endif
    if obDestination01 && pOverridePLFoodCheeseSeasonings
        obSortRef.RemoveItem(pOverridePLFoodCheeseSeasonings, 999999, true, obDestination01)
    endif
    if obDestination03 && pOverridePLFoodFruitsNVeggies
        obSortRef.RemoveItem(pOverridePLFoodFruitsNVeggies, 999999, true, obDestination03)
    endif
    if obDestination04 && pOverridePLFoodRawMeat
        obSortRef.RemoveItem(pOverridePLFoodRawMeat, 999999, true, obDestination04)
    endif
    if obDestination05 && pOverridePLFoodMeelz
        obSortRef.RemoveItem(pOverridePLFoodMeelz, 999999, true, obDestination05)
    endif
    
    Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FoodToSort.Length
    int i = 0
    Potion CurrentPotion
    String CurrentPotionKeywords
    String potName
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
            debug.trace(CurrentPotion+" \""+potName+"\""+" #"+(i+1)+"/"+itemsLeft+" is a food with keywords:\n====================\n"+CurrentPotionKeywords+"\n====================")

            if     obDestination05 && ;/       Prepared       /; Find(CurrentPotionKeywords, "Uncooked") == -1 && !(pOverrideBLFoodMeelz && !pOverrideBLFoodMeelz.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Cooked") != -1 || Find(CurrentPotionKeywords, "Treat") != -1 || Find(CurrentPotionKeywords, "Stew") != -1 || Find(CurrentPotionKeywords, "Bread") != -1 || Find(CurrentPotionKeywords, "Pastry") != -1 || Find(CurrentPotionKeywords, "Meal") != -1)
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination05)
            
            elseif obDestination02 && ;/        Drinks        /; !(pOverrideBLFoodMedeAndCo && !pOverrideBLFoodMedeAndCo.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Drink") != -1 || Find(CurrentPotionKeywords, "Drug") || CurrentPotion.GetUseSound() == "ITMPotionUse")
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination02)
            
            elseif obDestination01 && ;/ Cheese 'n Seasonings /; !(pOverrideBLFoodCheeseSeasonings && !pOverrideBLFoodCheeseSeasonings.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Cheese") != -1 != -1 || Find(CurrentPotionKeywords, "Fat") != -1 || Find(CurrentPotionKeywords, "DryGoods") != -1 || Find(potName, "Cheese") != -1 || Find(potName, "cheese") != -1)
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination01)
            
            elseif obDestination03 && ;/  Fruits and Veggies  /; !(pOverrideBLFoodFruitsNVeggies && !pOverrideBLFoodFruitsNVeggies.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Fruit") != -1 || Find(CurrentPotionKeywords, "Vegetable") != -1)
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination03)
            
            elseif obDestination04 && ;/         Meat         /; !(pOverrideBLFoodRawMeat && !pOverrideBLFoodRawMeat.HasForm(CurrentPotion)) && (CurrentPotion.HasKeyword(VendorItemFoodRaw) || Find(CurrentPotionKeywords, "Meat") != -1)
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination04)
            
            elseif obDestination05 && ;/  Prepared Catch-All  /; Find(CurrentPotionKeywords, "Uncooked") == -1 && !(pOverrideBLFoodMeelz && !pOverrideBLFoodMeelz.HasForm(CurrentPotion))
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination05)
            endif
        endif
        i += 1
    endwhile
 endfunction ; DONE

 Function SortArmoury(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None, ObjectReference obDestination03 = None, ObjectReference obDestination04 = None, ObjectReference obDestination05 = None, ObjectReference obDestination06 = None, ObjectReference obDestination07 = None, ObjectReference obDestination08 = None, ObjectReference obDestination09 = None)
    Int itemsLeft
    int i
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
            if obDestination08 &&     ;/  Ranged  /; curWeapSkill == "Marksman"
                obSortRef.RemoveItem(WeaponsToSort[i], 9999999, true, obDestination08)
            elseif obDestination06 && ;/ 1-Handed /; curWeapSkill == "OneHanded"
                obSortRef.RemoveItem(WeaponsToSort[i], 9999999, true, obDestination06)
            elseif obDestination07 && ;/ 2-Handed /; curWeapSkill == "TwoHanded"
                obSortRef.RemoveItem(WeaponsToSort[i], 9999999, true, obDestination07)
            elseif obDestination09 && ;/  Staves  /; (curWeap.HasKeyword(WeapTypeStaff) || (curWeapSkill == "Destruction" || curWeapSkill == "Conjuration" || curWeapSkill == "Alteration" || curWeapSkill == "Illusion" || curWeapSkill == "Restoration"))
                obSortRef.RemoveItem(WeaponsToSort[i], 9999999, true, obDestination09)
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
            elseif obDestination04 && curArmor.HasKeyword(ArmorJewelry)
                obSortRef.RemoveItem(ArmorToSort[i], 9999999, true, obDestination04)
            elseif obDestination05 && curArmor.HasKeyword(ArmorClothing)
                obSortRef.RemoveItem(ArmorToSort[i], 9999999, true, obDestination05)
            endif
            i += 1
        endwhile
    endif

    if obDestination01
        Form[] ArrowsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 42, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = ArrowsToSort.Length
        i = 0
        while i < itemsLeft
            obSortRef.RemoveItem(ArrowsToSort[i], 9999999, true, obDestination01)
            i += 1
        endwhile
    endif
 endfunction ; DONE

 Function SortSoulGems(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01 = None, ObjectReference obDestination02)
    Form[] SoulGemsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 52, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    int itemsLeft = SoulGemsToSort.Length
    int i = 0
    SoulGem sGem
    ObjectReference GemRef
    bool hasSoul
    while i < itemsLeft
        sGem = SoulGemsToSort[i] as SoulGem
        Debug.trace(sGem+" has soul "+sGem.GetSoulSize()+"/"+sGem.GetGemSize())
        GemRef = self.PlaceAtMe(sGem, 1, false, true)
        hasSoul = PO3_SKSEFunctions.GetStoredSoulSize(GemRef) > 0
        debug.trace(sGem+" #"+(i+1)+"/"+itemsLeft+", has soul? "+hasSoul)
        if obDestination02 && hasSoul
            obSortRef.RemoveItem(sGem, 999999, true, obDestination02)
        elseif obDestination01 && !hasSoul
            obSortRef.RemoveItem(sGem, 999999, true, obDestination01)
        endif
        GemRef.Delete()
        i += 1
    endwhile
 endfunction

 ; Sorting functions for each room
 Function SortDestKitchen(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FoodToSort.Length
    int i = 0
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = FoodToSort[i] as Potion
        if obDestination01 && CurrentPotion.IsFood()
            obSortRef.RemoveItem(CurrentPotion, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile
 endfunction
 Function SortDestStudy(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] PotionsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = PotionsToSort.Length
    int i = 0
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = PotionsToSort[i] as Potion
        if obDestination01 && CurrentPotion.IsFood() == False
            obSortRef.RemoveItem(CurrentPotion, 9999999, true, obDestination01)
        endif
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
 endfunction
 Function SortDestArmoury(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] WeaponsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 41, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = WeaponsToSort.Length
    int i = 0
    while i < itemsLeft
        obSortRef.RemoveItem(WeaponsToSort[i], 9999999, true, obDestination01)
        i += 1
    endwhile

    Form[] ArmorToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 26, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ArmorToSort.Length
    i = 0
    Armor SortingArmour
    while i < itemsLeft
        SortingArmour = ArmorToSort[i] as Armor
        if SortingArmour.GetWeightClass() != 2 || SortingArmour.HasKeyword(ArmorClothing) || SortingArmour.HasKeyword(ArmorJewelry)
            obSortRef.RemoveItem(SortingArmour, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile

    Form[] ArrowsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 42, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ArrowsToSort.Length
    i = 0
    while i < itemsLeft
        obSortRef.RemoveItem(ArrowsToSort[i], 9999999, true, obDestination01)
        i += 1
    endwhile
 endfunction

;/$$$$$\            $$$$$$\           $$\   $$\       $$$\ $$$\   
$$  __$$\           \_$$  _|          \__|  $$ |     $$  _| \$$\  
$$ /  $$ |$$$$$$$\    $$ |  $$$$$$$\  $$\ $$$$$$\   $$  /    \$$\ 
$$ |  $$ |$$  __$$\   $$ |  $$  __$$\ $$ |\_$$  _|  $$ |      $$ |
$$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |$$ |  $$ |    $$ |      $$ |
$$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |$$ |  $$ |$$\ \$$\     $$  |
.$$$$$$  |$$ |  $$ |$$$$$$\ $$ |  $$ |$$ |  \$$$$  | \$$$\ $$$  / 
.\______/ \__|  \__|\______|\__|  \__|\__|   \____/   \___|\___/;
 
 Event OnInit()
    if SKSE.GetVersionRelease() < 0
        Debug.TraceAndBox("SKSE not tinstalled!\nSorting will not work and will spam Papyrus logs if attempted.", 2)
    endif
    if aFormToDisable
        aFormToDisable.DisableNoWait()
    endif
    PlayerREF = Game.GetPlayer()
 endevent

;/$$$$$\             $$$$$$\              $$\     $$\                        $$\                 $$$\ $$$\   
$$  __$$\           $$  __$$\             $$ |    \__|                       $$ |               $$  _| \$$\  
$$ /  $$ |$$$$$$$\  $$ /  $$ | $$$$$$$\ $$$$$$\   $$\ $$\    $$\  $$$$$$\  $$$$$$\    $$$$$$\  $$  /    \$$\ 
$$ |  $$ |$$  __$$\ $$$$$$$$ |$$  _____|\_$$  _|  $$ |\$$\  $$  | \____$$\ \_$$  _|  $$  __$$\ $$ |      $$ |
$$ |  $$ |$$ |  $$ |$$  __$$ |$$ /        $$ |    $$ | \$$\$$  /  $$$$$$$ |  $$ |    $$$$$$$$ |$$ |      $$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |        $$ |$$\ $$ |  \$$$  /  $$  __$$ |  $$ |$$\ $$   ____|\$$\     $$  |
.$$$$$$  |$$ |  $$ |$$ |  $$ |\$$$$$$$\   \$$$$  |$$ |   \$  /   \$$$$$$$ |  \$$$$  |\$$$$$$$\  \$$$\ $$$  / 
.\______/ \__|  \__|\__|  \__| \_______|   \____/ \__|    \_/     \_______|   \____/  \_______|  \___|\___/;
 Event OnActivate(ObjectReference akActionRef)    
    Debug.Trace("Started sorting using SKSE")
    if !Running && (akActionRef == PlayerREF || !aRequirePlayer)
        
        ; Prevent further processing
        Running = TRUE
        self.BlockActivation(true)

        if aIsButton ; Play animations and sounds
            QSTAstrolabeButtonPressX.Play(self)
            PlayAnimation("down")
            Utility.Wait(0.2)
            playAnimation("up")
        endif
        if aNeedsSteam && akActionRef == PlayerREF && CLWSQ02Machines01GLOB.GetValue() != 1 ; Check if a machine needs Steam and execute the prevention. Also inform the player of why nothing happens
            CLWNoSteamPower01Msg.Show()
        else ; Actually sort
            
            if SortBooks
                debug.trace("Begin sorting books")
                SortBooks(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, zDestination06, zDestination07, zDestination08, zDestination09, zDestination10, zDestination11, zDestination12, zDestination13, zDestination14, zDestination15, zDestination16, zDestination17, zDestination18, zDestination19, zDestination20, zDestination21, zDestination22, zDestination23, zDestination24, zDestination25, zDestination26, zDestination27)
                debug.trace("Finished sorting books")
            endif
            if SortPotions
                Debug.Trace("Begin sorting potions")
                SortPotions(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02)
                Debug.Trace("Finished sorting potions")
            endif
            if sortSoulGems
                Debug.Trace("Begin sorting soul gems")
                SortSoulGems(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02)
                Debug.Trace("Finished sorting soul gems")
            endif
            if sortIngredients
                SortIngredients(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02)
            endif
            if sortFood
                SortFood(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05)
            endif
            if sortWorkRoom
                SortWorkRoom(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, zDestination06)
            endif
            if sortArmoury
                SortArmoury(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, zDestination06, zDestination07, zDestination08, zDestination09)
            endif

            if zDestination00PnumoTube ; If a Pnumatic Tube is defined, send items from Destination01 to it and play the sending sound.
                zDestination01.RemoveAllItems(zDestination00PnumoTube, true, true)
                if pItemsSentSound
                    pItemsSentSound.Play(self)
                endif
            endif

            if akActionRef == PlayerREF
                if pSortingCompleteMsg
                    pSortingCompleteMsg.Show()
                else
                    Debug.Trace("No completion message is set for "+self, 1)
                endif
            endif
            
        endif

        if aIsButton ; Activate the wait delay used for buttons
            Utility.Wait(2.0)
        endif

        ; Unlock processing
        self.BlockActivation(false)
        Running = FALSE
    endif
 endevent

;/$$$$$\                        $$\               $$\                                         
$$/ __$$\                       $$ |              \__|                                        
$$ /  \__| $$$$$$\  $$$$$$$\  $$$$$$\    $$$$$$\  $$\ $$$$$$$\   $$$$$$\   $$$$$$\   $$$$$$$\ 
$$ |      $$  __$$\ $$  __$$\ \_$$  _|   \____$$\ $$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  _____|
$$ |      $$ /  $$ |$$ |  $$ |  $$ |     $$$$$$$ |$$ |$$ |  $$ |$$$$$$$$ |$$ |  \__|\$$$$$$\  
$$ |  $$\ $$ |  $$ |$$ |  $$ |  $$ |$$\ $$  __$$ |$$ |$$ |  $$ |$$   ____|$$ |       \____$$\ 
\$$$$$$/ |\$$$$$$  |$$ |  $$ |  \$$$$  |\$$$$$$$ |$$ |$$ |  $$ |\$$$$$$$\ $$ |      $$$$$$$  |
.\______/  \______/ \__|  \__|   \____/  \_______|\__|\__|  \__| \_______|\__|      \_______/;

 ; If we're being completely honest, the labels for the zDestinations are more for me than for anyone else.
 ; Seriously, how am I supposed to remember which barrel to point zDestination03 to?

 ObjectReference Property zDestination00PnumoTube  Auto
 {Will transfer items from zDestination01 to this container once sorting is complete} 
 ObjectReference Property zDestination01  Auto
 {Destination container. Will be sorted in to.
 
 Books:        A
 Armoury:      Arrows
 Work Room:    Ingots
 Food:         Cheese and Seasonings
 Potions:      Beneficial (Potions)
 Ingredients:  Normal
 Soul Gems:    Empty
 Sort by Type: Only Destination}
 ObjectReference Property zDestination02  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:       B
 Armoury:     Light Armor
 Work Room:   Ores
 Food:        Drinks
 Potions:     Harmful (Poisons)
 Ingredients: Interchangeable
 Soul Gems:   Filled}
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
 Armoury: 1-Handed}
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

;/$$$$$$\                                $$\ $$\             $$\               
|$$  __$$\                               $$ |\__|            $$ |              
|$$ |  $$ | $$$$$$\   $$$$$$$\  $$$$$$$\ $$ |$$\  $$$$$$$\ $$$$$$\    $$$$$$$\ 
|$$$$$$$  | \____$$\ $$  _____|$$  _____|$$ |$$ |$$  _____|\_$$  _|  $$  _____|
|$$  ____/  $$$$$$$ |\$$$$$$\  \$$$$$$\  $$ |$$ |\$$$$$$\    $$ |    \$$$$$$\  
|$$ |      $$  __$$ | \____$$\  \____$$\ $$ |$$ | \____$$\   $$ |$$\  \____$$\ 
|$$ |      \$$$$$$$ |$$$$$$$  |$$$$$$$  |$$ |$$ |$$$$$$$  |  \$$$$  |$$$$$$$  |
|\__|       \_______|\_______/ \_______/ \__|\__|\_______/    \____/ \_______/; 

 FormList Property pOverridePLFoodCheeseSeasonings  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLFoodRawMeat  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.} 
 FormList Property pOverridePLFoodFruitsNVeggies  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLFoodMedeAndCo  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLFoodMeelz  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLPotions  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLPoisons  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLIngredients  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLIngots  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLOres  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLGems  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLHides  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLWorkRoomMisc  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}

;/$$$$$$\  $$\                     $$\       $$\ $$\             $$\               
|$$  __$$\ $$ |                    $$ |      $$ |\__|            $$ |              
|$$ |  $$ |$$ | $$$$$$\   $$$$$$$\ $$ |  $$\ $$ |$$\  $$$$$$$\ $$$$$$\    $$$$$$$\ 
|$$$$$$$\ |$$ | \____$$\ $$  _____|$$ | $$  |$$ |$$ |$$  _____|\_$$  _|  $$  _____|
|$$  __$$\ $$ | $$$$$$$ |$$ /      $$$$$$  / $$ |$$ |\$$$$$$\    $$ |    \$$$$$$\  
|$$ |  $$ |$$ |$$  __$$ |$$ |      $$  _$$<  $$ |$$ | \____$$\   $$ |$$\  \____$$\ 
|$$$$$$$  |$$ |\$$$$$$$ |\$$$$$$$\ $$ | \$$\ $$ |$$ |$$$$$$$  |  \$$$$  |$$$$$$$  |
.\_______/ \__| \_______| \_______|\__|  \__|\__|\__|\_______/    \____/ \_______/; 

 FormList Property pOverrideBLFoodCheeseSeasonings  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLFoodRawMeat  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.} 
 FormList Property pOverrideBLFoodFruitsNVeggies  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLFoodMedeAndCo  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLFoodMeelz  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLPotions  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLPoisons  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLIngredients  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLIngots  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLOres  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLGems  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLHides  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLWorkRoomMisc  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
