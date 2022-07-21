Scriptname CLWA_SKSE_Sorting Extends ObjectReference
{Used to sort items from the player's inventory using special rules
Script by BellCube Dev
Feel free to modify for your own purposes}

; About 580 lines of code (NOT including blank lines or comments)

;/ Since I work in VSCode with the Minimap on, I like to generate text art to show up on my minimap
   Also, Joel Day's Papyrus extension adds collapsing for comments, so I can, for instance, collapse the Containers section.
   https://patorjk.com/software/taag/#p=display&h=0&v=0&f=Big%20Money-nw
/;

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
Keyword Property VendorItemFireword  Auto ; Really, Bethesda? You guys let that ship? I guess I shouldn't be talkin'...
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

Sound property QSTAstrolabeButtonPressX auto
{BUTTONS: Played when the button is pressed}
Sound property CLWNPCDwarvenCenturionAttackBreathOutMarker auto
{Played when sorting is complete If aPlayTransferSound = True}
FormList Property CLWAItemPotionUse  Auto
{FormList with the SoundDescriptor ITMPotionUse at the first index (i.e. Index 0)
I was genuinely stuck on this one for a While, thanks CK wiki!}

Message Property CLWNoSteamPower01Msg Auto
{Message shown when no steam power is present}
GlobalVariable Property CLWSQ02Machines01GLOB Auto
{Has steam-power been restored? Treated as a bool}






;/$$$$$$\                                $$\ $$\             $$\
|$$  __$$\                               $$ |\__|            $$ |
|$$ |  $$ | $$$$$$\   $$$$$$$\  $$$$$$$\ $$ |$$\  $$$$$$$\ $$$$$$\    $$$$$$$\
|$$$$$$$  | \____$$\ $$  _____|$$  _____|$$ |$$ |$$  _____|\_$$  _|  $$  _____|
|$$  ____/  $$$$$$$ |\$$$$$$\  \$$$$$$\  $$ |$$ |\$$$$$$\    $$ |    \$$$$$$\
|$$ |      $$  __$$ | \____$$\  \____$$\ $$ |$$ | \____$$\   $$ |$$\  \____$$\
\$$ |      \$$$$$$$ |$$$$$$$  |$$$$$$$  |$$ |$$ |$$$$$$$  |  \$$$$  |$$$$$$$  |
 \__|       \_______|\_______/ \_______/ \__|\__|\_______/    \____/ \_______/;

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
 FormList Property CLWASortingPLStudyBooks_A  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_B  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_C  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_D  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_E  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_F  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_G  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_H  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_I  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_J  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_K  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_L  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_M  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_N  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_O  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_P  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_Q  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_R  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_S  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_T  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_U  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_V  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_WX  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_YZ  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_Notes  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_PotionRecipes  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingPLStudyBooks_SpellTomes  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}

 FormList Property pOverridePLFormType01  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.
 This particular one can be used for situations like the soul gem, which only sorts a few base forms.}
 FormList Property pOverridePLFormType02  Auto
 {Override Passlists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.
 This particular one can be used for situations like the soul gem, which only sorts a few base forms.}



;/$$$$$$\  $$\                     $$\       $$\ $$\             $$\
|$$  __$$\ $$ |                    $$ |      $$ |\__|            $$ |
|$$ |  $$ |$$ | $$$$$$\   $$$$$$$\ $$ |  $$\ $$ |$$\  $$$$$$$\ $$$$$$\    $$$$$$$\
|$$$$$$$\ |$$ | \____$$\ $$  _____|$$ | $$  |$$ |$$ |$$  _____|\_$$  _|  $$  _____|
|$$  __$$\ $$ | $$$$$$$ |$$ /      $$$$$$  / $$ |$$ |\$$$$$$\    $$ |    \$$$$$$\
|$$ |  $$ |$$ |$$  __$$ |$$ |      $$  _$$<  $$ |$$ | \____$$\   $$ |$$\  \____$$\
\$$$$$$$  |$$ |\$$$$$$$ |\$$$$$$$\ $$ | \$$\ $$ |$$ |$$$$$$$  |  \$$$$  |$$$$$$$  |
 \_______/ \__| \_______| \_______|\__|  \__|\__|\__|\_______/    \____/ \_______/;
 FormList Property CLWASortingBLFoodCheeseSeasonings  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLFoodRawMeat  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLFoodFruitsNVeggies  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLFoodMedeAndCo  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLFoodMeelz  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyPotions  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyPoisons  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomIngots  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomOres  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomGems  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomHides  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLWorkRoomMisc  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryAmmo  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourLight  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourHeavy  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourClothes  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryArmourJewelry  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeapons1H  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeapons2H  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeaponsRanged  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLArmouryWeaponsStaves  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_A  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_B  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_C  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_D  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_E  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_F  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_G  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_H  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_I  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_J  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_K  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_L  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_M  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_N  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_O  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_P  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_Q  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_R  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_S  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_T  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_U  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_V  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_WX  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_YZ  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_Notes  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_PotionRecipes  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property CLWASortingBLStudyBooks_SpellTomes  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.}
 FormList Property pOverrideBLFormType01  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.
 This particular one can be used for situations like the soul gem, which only sorts a few base forms.

 Items that are in this Blacklist will (if applicable) go on to the second filter, where they may or may not pass}
 FormList Property pOverrideBLFormType02  Auto
 {Override Blacklists are FormLists used to correct the sorting process for improperly or unexpectedly designed forms.
 This particular one can be used for situations like the soul gem, which only sorts a few base forms.}



;/$$$$$$\                        $$\                     $$\       $$\       $$\             $$\
 $$  __$$\                       $$ |                    $$ |      $$ |      \__|            $$ |
 $$ /  \__| $$$$$$\   $$$$$$\  $$$$$$\    $$$$$$\   $$$$$$$ |      $$ |      $$\  $$$$$$$\ $$$$$$\    $$$$$$$\
 \$$$$$$\  $$  __$$\ $$  __$$\ \_$$  _|  $$  __$$\ $$  __$$ |      $$ |      $$ |$$  _____|\_$$  _|  $$  _____|
  \____$$\ $$ /  $$ |$$ |  \__|  $$ |    $$$$$$$$ |$$ /  $$ |      $$ |      $$ |\$$$$$$\    $$ |    \$$$$$$\
 $$\   $$ |$$ |  $$ |$$ |        $$ |$$\ $$   ____|$$ |  $$ |      $$ |      $$ | \____$$\   $$ |$$\  \____$$\
 \$$$$$$  |\$$$$$$  |$$ |        \$$$$  |\$$$$$$$\ \$$$$$$$ |      $$$$$$$$\ $$ |$$$$$$$  |  \$$$$  |$$$$$$$  |
  \______/  \______/ \__|         \____/  \_______| \_______|      \________|\__|\_______/    \____/ \_______/;

 FormList Property CLWASortedList_FoodCheeseSeasonings  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_FoodRawMeat  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_FoodFruitsNVeggies  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_FoodMedeAndCo  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_FoodMeelz  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyPotions  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyPoisons  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_WorkRoomIngots  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_WorkRoomOres  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_WorkRoomGems  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_WorkRoomHides  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_WorkRoomMisc  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryAmmo  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryArmourLight  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryArmourHeavy  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryArmourClothes  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryArmourJewelry  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryWeapons1H  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryWeapons2H  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryWeaponsRanged  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_ArmouryWeaponsStaves  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_A  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_B  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_C  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_D  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_E  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_F  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_G  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_H  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_I  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_J  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_K  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_L  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_M  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_N  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_O  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_P  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_Q  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_R  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_S  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_T  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_U  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_V  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_WX  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_YZ  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_Notes  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_PotionRecipes  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property CLWASortedList_StudyBooks_SpellTomes  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property pSortedList_FormType01  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}
 FormList Property pSortedList_FormType02  Auto
 {SortedLists are FormLists used to automatically filter out already-sorted items}



; TODO: Implement the above Sorted Lists!
; TODO: Move the above parameters back to the bottom of the script once Copilot is done with them



