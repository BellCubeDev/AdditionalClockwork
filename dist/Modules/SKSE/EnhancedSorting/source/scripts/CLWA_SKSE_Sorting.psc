Scriptname CLWA_SKSE_Sorting Extends ObjectReference
{Used to sort items from the player's inventory using special rules
Script by BellCube Dev
Feel free to modify for your own purposes}

;/ Since I work is VSCode with the Minimap on, I like to generate text art to show up on my minimap
   Also, Joel Day's Papyrus extension adds colapsing for comments, so I can, for instance, colapse the Containers section.
   https://patorjk.com/software/taag/#p=display&h=0&v=0&f=Big%20Money-nw /;

Import PO3_SKSEFunctions
Import StringUtil

; These should all be auto-fillable since I used their Editor IDs

; 12345

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
  
  kAmmo                  = 42
  kArmor                 = 26
  kArrowProjectile       = 64
  kAssociationType       = 123
  kBook (includes notes) = 27
  kConstructibleObject   = 49
  kDefaultObject         = 107
  kFlora                 = 39
  kGrenadeProjectile     = 65
  kIngredient            = 30
  kKey                   = 45
  kMisc                  = 32
  kPotion                = 46
  kProjectile            = 50
  kReference             = 61
  kScrollItem            = 23
  kSoulGem               = 52
  kWeapon                = 41
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



 Function SortBooks(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, ObjectReference obDestination02, ObjectReference obDestination03, ObjectReference obDestination04, ObjectReference obDestination05, ObjectReference obDestination06, ObjectReference obDestination07, ObjectReference obDestination08, ObjectReference obDestination09, ObjectReference obDestination10, ObjectReference obDestination11, ObjectReference obDestination12, ObjectReference obDestination13, ObjectReference obDestination14, ObjectReference obDestination15, ObjectReference obDestination16, ObjectReference obDestination17, ObjectReference obDestination18, ObjectReference obDestination19, ObjectReference obDestination20, ObjectReference obDestination21, ObjectReference obDestination22, ObjectReference obDestination23, ObjectReference obDestination24, ObjectReference obDestination25, ObjectReference obDestination26, ObjectReference obDestination27)
    int i = 0
    Int j = 0
    String ItemName
    Form CurrentBook
    String FirstChar
    String CurrentChar
    Int ItemNameLength
    Form[] BooksToSort = AddItemsOfTypeToArray(obSortRef, 27, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int ItemsLeft = BooksToSort.Length
    while i < itemsLeft
        Debug.Trace("while "+i+" < "+itemsLeft+" && "+BooksToSort[i]+" != None")
        Debug.Trace("Sorting book number "+i+"/"+itemsLeft)
        CurrentBook = None
        CurrentBook = BooksToSort[i]
        Debug.Trace("Current Book: "+CurrentBook)
        if CurrentBook.HasKeyword(VendorItemSpellTome) || (CurrentBook as Book).GetSpell() != None ; If it has a spell or the keyword, it is almost certainly a spell tome 
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination26)
        elseif CurrentBook.HasKeyword(VendorItemRecipe) ; If it has the Potion Recipe keyword, then send it to the new Potion Recipe container.
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination27)
        elseif Find(CurrentBook.GetWorldModelPath(), "Note") > -1 || Find(CurrentBook.GetWorldModelPath(), "note") > -1 ; Does the book have the word "note" in its model path? If so, it's probably a note. 
            obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination25)
        else ; Here's where the techno-wizardry begins. Normally, I'd search for the first letter and categorize from there.
             ; However, Antistar decided he'd make my life miserable. He decided that the word "The" doesn't count. Fun.
            ItemName = None
            ItemName = CurrentBook.GetName()
            ;Debug.Trace("Name: "+ItemName)
            ItemNameLength = -1
            ItemNameLength = StringUtil.GetLength(ItemName)
            ;Debug.Trace("Name Length: "+ItemNameLength)
            j = 0 
            FirstChar = None as String
            CurrentChar = None as String
            While j < ItemNameLength && FirstChar == None as String
                CurrentChar = GetNthChar(ItemName, j)
                if isLetter(CurrentChar)
                    ;Debug.Trace("Current letter: "+CurrentChar)
                    if (CurrentChar == "T" || CurrentChar == "t") && (GetNthChar(ItemName, j+1) == "h" || GetNthChar(ItemName, j+1) == "H") && (GetNthChar(ItemName, j+2) == "e" || GetNthChar(ItemName, j+2) == "E") && (isLetter(GetNthChar(ItemName, j+3)) == False)
                        j+=2
                    else
                        FirstChar = CurrentChar
                    endif
                elseif IsDigit(CurrentChar)
                    ;Debug.Trace("Current Digit: "+CurrentChar)
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
                ;Debug.Trace("First character: " + FirstChar)
                ; This is a BIG if statement
                if FirstChar == "a" || FirstChar == "A"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination01)
                elseif FirstChar == "b" || FirstChar == "B"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination02)
                elseif FirstChar == "c" || FirstChar == "C"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination03)
                elseif FirstChar == "d" || FirstChar == "D"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination04)
                elseif FirstChar == "e" || FirstChar == "E"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination05)
                elseif FirstChar == "f" || FirstChar == "F"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination06)
                elseif FirstChar == "g" || FirstChar == "G"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination07)
                elseif FirstChar == "h" || FirstChar == "H"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination08)
                elseif FirstChar == "i" || FirstChar == "I"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination09)
                elseif FirstChar == "j" || FirstChar == "J"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination10)
                elseif FirstChar == "k" || FirstChar == "K"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination11)
                elseif FirstChar == "l" || FirstChar == "L"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination12)
                elseif FirstChar == "m" || FirstChar == "M"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination13)
                elseif FirstChar == "n" || FirstChar == "N"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination14)
                elseif FirstChar == "o" || FirstChar == "O"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination15)
                elseif FirstChar == "p" || FirstChar == "P"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination16)
                elseif FirstChar == "q" || FirstChar == "Q"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination17)
                elseif FirstChar == "r" || FirstChar == "R"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination18)
                elseif FirstChar == "s" || FirstChar == "S"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination19)
                elseif FirstChar == "t" || FirstChar == "T"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination20)
                elseif FirstChar == "u" || FirstChar == "U"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination21)
                elseif FirstChar == "v" || FirstChar == "V"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination22)
                elseif FirstChar == "w" || FirstChar == "W" || FirstChar == "x" || FirstChar == "X"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination23)
                elseif FirstChar == "y" || FirstChar == "Y" || FirstChar == "y" || FirstChar == "Y"
                    obSortRef.RemoveItem(CurrentBook, 9999, true, obDestination24)
                endif
            endif
        endif
        Debug.Trace("Finished with \""+CurrentBook.GetName()+"\"\n")
        i += 1
    endwhile
 endfunction ; DONE
 
 Function SortPotions(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, ObjectReference obDestination02)
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

 Function SortIngredients(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, ObjectReference obDestination02)
    Form[] IngredientsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = IngredientsToSort.Length
    int i = 0
    Form CurrentIngredient
    while i < itemsLeft
        CurrentIngredient = IngredientsToSort[i]
        if CurrentIngredient.HasKeyword(VendorItemFood) || (pOverridePLFoodCheeseSeasonings && pOverridePLFoodCheeseSeasonings.HasForm(CurrentIngredient))
            obSortRef.RemoveItem(CurrentIngredient, 9999, true, obDestination02)
        elseif CurrentIngredient
            obSortRef.RemoveItem(CurrentIngredient, 9999, true, obDestination01)
        endif
        i += 1
    endwhile
 endfunction

 Function SortWorkRoom(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, ObjectReference obDestination02, ObjectReference obDestination03, ObjectReference obDestination04, ObjectReference obDestination05, ObjectReference obDestination06)
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
        if ;/ Ingots /; pOverridePLIngots.HasForm(CurrentForm) || (pOverrideBLIngots.HasForm(CurrentForm) == false && CurrentForm.HasKeyword(VendorItemOreIngot) && (Find(CurrentForm.GetWorldModelPath(), "Ingot") != -1 || Find(CurrentForm.GetWorldModelPath(), "ingot") != -1))
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination02)
        elseif ;/ Ores /; pOverridePLOres.HasForm(CurrentForm) || (pOverrideBLOres.HasForm(CurrentForm) == false && CurrentForm.HasKeyword(VendorItemOreIngot))
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination01)
        elseif ;/ Leather & Hides /; pOverridePLIngots.HasForm(CurrentForm) || (pOverrideBLIngots.HasForm(CurrentForm) == false && CurrentForm.HasKeyword(VendorItemAnimalHide))
            if ;/ Leather /; pOverridePLWorkRoomMisc.HasForm(CurrentForm) || (pOverrideBLWorkRoomMisc.HasForm(CurrentForm) == false && Find(CurrentForm.GetWorldModelPath(), "Leather") != -1 || Find(CurrentForm.GetWorldModelPath(), "leather") != -1)
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
            else ; Hides
                obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination03)
            endif
        elseif ;/ Gems /; CurrentForm.HasKeyword(VendorItemGem)
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination04)
        elseif ;/ Firewood /; CurrentForm.HasKeyword(VendorItemFireword)
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
        elseif ;/ Charcoal /; Find(CurrentForm.GetWorldModelPath(), "Coal") != -1 || Find(CurrentForm.GetWorldModelPath(), "coal") != -1
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
        elseif ;/ Somphting /; CurrentForm.HasKeyword(VendorItemFireword)
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
        elseif ;/ Somphting /; CurrentForm.HasKeyword(VendorItemFireword)
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
        elseif ;/ Somphting /; CurrentForm.HasKeyword(VendorItemFireword)
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
        elseif ;/ Somphting /; CurrentForm.HasKeyword(VendorItemFireword)
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination05)
        endif
        i += 1
    endwhile
 endfunction

 Function SortByKeyword(ObjectReference obSortRef, Int iFormTypeToSort, Keyword kwSortingKeyword, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, iFormTypeToSort, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FormsToSort.Length
    int i = 0
    Form CurrentForm
    while i < itemsLeft
        CurrentForm = FormsToSort[i]
        if CurrentForm.HasKeyword(kwSortingKeyword)
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination01)
        endif
        i += 1
    endwhile
 endfunction

 Function SortByModel(ObjectReference obSortRef, Int iFormTypeToSort, String strToFind, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, iFormTypeToSort, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FormsToSort.Length
    int i = 0
    Form CurrentForm
    while i < itemsLeft
        CurrentForm = FormsToSort[i]
        if Find(CurrentForm.GetWorldModelPath(), strToFind) != -1
            obSortRef.RemoveItem(CurrentForm, 9999, true, obDestination01)
        endif
        i += 1
    endwhile
 endfunction

 Function SortFood(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, ObjectReference obDestination02, ObjectReference obDestination03, ObjectReference obDestination04, ObjectReference obDestination05)
    Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FoodToSort.Length
    int i = 1
    Potion CurrentPotion
    String CurrentPotionKeywords
    while i < itemsLeft
        CurrentPotion = FoodToSort[i] as Potion
        if CurrentPotion.IsFood()
            ;/ Here, since Complete Alchemy and Cooking Overhaul is a thing, I check not only with FormLists and weird ways to find fruits (HINT: none exist),
             * but also with Keywords. See, CACO adds keywords like VendorItemDrinkAlcohol (and three others), VendorItemFruit, etc.
             * So, by adding the item's keywords into a single string, I can check it for specific occurances, and may even detect
             * foods I didn't anticipate while I'm at it! Just nobody add VendorItemNotFruit please, you can invert your bool check.
            /;
            
            CurrentPotionKeywords = CurrentPotion.GetKeywords() as String
            if     ;/ Drinks               /; pOverridePLFoodMedeAndCo.HasForm(CurrentPotion) || Find(CurrentPotionKeywords, "Drink") != -1 || CurrentPotion.GetUseSound() == "ITMPotionUse"
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination02)
            
            elseif ;/ Cheese & Seasonings  /; pOverridePLFoodCheeseSeasonings.HasForm(CurrentPotion) || Find(CurrentPotionKeywords, "Cheese") != -1 || Find(CurrentPotion.GetName(), "Cheese") != -1 || Find(CurrentPotion.GetName(), "cheese") != -1
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination01)
            
            elseif ;/ Fruits and Veggies   /; pOverridePLFoodFruitsNVeggies.HasForm(CurrentPotion) || Find(CurrentPotionKeywords, "Fruit") > -1 || Find(CurrentPotionKeywords, "Vegetable") != -1
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination03)
            
            elseif ;/ Meat                 /; CurrentPotion.HasKeyword(VendorItemFoodRaw) || pOverridePLFoodRawMeat.HasForm(CurrentPotion) != -1 
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination04)
            
            else   ;/ Everything else that's a food can go to the prepared area.
                    If it isn't prepared, someone submit a bug report and I'll mark it properly in a FormList /;
                obSortRef.RemoveItem(CurrentPotion, 9999, true, obDestination05)
            endif
        endif
    endwhile
 endfunction

 Function SortSoulGems(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01, ObjectReference obDestination02)
    Form[] SoulGemsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 52, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = SoulGemsToSort.Length
    int i = 0
    int j
    int sgemCount = 0
    ObjectReference GemRef
    while i < itemsLeft
        j = 0 
        sgemCount = obSortRef.GetItemCount(SoulGemsToSort[i])
        while j < sgemCount
            GemRef = obSortRef.DropObject(SoulGemsToSort[i], 1)
            debug.trace(GemRef+" #"+i+" w/ size "+GetStoredSoulSize(GemRef))
            if GetStoredSoulSize(GemRef) > 0
                obDestination02.AddItem(GemRef, 1)
            else
                obDestination01.AddItem(GemRef, 1)
            endif
            j += 1
        endwhile
        i += 1
    endwhile
 endfunction ; DONE

 ; Sorting functions for each room
 Function SortDestKitchen(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FoodToSort.Length
    int i = 1
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = FoodToSort[i] as Potion
        if CurrentPotion.IsFood()
            obSortRef.RemoveItem(CurrentPotion, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile
 endfunction
 Function SortDestStudy(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] PotionsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = PotionsToSort.Length
    int i = 1
    Potion CurrentPotion
    while i < itemsLeft
        CurrentPotion = PotionsToSort[i] as Potion
        if CurrentPotion.IsFood() == False
            obSortRef.RemoveItem(CurrentPotion, 9999999, true, obDestination01)
        endif
        i += 1
    endwhile
    Form[] IngredientsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = IngredientsToSort.Length
    i = 0
    Form CurrentIngredient
    while i < itemsLeft
        obSortRef.RemoveItem(IngredientsToSort[i], 9999, true, obDestination01)
        i += 1
    endwhile
 endfunction
 Function SortDestArmoury(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference obDestination01)
    Form[] WeaponsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 41, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = WeaponsToSort.Length
    int i = 1
    while i < itemsLeft
        obSortRef.RemoveItem(WeaponsToSort[i], 9999999, true, obDestination01)
        i += 1
    endwhile

    Form[] ArmorToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 26, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ArmorToSort.Length
    i = 0
    while i < itemsLeft
        obSortRef.RemoveItem(ArmorToSort[i], 9999999, true, obDestination01)
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
        Debug.TraceAndBox("SKSE not tinstalled!", 2)
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
    if Running == False && (akActionRef == PlayerREF || aRequirePlayer == false)
        
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
                ;Debug.Trace("Begin sorting books")
                SortBooks(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, zDestination01, zDestination02, zDestination03, zDestination04, zDestination05, zDestination06, zDestination07, zDestination08, zDestination09, zDestination10, zDestination11, zDestination12, zDestination13, zDestination14, zDestination15, zDestination16, zDestination17, zDestination18, zDestination19, zDestination20, zDestination21, zDestination22, zDestination23, zDestination24, zDestination25, zDestination26, zDestination27)
                ;Debug.Trace("Finished sorting books")
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
            if pFormTypeToSort
                Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(akActionRef, pFormTypeToSort, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                Int itemsLeft = FormsToSort.Length
                int i = 1
                Form SortingForm
                while i < itemsLeft
                    akActionRef.RemoveItem(FormsToSort[i], 9999, true, zDestination01)
                    i += 1
                endwhile
            endif

            if zDestination00PnumoTube ; If a Pnumatic Tube is defined, send items from Destination01 to it and play the sending sound.
                zDestination01.RemoveAllItems(zDestination00PnumoTube, true, true)
                if pItemsSentSound
                    pItemsSentSound.Play(self)
                endif
            endif

            if akActionRef == PlayerREF
                pSortingCompleteMsg.Show()
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
 Work Room:    Ingots
 Food:         Cheese and Seasonings
 Potions:      Beneficial (Potions)
 Ingredients:  Normal
 Soul Gems:    Empty
 Sort by Type: Only Destination}
 ObjectReference Property zDestination02  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:       B
 Work Room:   Ores
 Food:        Drinks
 Potions:     Harmful (Poisons)
 Ingredients: Interchangeable
 Soul Gems:   Filled}
 ObjectReference Property zDestination03  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:     C
 Food:      Fruits and Veggies
 Work Room: Hides}
 ObjectReference Property zDestination04  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:     D
 Food:      Meat
 Work Room: Gems}
 ObjectReference Property zDestination05  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books:     E
 Food:      Prepared Food/Meals
 Work Room: Assorted Prepared Materials (Misc.)}
 ObjectReference Property zDestination06  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: F}
 ObjectReference Property zDestination07  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: G}
 ObjectReference Property zDestination08  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: H}
 ObjectReference Property zDestination09  Auto
 {Destination container. May or may not be used depending on sorted form.
 
 Books: I}
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
 FormList Property pOverridePLzzz  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLzzzz  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverridePLzzzzz  Auto
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
 FormList Property pOverrideBLzzz  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLzzzz  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLzzzzz  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}