;/$$$$$\                                                          $$\
|$$  __$$\                                                         $$ |
|$$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$\$$$$\   $$$$$$\  $$$$$$\    $$$$$$\   $$$$$$\   $$$$$$$\
|$$$$$$$  | \____$$\ $$  __$$\  \____$$\ $$  _$$  _$$\ $$  __$$\ \_$$  _|  $$  __$$\ $$  __$$\ $$  _____|
|$$  ____/  $$$$$$$ |$$ |  \__| $$$$$$$ |$$ / $$ / $$ |$$$$$$$$ |  $$ |    $$$$$$$$ |$$ |  \__|\$$$$$$\
|$$ |      $$  __$$ |$$ |      $$  __$$ |$$ | $$ | $$ |$$   ____|  $$ |$$\ $$   ____|$$ |       \____$$\
\$$ |      \$$$$$$$ |$$ |      \$$$$$$$ |$$ | $$ | $$ |\$$$$$$$\   \$$$$  |\$$$$$$$\ $$ |      $$$$$$$  |
 \__|       \_______|\__|       \_______|\__| \__| \__| \_______|   \____/  \_______|\__|      \_______/;

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


 ;/$$$$$$$\                                 $$\     $$\
|$$  _____|                                $$ |    \__|
|$$ |      $$\   $$\ $$$$$$$\   $$$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\   $$$$$$$\
|$$$$$\    $$ |  $$ |$$  __$$\ $$  _____|\_$$  _|  $$ |$$  __$$\ $$  __$$\ $$  _____|
|$$  __|   $$ |  $$ |$$ |  $$ |$$ /        $$ |    $$ |$$ /  $$ |$$ |  $$ |\$$$$$$\
|$$ |      $$ |  $$ |$$ |  $$ |$$ |        $$ |$$\ $$ |$$ |  $$ |$$ |  $$ | \____$$\
\$$ |      \$$$$$$  |$$ |  $$ |\$$$$$$$\   \$$$$  |$$ |\$$$$$$  |$$ |  $$ |$$$$$$$  |
.\__|       \______/ \__|  \__| \_______|   \____/ \__| \______/ \__|  \__|\_______/;


Function RemoveAllAndAddToList(ObjectReference akRemoveRef, Form akItemToRemove, FormList akListToAddTo, ObjectReference akDestinationContainer = none, Int aiCount = 999999, Bool abSilent = true) Global
    ;Debug.Trace("[BCD-CLWA_SS] "+"RemoveAllAndAddToList - Removing all...")
    removeAll(akRemoveRef, akItemToRemove, akDestinationContainer, aiCount, abSilent)

    Form akBaseItem = akItemToRemove
    ObjectReference itemAsRef = akItemToRemove as ObjectReference
    If itemAsRef
        akBaseItem = itemAsRef.GetBaseObject()
    EndIf

    ;Debug.Trace("[BCD-CLWA_SS] "+"RemoveAllAndAddToList - Adding to list...")
    akListToAddTo.AddForm(akItemToRemove)
    ;Debug.Trace("[BCD-CLWA_SS] "+"RemoveAllAndAddToList - Done!")
EndFunction

Function removeAll(ObjectReference akRemoveRef, Form akItemToRemove, ObjectReference akDestinationContainer = none, Int aiCount = 999999, Bool abSilent = true) Global
    ;Debug.Trace("[BCD-CLWA_SS] "+"removeAll - Checking for list...")

    FormList itemAsList = akItemToRemove as FormList
    If itemAsList && itemAsList.GetSize() == 0
        ;Debug.Trace("[BCD-CLWA_SS] "+"removeAll - List was empty. Aborting to prevent log spam.")
        return
    EndIf

    ;Debug.Trace("[BCD-CLWA_SS] "+"RemoveAllAndAddToList - Removing items...")
    akRemoveRef.RemoveItem(akItemToRemove, aiCount, abSilent, akDestinationContainer)

    ;Debug.Trace("[BCD-CLWA_SS] "+"removeAll - Done!")
EndFunction

Bool Function notInListOrNoList(FormList akList, Form akItem) Global
    return !akList || !akList.HasForm(akItem)
EndFunction



Function SortByFormType(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems;/
  /;, Int iFormTypeToSort;/
  /;, ObjectReference obDestination01 = None, ObjectReference obDestination02 = None;/
  /;, FormList flOverridePLFormType01 = None, FormList flOverrideBLFormType01 = None;/
  /;, FormList flOverridePLFormType02 = None, FormList flOverrideBLFormType02 = None) Global
    removeAll(obSortRef, flOverridePLFormType01, obDestination01)
    removeAll(obSortRef, flOverridePLFormType02, obDestination02)

    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, iFormTypeToSort, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    int itemsLeft = FormsToSort.Length
    int i = 0
    If flOverrideBLFormType01
        Form curForm
        While i < itemsLeft
            curForm = FormsToSort[i]
            If flOverrideBLFormType01.HasForm(curForm)
                If !flOverrideBLFormType02 || !flOverrideBLFormType02.HasForm(curForm)
                    removeAll(obSortRef, curForm, obDestination02)
                EndIf
            Else
                removeAll(obSortRef, curForm, obDestination01)
            EndIf
            i += 1
        EndWhile
    Else
        While i < itemsLeft
            obSortRef.RemoveItem(FormsToSort[i], 999999, true, obDestination01)
            i += 1
        EndWhile
    EndIf
EndFunction

;/
  Function SortForSoulGems(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems, ObjectReference zDestination01 = None, ObjectReference zDestination02 = None, FormList CLWASortingPLFormType = None, FormList CLWASortingBLFormType = None) Global
    Form[] RefsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 61, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    int itemsLeft = RefsToSort.Length
    int i = 0
    ObjectReference curRef
    SoulGem curGemBase
    While i < itemsLeft
        curRef = RefsToSort[i] as ObjectReference
        curGemBase = curRef.GetBaseObject() as SoulGem
        If curGemBase && curSGem.GetGemSize()
            ;Debug.Trace("[BCD-CLWA_SS] "+"Reference #"+(i+1)+"/"+itemsLeft+" \"" + curRef.GetDisplayName() + "\" is a Soul Gem with a stored soul size of "+PO3_SKSEFunctions.GetStoredSoulSize(curRef)+"/"+curSGem.GetGemSize())
            If PO3_SKSEFunctions.GetStoredSoulSize(curRef)
                removeAll(obSortRef, curRef, zDestination02)
            Else
                removeAll(obSortRef, curRef, zDestination01)
            EndIf

        Else
            ;Debug.Trace("[BCD-CLWA_SS] "+"Reference #"+(i+1)+"/"+itemsLeft+" \"" + curRef.GetDisplayName() + "\" is not a Soul Gem.")
        EndIf
        i += 1
    EndWhile

    ; Once persistent refs are handled, resort to using the gem's defined size

    Form[] GemsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 52, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    SoulGem curSGem
    itemsLeft = GemsToSort.Length
    i = 0
    While i < itemsLeft
        curSGem = GemsToSort[i] as SoulGem
        If curSGem && curSGem.GetGemSize()
            curRef = obSortRef.PlaceAtMe(curSGem, 1, false, true)
            ;Debug.Trace("[BCD-CLWA_SS] "+"Gem #"+(i+1)+"/"+itemsLeft+" is a Soul Gem with a soul size of: "+PO3_SKSEFunctions.GetStoredSoulSize(curRef)+"/"+curSGem.GetGemSize())
            If PO3_SKSEFunctions.GetStoredSoulSize(curRef)
                removeAll(obSortRef, curSGem, zDestination01)
            Else
                removeAll(obSortRef, curSGem, zDestination02)
            EndIf
            i += 1
        Else
            ;Debug.Trace("[BCD-CLWA_SS] "+"Gem #"+(i+1)+"/"+itemsLeft+" \"" + curSGem.GetName() + "\" is not a Soul Gem... somehow.")
        EndIf
    EndWhile
 EndFunction
/;



Function SortForBooks(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)
    {Sorts books alphabetically (merging W/X and Y/Z)
    NOT intended for languages using a non-English alphabet}

    removeAll(obSortRef, CLWASortingPLStudyBooks_A, zDestination01)
    removeAll(obSortRef, CLWASortedList_StudyBooks_A, zDestination01)

    removeAll(obSortRef, CLWASortingPLStudyBooks_B, zDestination02)
    removeAll(obSortRef, CLWASortedList_StudyBooks_B, zDestination02)

    removeAll(obSortRef, CLWASortingPLStudyBooks_C, zDestination03)
    removeAll(obSortRef, CLWASortedList_StudyBooks_C, zDestination03)

    removeAll(obSortRef, CLWASortingPLStudyBooks_D, zDestination04)
    removeAll(obSortRef, CLWASortedList_StudyBooks_D, zDestination04)

    removeAll(obSortRef, CLWASortingPLStudyBooks_E, zDestination05)
    removeAll(obSortRef, CLWASortedList_StudyBooks_E, zDestination05)

    removeAll(obSortRef, CLWASortingPLStudyBooks_F, zDestination06)
    removeAll(obSortRef, CLWASortedList_StudyBooks_F, zDestination06)

    removeAll(obSortRef, CLWASortingPLStudyBooks_G, zDestination07)
    removeAll(obSortRef, CLWASortedList_StudyBooks_G, zDestination07)

    removeAll(obSortRef, CLWASortingPLStudyBooks_H, zDestination08)
    removeAll(obSortRef, CLWASortedList_StudyBooks_H, zDestination08)

    removeAll(obSortRef, CLWASortingPLStudyBooks_I, zDestination09)
    removeAll(obSortRef, CLWASortedList_StudyBooks_I, zDestination09)

    removeAll(obSortRef, CLWASortingPLStudyBooks_J, zDestination10)
    removeAll(obSortRef, CLWASortedList_StudyBooks_J, zDestination10)

    removeAll(obSortRef, CLWASortingPLStudyBooks_K, zDestination11)
    removeAll(obSortRef, CLWASortedList_StudyBooks_K, zDestination11)

    removeAll(obSortRef, CLWASortingPLStudyBooks_L, zDestination12)
    removeAll(obSortRef, CLWASortedList_StudyBooks_L, zDestination12)

    removeAll(obSortRef, CLWASortingPLStudyBooks_M, zDestination13)
    removeAll(obSortRef, CLWASortedList_StudyBooks_M, zDestination13)

    removeAll(obSortRef, CLWASortingPLStudyBooks_N, zDestination14)
    removeAll(obSortRef, CLWASortedList_StudyBooks_N, zDestination14)

    removeAll(obSortRef, CLWASortingPLStudyBooks_O, zDestination15)
    removeAll(obSortRef, CLWASortedList_StudyBooks_O, zDestination15)

    removeAll(obSortRef, CLWASortingPLStudyBooks_P, zDestination16)
    removeAll(obSortRef, CLWASortedList_StudyBooks_P, zDestination16)

    removeAll(obSortRef, CLWASortingPLStudyBooks_Q, zDestination17)
    removeAll(obSortRef, CLWASortedList_StudyBooks_Q, zDestination17)

    removeAll(obSortRef, CLWASortingPLStudyBooks_R, zDestination18)
    removeAll(obSortRef, CLWASortedList_StudyBooks_R, zDestination18)

    removeAll(obSortRef, CLWASortingPLStudyBooks_S, zDestination19)
    removeAll(obSortRef, CLWASortedList_StudyBooks_S, zDestination19)

    removeAll(obSortRef, CLWASortingPLStudyBooks_T, zDestination20)
    removeAll(obSortRef, CLWASortedList_StudyBooks_T, zDestination20)

    removeAll(obSortRef, CLWASortingPLStudyBooks_U, zDestination21)
    removeAll(obSortRef, CLWASortedList_StudyBooks_U, zDestination21)

    removeAll(obSortRef, CLWASortingPLStudyBooks_V, zDestination22)
    removeAll(obSortRef, CLWASortedList_StudyBooks_V, zDestination22)

    removeAll(obSortRef, CLWASortingPLStudyBooks_WX, zDestination23)
    removeAll(obSortRef, CLWASortedList_StudyBooks_WX, zDestination23)

    removeAll(obSortRef, CLWASortingPLStudyBooks_YZ, zDestination24)
    removeAll(obSortRef, CLWASortedList_StudyBooks_YZ, zDestination24)

    removeAll(obSortRef, CLWASortingPLStudyBooks_Notes, zDestination25)
    removeAll(obSortRef, CLWASortedList_StudyBooks_Notes, zDestination25)

    removeAll(obSortRef, CLWASortingPLStudyBooks_SpellTomes, zDestination26)
    removeAll(obSortRef, CLWASortedList_StudyBooks_SpellTomes, zDestination26)

    removeAll(obSortRef, CLWASortedList_StudyBooks_PotionRecipes, zDestination27)
    removeAll(obSortRef, CLWASortingPLStudyBooks_PotionRecipes, zDestination27)


    int i = 0
    Int j
    String ItemName
    Book CurrentBook
    String FirstChar
    String CurrentChar
    String CurrentCharPlusOne
    Int ItemNameLength
    Form[] BooksToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 27, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int ItemsLeft = BooksToSort.Length
    While i < itemsLeft
        CurrentBook = BooksToSort[i] as Book
        ;Debug.Trace("[BCD-CLWA_SS] "+CurrentBook+" #"+(i+1)+"/"+itemsLeft+"\""+CurrentBook.GetName()+"\"")
        If CurrentBook.HasKeyword(VendorItemSpellTome) || CurrentBook.GetSpell() != None ; If it has a spell or the keyword, it is almost certainly a spell tome
            ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Spell Tome - Spell \""+CurrentBook.GetSpell().GetName()+"\"")
            removeAll(obSortRef, CurrentBook, zDestination26)

        elseif CurrentBook.HasKeyword(VendorItemRecipe) ; If it has the Potion Recipe keyword, then send it to the new Potion Recipe container.
            ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Potion Recipe")
            removeAll(obSortRef, CurrentBook, zDestination27)

        elseif Find(CurrentBook.GetWorldModelPath(), "Note") > -1 || Find(CurrentBook.GetWorldModelPath(), "note") > -1 ; Does the book have the word "note" in its model path? If so, it's probably a note.
            ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Note (NOT a Potion Recipe)")
            removeAll(obSortRef, CurrentBook, zDestination25)

        Else ; Here's where the techno-wizardry begins. Normally, I'd search for the first letter and categorize from there.
             ; However, Antistar decided ~~that he'd make my life miserable and~~ that the word "The" doesn't count. Fun.
            ItemName = CurrentBook.GetName()
            ;Debug.Trace("[BCD-CLWA_SS] "+"Name: "+ItemName)
            ItemNameLength = -1
            ItemNameLength = StringUtil.GetLength(ItemName)
            ;Debug.Trace("[BCD-CLWA_SS] "+"Name Length: "+ItemNameLength)
            j = 0
            FirstChar = ""
            CurrentChar = ""
            Int NextChar
            While FirstChar == "" && j < ItemNameLength
                CurrentChar = GetNthChar(ItemName, j) ; Store the current character to prevent spamming the same function over and over again
                CurrentCharPlusOne = GetNthChar(ItemName, j+1) ; Store the next character to prevent spamming the same function over and over again
                If isLetter(CurrentChar)
                    ;Debug.Trace("[BCD-CLWA_SS] "+"Current letter: "+CurrentChar)
                    If ;/ the current word is "the", skip it /; (CurrentChar == "T" || CurrentChar == "t") && (CurrentCharPlusOne == "h" || CurrentCharPlusOne == "H") && (GetNthChar(ItemName, j+2) == "e" || GetNthChar(ItemName, j+2) == "E") && !isLetter(GetNthChar(ItemName, j+3))
                        j+=2
                    Else
                        FirstChar = CurrentChar
                    EndIf
                elseif IsDigit(CurrentChar)
                    ;Debug.Trace("[BCD-CLWA_SS] "+"Current Digit: "+CurrentChar)
                    If CurrentChar == "2" || CurrentChar == "3"
                        FirstChar = "T"
                    elseif CurrentChar == "1"
                        ; English is MEAN!
                        ; Checks for numbers 10-19
                        FirstChar = "O"
                        If !isDigit(GetNthChar(ItemName, j+2))
                            NextChar = CurrentCharPlusOne as Int
                            If NextChar == 1 || NextChar == 8
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
                            EndIf
                        EndIf
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
                    EndIf

                EndIf
                j += 1
            EndWhile
            If FirstChar != ""
                ;Debug.Trace("[BCD-CLWA_SS] "+"First character: " + FirstChar)
                ; This is a BIG If statement
                If FirstChar == "A" || FirstChar == "a"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is A!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_A, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_A, zDestination01)
                    EndIf

                elseif FirstChar == "B" || FirstChar == "b"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is B!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_B, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_B, zDestination02)
                    EndIf

                elseif FirstChar == "C" || FirstChar == "c"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is C!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_C, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_C, zDestination03)
                    EndIf

                elseif FirstChar == "D" || FirstChar == "d"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is D!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_D, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_D, zDestination04)
                    EndIf

                elseif FirstChar == "E" || FirstChar == "e"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is E!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_E, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_E, zDestination05)
                    EndIf

                elseif FirstChar == "F" || FirstChar == "f"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is F!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_F, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_F, zDestination06)
                    EndIf

                elseif FirstChar == "G" || FirstChar == "g"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is G!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_G, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_G, zDestination07)
                    EndIf

                elseif FirstChar == "H" || FirstChar == "h"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is H!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_H, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_H, zDestination08)
                    EndIf

                elseif FirstChar == "I" || FirstChar == "i"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is I!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_I, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_I, zDestination09)
                    EndIf

                elseif FirstChar == "J" || FirstChar == "j"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is J!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_J, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_J, zDestination10)
                    EndIf

                elseif FirstChar == "K" || FirstChar == "k"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is K!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_K, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_K, zDestination11)
                    EndIf

                elseif FirstChar == "L" || FirstChar == "l"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is L!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_L, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_L, zDestination12)
                    EndIf

                elseif FirstChar == "M" || FirstChar == "m"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is M!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_M, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_M, zDestination13)
                    EndIf

                elseif FirstChar == "N" || FirstChar == "n"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is N!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_N, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_N, zDestination14)
                    EndIf

                elseif FirstChar == "O" || FirstChar == "o"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is O!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_O, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_O, zDestination15)
                    EndIf

                elseif FirstChar == "P" || FirstChar == "p"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is P!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_P, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_P, zDestination16)
                    EndIf

                elseif FirstChar == "R" || FirstChar == "r"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is R!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_R, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_R, zDestination18)
                    EndIf

                elseif FirstChar == "S" || FirstChar == "s"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is S!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_S, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_S, zDestination19)
                    EndIf

                elseif FirstChar == "T" || FirstChar == "t"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is T!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_T, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_T, zDestination20)
                    EndIf

                elseif FirstChar == "U" || FirstChar == "u"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is U!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_U, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_U, zDestination21)
                    EndIf

                elseif FirstChar == "V" || FirstChar == "v"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is V!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_V, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_V, zDestination22)
                    EndIf

                elseif FirstChar == "W" || FirstChar == "w" || FirstChar == "X" || FirstChar == "x"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is W or X!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_WX, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_WX, zDestination23)
                    EndIf

                elseif FirstChar == "Y" || FirstChar == "y" || FirstChar == "Z" || FirstChar == "z"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is Y or Z!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_YZ, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_YZ, zDestination24)
                    EndIf

                elseif FirstChar == "Q" || FirstChar == "q"
                    ;Debug.Trace("[BCD-CLWA_SS] "+"First Character is Q!")
                    If notInListOrNoList(CLWASortingBLStudyBooks_Q, CurrentBook)
                        RemoveAllAndAddToList(obSortRef, CurrentBook, CLWASortedList_StudyBooks_Q, zDestination17) ; There aren't even any books starting with Q in vanilla
                    EndIf

                EndIf
            EndIf
        EndIf
        ;Debug.Trace("[BCD-CLWA_SS] "+"Finished with \""+CurrentBook.GetName()+"\"\n")
        i += 1
    EndWhile
EndFunction


Function SortForPotions(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)
    {Sorts potions and poisons into two separate containers}


    ;Debug.Trace("[BCD-CLWA_SS] "+"SORTING POTIONS -- PAY ATTENTION TO ME!!!")
    obSortRef.RemoveItem(CLWASortingPLStudyPotions, 999999, false, zDestination01)
    obSortRef.RemoveItem(CLWASortedList_StudyPotions, 999999, false, zDestination01)

    obSortRef.RemoveItem(CLWASortingPLStudyPoisons, 999999, false, zDestination02)
    obSortRef.RemoveItem(CLWASortedList_StudyPoisons, 999999, false, zDestination02)

    Form[] PotionsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = PotionsToSort.Length
    int i = 0
    Potion CurrentPotion
    While i < itemsLeft
        CurrentPotion = PotionsToSort[i] as Potion
        If !CurrentPotion.IsFood()
            If (CurrentPotion.IsPoison() || CurrentPotion.IsHostile()) && (!CLWASortingBLStudyPoisons || !CLWASortingBLStudyPoisons.HasForm(CurrentPotion))
                ;Debug.Trace("[BCD-CLWA_SS] "+CurrentPotion+" (#"+i+") is a poison")
                RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_StudyPoisons, zDestination02)

            elseif (!CLWASortingBLStudyPotions || !CLWASortingBLStudyPotions.HasForm(CurrentPotion))
                ;Debug.Trace("[BCD-CLWA_SS] "+CurrentPotion+" (#"+i+") is not a poison")
                RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_StudyPotions, zDestination01)

            EndIf
        Else
            ;Debug.Trace("[BCD-CLWA_SS] "+CurrentPotion+" (#"+i+") is food", 1)
        EndIf
        i += 1
    EndWhile
EndFunction


Function SortForWorkRoom(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)
    {Sorts various smithing materials into their appropriate containers, including a misc. container}

    ; Simplified version of SortByFormType
    If zDestination06
        Form[] IngsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = IngsToSort.Length
        While i < itemsLeft
            removeAll(obSortRef, IngsToSort[i], zDestination06)
            i += 1
        EndWhile
    EndIf

    removeAll(obSortRef, CLWASortingPLWorkRoomIngots, zDestination01)
    removeAll(obSortRef, CLWASortedList_WorkRoomIngots, zDestination01)

    removeAll(obSortRef, CLWASortingPLWorkRoomOres, zDestination02)
    removeAll(obSortRef, CLWASortedList_WorkRoomOres, zDestination02)

    removeAll(obSortRef, CLWASortingPLWorkRoomHides, zDestination03)
    removeAll(obSortRef, CLWASortedList_WorkRoomHides, zDestination03)

    removeAll(obSortRef, CLWASortingPLWorkRoomGems, zDestination04)
    removeAll(obSortRef, CLWASortedList_WorkRoomGems, zDestination04)

    removeAll(obSortRef, CLWASortingPLWorkRoomMisc, zDestination05)
    removeAll(obSortRef, CLWASortedList_WorkRoomMisc, zDestination05)

    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 32, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FormsToSort.Length
    int i = 0
    Form CurrentForm
    String CurrentFormName
    String CurrentFormNameKeywords
    String CurrentFormModelPath
    While i < itemsLeft
        CurrentForm = FormsToSort[i]
        CurrentFormName = PO3_SKSEFunctions.GetFormEditorID(CurrentForm) + " | " + CurrentForm.GetName()
        CurrentFormNameKeywords = CurrentForm.GetKeywords()
        CurrentFormModelPath = CurrentForm.GetWorldModelPath()
        ;Debug.Trace("[BCD-CLWA_SS] "+CurrentForm+" \""+CurrentFormName+"\" #"+(i+1)+"/"+itemsLeft+" with form type "+CurrentForm.GetType()+" has model path \""+CurrentFormModelPath+"\"\n==================== KEYWORDS ====================\n"+CurrentFormNameKeywords)
        If zDestination01 &&      ;/                Ingots               /; notInListOrNoList(CLWASortingBLWorkRoomIngots, CurrentForm) && CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter) && (Find(CurrentFormModelPath, "Ingot") != -1 || Find(CurrentFormModelPath, "ingot") != -1)
            ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as an Ingot")
            RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomIngots, zDestination01)


        elseif zDestination02 &&  ;/                 Ores                /; notInListOrNoList(CLWASortingBLWorkRoomOres, CurrentForm) && CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter) && (Find(CurrentFormModelPath, "Ore") != -1 || Find(CurrentFormModelPath, "ore") != -1)
            ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as Ore")
            RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomOres, zDestination02)

        elseif                     ;/           Leather & Hides           /; CurrentForm.HasKeyword(VendorItemAnimalHide)

            If zDestination05 &&  ;/               Leather               /; notInListOrNoList(CLWASortingBLWorkRoomMisc, CurrentForm) && (Find(CurrentFormModelPath, "Leather") != -1 || Find(CurrentFormModelPath, "leather") != -1)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as Leather")
                RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomMisc, zDestination05)

            elseif zDestination03 ;/                Hides                /; && notInListOrNoList(CLWASortingBLWorkRoomHides, CurrentForm)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as Hide")
                RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomHides, zDestination03)

            EndIf

        elseif zDestination04 &&  ;/                 Gems                /;notInListOrNoList(CLWASortingBLWorkRoomGems, CurrentForm) && CurrentForm.HasKeyword(VendorItemGem)
            ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Gem")
            RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomGems, zDestination04)

        elseif zDestination05 && notInListOrNoList(CLWASortingBLWorkRoomMisc, CurrentForm)

            If                     ;/               Firewood              /; CurrentForm.HasKeyword(VendorItemFireword)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Misc. Item (Firewood)")
                RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomMisc, zDestination05)

            elseif                 ;/               Charcoal              /; Find(CurrentFormModelPath, "Coal") != -1 || Find(CurrentFormModelPath, "coal") != -1
                ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Misc. Item (Charcoal)")
                RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomMisc, zDestination05)

            elseif                 ;/         House Building Mats         /; CurrentForm.HasKeyword(BYOHHouseCraftingCategorySmithing)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Misc. Item (House Building Materials)")
                RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomMisc, zDestination05)

            elseif                 ;/   Ingredients that are MiscItems?   /; CurrentForm.HasKeyword(VendorItemIngredient)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Misc. Item (Ingredients)")
                RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomMisc, zDestination05)

            elseif                 ;/     Catch-All for Ores & Ingots     /;  CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Sorted as a Misc. Item (Ingredients)")
                RemoveAllAndAddToList(obSortRef, CurrentForm, CLWASortedList_WorkRoomMisc, zDestination05)

            EndIf
        EndIf
        ;Debug.Trace("[BCD-CLWA_SS] "+"========================")
        i += 1
    EndWhile
EndFunction


Function SortForFood(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)
    {Sorts foods in to 5 categories (accepts PassLists & BlackLists):
    Drinks, Cheese & Seasonings, Raw Meats, Fruits and Vegetables, and Prepared Food}
    Int itemsLeft
    int i = 0

    ; Simplified version of SortByFormType
    If zDestination06
        Form[] IngsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = IngsToSort.Length
        While i < itemsLeft
            removeAll(obSortRef, IngsToSort[i], zDestination06)
            i += 1
        EndWhile
    EndIf

    removeAll(obSortRef, CLWASortingPLFoodMedeAndCo, zDestination02)
    removeAll(obSortRef, CLWASortedList_FoodMedeAndCo, zDestination02)

    removeAll(obSortRef, CLWASortingPLFoodCheeseSeasonings, zDestination01)
    removeAll(obSortRef, CLWASortedList_FoodCheeseSeasonings, zDestination01)

    removeAll(obSortRef, CLWASortingPLFoodFruitsNVeggies, zDestination03)
    removeAll(obSortRef, CLWASortedList_FoodFruitsNVeggies, zDestination03)

    removeAll(obSortRef, CLWASortingPLFoodRawMeat, zDestination04)
    removeAll(obSortRef, CLWASortedList_FoodRawMeat, zDestination04)

    removeAll(obSortRef, CLWASortingPLFoodMeelz, zDestination05)
    removeAll(obSortRef, CLWASortedList_FoodMeelz, zDestination05)

    If zDestination01 || zDestination02 || zDestination03 || zDestination04 || zDestination05
        Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = FoodToSort.Length
        i = 0
        Potion CurrentPotion
        String CurrentPotionKeywords
        String potName
        Form ITMPotionUse = CLWAItemPotionUse.GetAt(0)
        While i < itemsLeft
            CurrentPotion = FoodToSort[i] as Potion
            If CurrentPotion.IsFood()
                ;/ Here, since Complete Alchemy and Cooking Overhaul is a thing, I check not only with FormLists and weird ways to find fruits (HINT: none exist),
                * but also with Keywords. See, CACO adds keywords like VendorItemDrinkAlcohol (and three other "VendorItemDrink" keywords), VendorItemFruit, etc.
                * So, by adding the item's keywords into a single string, I can check it for specific occurrences, and may even detect
                * foods I didn't anticipate While I'm at it! Just nobody add VendorItemNotFruit please, you can invert your bool check.
                /;

                CurrentPotionKeywords = CurrentPotion.GetKeywords() as String
                potName = PO3_SKSEFunctions.GetFormEditorID(CurrentPotion) + " | " + CurrentPotion.GetName()
                ;Debug.Trace("[BCD-CLWA_SS] "+CurrentPotion+" \""+potName+"\""+" #"+(i+1)+"/"+itemsLeft+" is a food with keywords:\n====================\nUse Sound: "+CurrentPotion.GetUseSound()+"\nKeywords: "+CurrentPotionKeywords+"\n====================")

                If     zDestination02 && ;/        Drinks        /; (!CLWASortingBLFoodMedeAndCo || !CLWASortingBLFoodMedeAndCo.HasForm(CurrentPotion)) && Find(CurrentPotionKeywords, "Stew") == -1 && (Find(CurrentPotionKeywords, "Drink") != -1 || Find(CurrentPotionKeywords, "Drug") != -1 ;/ Gotta catch dope too! /; || CurrentPotion.GetUseSound() == ITMPotionUse)
                    RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_FoodMedeAndCo, zDestination02)

                elseif zDestination05 && ;/       Prepared       /; Find(CurrentPotionKeywords, "Uncooked") == -1 && (!CLWASortingBLFoodMeelz || !CLWASortingBLFoodMeelz.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Cooked") != -1 || Find(CurrentPotionKeywords, "Treat") != -1 || Find(CurrentPotionKeywords, "Stew") != -1 || Find(CurrentPotionKeywords, "Bread") != -1 || Find(CurrentPotionKeywords, "Pastry") != -1 || Find(CurrentPotionKeywords, "Preserved") != -1 || Find(CurrentPotionKeywords, "Meal") != -1)
                    RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_FoodMeelz, zDestination05)

                elseif zDestination01 && ;/ Cheese 'n Seasonings /; (!CLWASortingBLFoodCheeseSeasonings || !CLWASortingBLFoodCheeseSeasonings.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Cheese") != -1 || Find(CurrentPotionKeywords, "Fat") != -1 || Find(CurrentPotionKeywords, "DryGoods") != -1 || Find(potName, "Cheese") != -1 || Find(potName, "cheese") != -1)
                    RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_FoodCheeseSeasonings, zDestination01)

                elseif zDestination03 && ;/  Fruits and Veggies  /; (!CLWASortingBLFoodFruitsNVeggies || !CLWASortingBLFoodFruitsNVeggies.HasForm(CurrentPotion)) && (Find(CurrentPotionKeywords, "Fruit") != -1 || Find(CurrentPotionKeywords, "Vegetable") != -1)
                    RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_FoodFruitsNVeggies, zDestination03)

                elseif zDestination04 && ;/         Meat         /; (!CLWASortingBLFoodRawMeat || !CLWASortingBLFoodRawMeat.HasForm(CurrentPotion)) && (CurrentPotion.HasKeyword(VendorItemFoodRaw) || Find(CurrentPotionKeywords, "Meat") != -1)
                    RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_FoodRawMeat, zDestination04)

                elseif zDestination05 && ;/  Prepared Catch-All  /; Find(CurrentPotionKeywords, "Uncooked") == -1 && (!CLWASortingBLFoodMeelz || !CLWASortingBLFoodMeelz.HasForm(CurrentPotion))
                    RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_FoodMeelz, zDestination05)
                EndIf
            EndIf
            i += 1
        EndWhile
    EndIf
EndFunction


Function SortForArmoury(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)
    {Sorts armor and weapons into specific containers}

    Int itemsLeft
    int i

    If zDestination01
        removeAll(obSortRef, CLWASortingPLArmouryAmmo, zDestination01)
        Form[] ArrowsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 42, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = ArrowsToSort.Length
        i = 0
        While i < itemsLeft
            removeAll(obSortRef, ArrowsToSort[i], zDestination01)
            i += 1
        EndWhile
    EndIf

    If zDestination06 || zDestination07 || zDestination08 || zDestination09
        If zDestination06
            removeAll(obSortRef, CLWASortingPLArmouryWeapons1H, zDestination06)
            removeAll(obSortRef, CLWASortedList_ArmouryWeapons1H, zDestination06)
        EndIf
        If zDestination07
            removeAll(obSortRef, CLWASortingPLArmouryWeapons2H, zDestination07)
            removeAll(obSortRef, CLWASortedList_ArmouryWeapons2H, zDestination07)
        EndIf
        If zDestination08
            removeAll(obSortRef, CLWASortingPLArmouryWeaponsRanged, zDestination08)
            removeAll(obSortRef, CLWASortedList_ArmouryWeaponsRanged, zDestination08)
        EndIf
        If zDestination09
            removeAll(obSortRef, CLWASortingPLArmouryWeaponsRanged, zDestination09)
            removeAll(obSortRef, CLWASortedList_ArmouryWeaponsStaves, zDestination09)
        EndIf
        Form[] WeaponsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 41, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = WeaponsToSort.Length
        i = 0
        Weapon curWeap
        String curWeapSkill
        While i < itemsLeft
            curWeap = WeaponsToSort[i] as Weapon
            curWeapSkill = curWeap.GetSkill()
            If     ;/ 1-Handed /; zDestination06 && curWeapSkill == "OneHanded"
                RemoveAllAndAddToList(obSortRef, curWeap, CLWASortedList_ArmouryWeapons1H, zDestination06)
            elseif ;/ 2-Handed /; zDestination07 && curWeapSkill == "TwoHanded"
                RemoveAllAndAddToList(obSortRef, curWeap, CLWASortedList_ArmouryWeapons2H, zDestination07)
            elseif ;/  Ranged  /; zDestination08 && curWeapSkill == "Marksman"
                RemoveAllAndAddToList(obSortRef, curWeap, CLWASortedList_ArmouryWeaponsRanged, zDestination08)
            elseif ;/  Staves  /; zDestination09 && (curWeap.HasKeyword(WeapTypeStaff) || PO3_SKSEFunctions.GetEnchantmentType(curWeap.GetEnchantment()) == 12)
                RemoveAllAndAddToList(obSortRef, curWeap, CLWASortedList_ArmouryWeaponsStaves, zDestination09)
            EndIf
            i += 1
        EndWhile
    EndIf

    If zDestination02 || zDestination03 || zDestination04 || zDestination05
        If zDestination02
            removeAll(obSortRef, CLWASortingPLArmouryArmourLight, zDestination02)
            removeAll(obSortRef, CLWASortedList_ArmouryArmourLight, zDestination02)
        EndIf
        If zDestination03
            removeAll(obSortRef, CLWASortingPLArmouryArmourHeavy, zDestination03)
            removeAll(obSortRef, CLWASortedList_ArmouryArmourHeavy, zDestination03)
        EndIf
        If zDestination04
            removeAll(obSortRef, CLWASortingPLArmouryArmourJewelry, zDestination04)
            removeAll(obSortRef, CLWASortedList_ArmouryArmourJewelry, zDestination04)
        EndIf
        If zDestination05
            removeAll(obSortRef, CLWASortingPLArmouryArmourClothes, zDestination05)
            removeAll(obSortRef, CLWASortedList_ArmouryArmourClothes, zDestination05)
        EndIf
        Form[] ArmorToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 26, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
        itemsLeft = ArmorToSort.Length
        i = 0
        Armor curArmor
        Int curArmorWC
        While i < itemsLeft
            curArmor = ArmorToSort[i] as Armor
            curArmorWC = curArmor.GetWeightClass()
            ;Debug.Trace("[BCD-CLWA_SS] "+curArmor+" Weight Class: "+curArmorWC+"\nKeywords: "+curArmor.GetKeywords())
            If zDestination02 && curArmorWC == 0
                RemoveAllAndAddToList(obSortRef, curArmor, CLWASortedList_ArmouryArmourLight, zDestination02)

            elseif zDestination03 && curArmorWC == 1
                RemoveAllAndAddToList(obSortRef, curArmor, CLWASortedList_ArmouryArmourHeavy, zDestination03)

            elseif zDestination04 && curArmor.HasKeyword(ArmorJewelry)
                RemoveAllAndAddToList(obSortRef, curArmor, CLWASortedList_ArmouryArmourJewelry, zDestination04)

            elseif zDestination05 && curArmor.HasKeyword(ArmorClothing)
                RemoveAllAndAddToList(obSortRef, curArmor, CLWASortedList_ArmouryArmourClothes, zDestination05)
            EndIf
            i += 1
        EndWhile
    EndIf
EndFunction


  ; Sorting functions for each room

Function SortForDestKitchen(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)

    removeAll(obSortRef, CLWASortingPLFoodFruitsNVeggies, zDestination01)
    removeAll(obSortRef, CLWASortedList_FoodFruitsNVeggies, zDestination01)

    removeAll(obSortRef, CLWASortingPLFoodMedeAndCo, zDestination01)
    removeAll(obSortRef, CLWASortedList_FoodMedeAndCo, zDestination01)

    removeAll(obSortRef, CLWASortingPLFoodRawMeat, zDestination01)
    removeAll(obSortRef, CLWASortedList_FoodRawMeat, zDestination01)

    removeAll(obSortRef, CLWASortingPLFoodMeelz, zDestination01)
    removeAll(obSortRef, CLWASortedList_FoodMeelz, zDestination01)

    removeAll(obSortRef, CLWASortingPLFoodCheeseSeasonings, zDestination01)
    removeAll(obSortRef, CLWASortedList_FoodCheeseSeasonings, zDestination01)


    Form[] FoodToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FoodToSort.Length
    int i = 0
    Potion CurrentPotion
    While i < itemsLeft
        CurrentPotion = FoodToSort[i] as Potion
        If zDestination01 && CurrentPotion.IsFood() &&  (!CLWASortingBLFoodRawMeat || !CLWASortingBLFoodRawMeat.HasForm(CurrentPotion))
            RemoveAllAndAddToList(obSortRef, CurrentPotion, CLWASortedList_FoodRawMeat, zDestination01)
        EndIf
        i += 1
    EndWhile
EndFunction

Function SortForDestStudy(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)
    removeAll(obSortRef, CLWASortingPLStudyPotions, zDestination01)
    removeAll(obSortRef, CLWASortedList_StudyPotions, zDestination01)

    removeAll(obSortRef, CLWASortingPLStudyPoisons, zDestination01)
    removeAll(obSortRef, CLWASortedList_StudyPoisons, zDestination01)

    Form[] ScrollsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 23, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ScrollsToSort.Length
    i = 0
    While i < itemsLeft
        obSortRef.RemoveItem(ScrollsToSort[i], 9999, true, zDestination01)
        i += 1
    EndWhile

    Form[] BooksToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 27, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = BooksToSort.Length
    i = 0
    While i < itemsLeft
        obSortRef.RemoveItem(BooksToSort[i], 9999, true, zDestination01)
        i += 1
    EndWhile

    Form[] IngredientsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 30, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = IngredientsToSort.Length
    i = 0
    While i < itemsLeft
        obSortRef.RemoveItem(IngredientsToSort[i], 9999, true, zDestination01)
        i += 1
    EndWhile

    Form[] sGemsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 52, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = sGemsToSort.Length
    i = 0
    While i < itemsLeft
        obSortRef.RemoveItem(sGemsToSort[i], 9999, true, zDestination01)
        i += 1
    EndWhile

    Form[] PotionsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 46, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = PotionsToSort.Length
    int i = 0
    Potion CurrentPotion
    While i < itemsLeft
        CurrentPotion = PotionsToSort[i] as Potion
        If zDestination01 && !CurrentPotion.IsFood() && ((!CLWASortingBLStudyPotions || !CLWASortingBLStudyPotions.HasForm(CurrentPotion)) || ((CurrentPotion.IsHostile() || CurrentPotion.IsPoison()) && (!CLWASortingBLStudyPoisons || !CLWASortingBLStudyPoisons.HasForm(CurrentPotion))))
            obSortRef.RemoveItem(CurrentPotion, 9999999, true, zDestination01)
        EndIf
        i += 1
    EndWhile
EndFunction

Function SortForDestArmoury(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)
    removeAll(obSortRef, CLWASortingPLArmouryAmmo, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryAmmo, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryArmourLight, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryArmourLight, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryArmourHeavy, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryArmourHeavy, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryArmourClothes, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryArmourClothes, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryArmourJewelry, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryArmourJewelry, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryWeapons1H, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryWeapons1H, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryWeapons2H, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryWeapons2H, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryWeaponsRanged, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryWeaponsRanged, zDestination01)

    removeAll(obSortRef, CLWASortingPLArmouryWeaponsStaves, zDestination01)
    removeAll(obSortRef, CLWASortedList_ArmouryWeaponsStaves, zDestination01)

    Form[] ArrowsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 42, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ArrowsToSort.Length
    i = 0
    Form curForm
    While i < itemsLeft
        curForm = ArrowsToSort[i]
        If !CLWASortingBLArmouryAmmo || !CLWASortingBLArmouryAmmo.HasForm(curForm)
            removeAll(obSortRef, CLWASortingPLArmouryAmmo, zDestination01)
        EndIf
        i += 1
    EndWhile

    Form[] WeaponsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 41, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = WeaponsToSort.Length
    int i = 0
    Weapon curWeap
    String curWeapSkill
    While i < itemsLeft
        curWeap = WeaponsToSort[i] as Weapon
        curWeapSkill = curWeap.GetSkill()
        If ;/  Staves  /;((curWeap.HasKeyword(WeapTypeStaff) || PO3_SKSEFunctions.GetEnchantmentType(curWeap.GetEnchantment()) == 12) && (!CLWASortingBLArmouryWeaponsStaves || !CLWASortingBLArmouryWeaponsStaves.HasForm(curWeap))) ||;/
              1-Handed /; (curWeapSkill == "OneHanded" && (!CLWASortingBLArmouryWeapons1H || !CLWASortingBLArmouryWeapons1H.HasForm(curWeap))) ||;/
              2-Handed /; (curWeapSkill == "TwoHanded" && (!CLWASortingBLArmouryWeapons2H || !CLWASortingBLArmouryWeapons2H.HasForm(curWeap))) ||;/
               Ranged  /; (curWeapSkill == "Marksman" && (!CLWASortingBLArmouryWeaponsRanged || !CLWASortingBLArmouryWeaponsRanged.HasForm(curWeap)))
            removeAll(obSortRef, curWeap, zDestination01)
        EndIf
        i += 1
    EndWhile

    Form[] ArmorToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 26, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    itemsLeft = ArmorToSort.Length
    i = 0
    Armor SortingArmour
    While i < itemsLeft
        SortingArmour = ArmorToSort[i] as Armor
        If  ;/ Normal Armor /;(SortingArmour.GetWeightClass() != 2 && (!CLWASortingBLArmouryArmourLight || CLWASortingPLArmouryArmourLight.HasForm(SortingArmour)) && (!CLWASortingBLArmouryArmourHeavy || CLWASortingPLArmouryArmourHeavy.HasForm(SortingArmour))) || ;/
               Clothing     /; (SortingArmour.HasKeyword(ArmorClothing) && (!CLWASortingBLArmouryArmourClothes || !CLWASortingBLArmouryArmourClothes.HasForm(SortingArmour))) ||;/
               Jewelry      /; (SortingArmour.HasKeyword(ArmorJewelry) && (!CLWASortingBLArmouryArmourJewelry || !CLWASortingBLArmouryArmourClothes.HasForm(SortingArmour)))
            removeAll(obSortRef, CLWASortingPLArmouryArmourLight, zDestination01)
        EndIf
        i += 1
    EndWhile
EndFunction

Function SortForDestWorkRoom(ObjectReference obSortRef, Bool bBlockEquipedItems, Bool bBlockFavorites, Bool bBlockQuestItems)

    removeAll(obSortRef, CLWASortingPLWorkRoomGems, zDestination01)
    removeAll(obSortRef, CLWASortedList_WorkRoomGems, zDestination01)

    removeAll(obSortRef, CLWASortingPLWorkRoomHides, zDestination01)
    removeAll(obSortRef, CLWASortedList_WorkRoomHides, zDestination01)

    removeAll(obSortRef, CLWASortingPLWorkRoomIngots, zDestination01)
    removeAll(obSortRef, CLWASortedList_WorkRoomIngots, zDestination01)

    removeAll(obSortRef, CLWASortingPLWorkRoomOres, zDestination01)
    removeAll(obSortRef, CLWASortedList_WorkRoomOres, zDestination01)

    removeAll(obSortRef, CLWASortingPLWorkRoomMisc, zDestination01)
    removeAll(obSortRef, CLWASortedList_WorkRoomMisc, zDestination01)

    Form[] FormsToSort = PO3_SKSEFunctions.AddItemsOfTypeToArray(obSortRef, 32, bBlockEquipedItems, bBlockFavorites, bBlockQuestItems)
    Int itemsLeft = FormsToSort.Length
    int i = 0
    Form CurrentForm
    String CurrentFormName
    String CurrentFormNameKeywords
    String CurrentFormModelPath
    While i < itemsLeft
        CurrentForm = FormsToSort[i]
        CurrentFormName = PO3_SKSEFunctions.GetFormEditorID(CurrentForm) + " | " + CurrentForm.GetName()
        CurrentFormNameKeywords = CurrentForm.GetKeywords()
        CurrentFormModelPath = CurrentForm.GetWorldModelPath()
        If (notInListOrNoList(CLWASortingBLWorkRoomHides, CurrentForm) && CurrentForm.HasKeyword(VendorItemAnimalHide)) || (notInListOrNoList(CLWASortingBLWorkRoomGems, CurrentForm) && CurrentForm.HasKeyword(VendorItemGem)) || (notInListOrNoList(CLWASortingBLWorkRoomIngots, CurrentForm) && CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter)) || (notInListOrNoList(CLWASortingBLWorkRoomMisc, CurrentForm) && (CurrentForm.HasKeyword(VendorItemFireword) || CurrentForm.HasKeyword(BYOHHouseCraftingCategorySmithing) || CurrentForm.HasKeyword(VendorItemIngredient) || (CurrentForm.HasKeyword(VendorItemOreIngot) && !CurrentForm.HasKeyword(VendorItemClutter)) || Find(CurrentFormModelPath, "Coal") != -1 || Find(CurrentFormModelPath, "coal") != -1))
            removeAll(obSortRef, CurrentForm, zDestination01)
        EndIf
        i += 1
    EndWhile
EndFunction


;/$$$$$\            $$$$$$\           $$\   $$\       $$$\ $$$\
$$  __$$\           \_$$  _|          \__|  $$ |     $$  _| \$$\
$$ /  $$ |$$$$$$$\    $$ |  $$$$$$$\  $$\ $$$$$$\   $$  /    \$$\
$$ |  $$ |$$  __$$\   $$ |  $$  __$$\ $$ |\_$$  _|  $$ |      $$ |
$$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |$$ |  $$ |    $$ |      $$ |
$$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |$$ |  $$ |$$\ \$$\     $$  |
\$$$$$$  |$$ |  $$ |$$$$$$\ $$ |  $$ |$$ |  \$$$$  | \$$$\ $$$  /
 \______/ \__|  \__|\______|\__|  \__|\__|   \____/   \___|\___/;


 Event OnInit()
    ; Check If SKSE is not installed
    If SKSE.GetVersionRelease() < 0
        ;Debug.TraceAndBox("SKSE not installed!\nAdditional Clockwork's Superior Sorting will not work and will spam Papyrus logs If attempted.\n\nSorry for the message spam!\n\nWarning Sender:\n"+self, 2)
    EndIf

    ; Check If Papyrus Extender is installed
    If PO3_SKSEFunctions.StringToInt("128") != 128
        ;Debug.TraceAndBox("powerofthree's Papyrus Extender not installed!\nAdditional Clockwork's Superior Sorting will not work and will spam Papyrus logs If attempted.\n\nSorry for the message spam!\n\nWarning Sender:\n"+self, 2)
    EndIf

    ; Optionally disable a form on startup (used to allow mid-game installs)
    If aFormToDisable
        aFormToDisable.DisableNoWait()
    EndIf

    ; Fill a property now to eliminate unnecessary processing
    PlayerREF = Game.GetPlayer()
 EndEvent



;/$$$$$\             $$$$$$\              $$\     $$\                        $$\                 $$$\ $$$\
$$  __$$\           $$  __$$\             $$ |    \__|                       $$ |               $$  _| \$$\
$$ /  $$ |$$$$$$$\  $$ /  $$ | $$$$$$$\ $$$$$$\   $$\ $$\    $$\  $$$$$$\  $$$$$$\    $$$$$$\  $$  /    \$$\
$$ |  $$ |$$  __$$\ $$$$$$$$ |$$  _____|\_$$  _|  $$ |\$$\  $$  | \____$$\ \_$$  _|  $$  __$$\ $$ |      $$ |
$$ |  $$ |$$ |  $$ |$$  __$$ |$$ /        $$ |    $$ | \$$\$$  /  $$$$$$$ |  $$ |    $$$$$$$$ |$$ |      $$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |        $$ |$$\ $$ |  \$$$  /  $$  __$$ |  $$ |$$\ $$   ____|\$$\     $$  |
\$$$$$$  |$$ |  $$ |$$ |  $$ |\$$$$$$$\   \$$$$  |$$ |   \$  /   \$$$$$$$ |  \$$$$  |\$$$$$$$\  \$$$\ $$$  /
 \______/ \__|  \__|\__|  \__| \_______|   \____/ \__|    \_/     \_______|   \____/  \_______|  \___|\___/;

 Event OnActivate(ObjectReference akActionRef)
    ;Debug.Trace("[BCD-CLWA_SS] "+"Started sorting using SKSE")
    If !Running && (akActionRef == PlayerREF || !aRequirePlayer)

        ; Prevent further processing (likely initiated by player impatience)
        ; NOTE Block Processing
        Running = TRUE
        self.BlockActivation(true)

        ; NOTE Button Handling #1
        If aIsButton ; Push button and play sound
            QSTAstrolabeButtonPressX.Play(self)
            PlayAnimation("down")
            Utility.Wait(0.2)
        EndIf

        ; NOTE Steam Handling
        If aNeedsSteam && akActionRef == PlayerREF && CLWSQ02Machines01GLOB.GetValue() != 1 ; Check If a machine needs Steam and execute the prevention. Also inform the player of why nothing happens
            CLWNoSteamPower01Msg.Show()
        Else
            ; Sorting for the sort buttons
            ; NOTE Destinations
             If xDestinationStudy
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting ingredients")
                 SortForDestStudy(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting ingredients")
             EndIf
             If xDestinationWork
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting smithing materials")
                 SortForDestWorkRoom(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting smithing materials")
             EndIf
             If xDestinationKitchen
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting food")
                 SortForDestKitchen(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting food")
             EndIf
             If xDestinationArmoury
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting Armoury items")
                 SortForDestArmoury(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                 ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting Armoury items")
             EndIf

            ; NOTE Scales
             If SortBooks
                ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting books")
                SortForBooks(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting books")
             EndIf
             If SortPotions
                ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting potions")
                SortForPotions(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting potions")
             EndIf
             If sortFood
                ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting food")
                SortForFood(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting food")
             EndIf
             If sortWorkRoom
                ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting smithing materials")
                SortForWorkRoom(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting smithing materials")
             EndIf
             If sortArmoury
                ;Debug.Trace("[BCD-CLWA_SS] "+"Begin sorting Armoury items")
                SortForArmoury(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems)
                ;Debug.Trace("[BCD-CLWA_SS] "+"Finished sorting Armoury items")
             EndIf

            If pFormTypeToSort
                SortByFormType(akActionRef, pBlockEquipedItems, pBlockFavorites, pBlockQuestItems, pFormTypeToSort, zDestination01, zDestination02)
            EndIf

            ; NOTE Play Sound
            If aPlayTransferSound && self.GetParentCell().IsAttached()
                CLWNPCDwarvenCenturionAttackBreathOutMarker.Play(self)
            EndIf

            ; NOTE Send Completed Message
            If akActionRef == PlayerREF
                If aSortingCompleteMsg
                    aSortingCompleteMsg.Show()
                Else
                    ;Debug.Trace("[BCD-CLWA_SS] "+"No completion message is set for "+self, 1)
                EndIf
            EndIf

        EndIf

        ; NOTE Button Handling #2
        If aIsButton ; Release the button to let the player know it can be activated again
            playAnimation("up")
            Utility.Wait(2.0)
        EndIf

        ; NOTE Unlock Processing
        self.BlockActivation(false)
        Running = FALSE
    EndIf
 EndEvent

;/$$$$$\                        $$\               $$\
$$/ __$$\                       $$ |              \__|
$$ /  \__| $$$$$$\  $$$$$$$\  $$$$$$\    $$$$$$\  $$\ $$$$$$$\   $$$$$$\   $$$$$$\   $$$$$$$\
$$ |      $$  __$$\ $$  __$$\ \_$$  _|   \____$$\ $$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  _____|
$$ |      $$ /  $$ |$$ |  $$ |  $$ |     $$$$$$$ |$$ |$$ |  $$ |$$$$$$$$ |$$ |  \__|\$$$$$$\
$$ |  $$\ $$ |  $$ |$$ |  $$ |  $$ |$$\ $$  __$$ |$$ |$$ |  $$ |$$   ____|$$ |       \____$$\
\$$$$$$/ |\$$$$$$  |$$ |  $$ |  \$$$$  |\$$$$$$$ |$$ |$$ |  $$ |\$$$$$$$\ $$ |      $$$$$$$  |
 \______/  \______/ \__|  \__|   \____/  \_______|\__|\__|  \__| \_______|\__|      \_______/;


 ; If we're being completely honest, the labels for the zDestinations are more for me than for anyone Else.
 ; Seriously, how am I supposed to remember which barrel to point zDestination03 to?

 ObjectReference Property zDestination01  Auto
 {Destination container. Will be sorted in to.

 Books:        A
 Armoury:      Arrows
 Work Room:    Ingots
 Food:         Cheese and Seasonings
 Potions:      Beneficial (Potions)
 Soul Gems:    Empty
 Sort by Type: Primary}
 ObjectReference Property zDestination02  Auto
 {Destination container. May or may not be used depending on sorted form.

 Books:       B
 Armoury:     Light Armor
 Work Room:   Ores
 Food:        Drinks
 Potions:     Harmful (Poisons)
 Soul Gems:   Full
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
 Armoury:   Jewelry
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