# Changelog

## 0.1.0

Added: Woodworker's Whim

## 0.2.0

Added: two compatibility patches for High Poly Project.

## 1.0.0

Added: ***Courier Counterspell***
Added: ***Marked Shadows***
Added: three sorting patches

### **1.0.1**

**MAJOR FIX:** Fixed the Form IDs in Courier Counterspell since they were invalid for a Light plugin.

### **1.0.2**

**Minor Fix:** Fixed the CACO-Curios Ingredients Sorting Patch not installing.

### **1.0.3**

**MAJOR FIX:** Re-applied the 1.0.1 fix since I forgot it.

### **1.0.4**

**MAJOR FIX:** Created new translation files for the Global version of Woodworker's Whim since the previous ones were corrupted and caused a CTD on load.

### **1.0.5**

**SEMI_MAJOR FIX:** Re-added the scripts to the Marked Shadows folder. I have no clue where those went (I probably forgot them).

## **2.0.0**

* Added SKSE ***Superior Sorting***
  * Initialized with patching in mind
  * Adds scales for each labeled container
  * Transfers Ingredients to/from the Kitchen when you get close to the containers
    * A similar supports Ordinator's gem crushing perk
* Merged Courier Counterspell and Mausoleum Door Fix into the new Bug Fixes plugin
  * Fixed the weather at Clockwork Castle, which will now use snow storm and overcast weathers.
  * Fixed both secret cabinets which were not properly aligned with the wall, allowing you to see a rather large gap between the wall and cabinet
  * Added in the missing ceiling tile in the Armoury
  * Aligned the paintings behind the Mage's Study workstations with the wall
* MANY maintenance changes for the repo
* Added Interesting Inhabitants as a testing module
  * Includes most of the features that will be present in the final release
  * Should be entirely stable and cause no harm to your saved game
    * I take no responsibility for damages to your save caused by using a testing plugin.
* Restructured `dist\translations\` folder to apply some of my new-found knowledge on the FOMOD installer

## **2.0.1**

* Fixed Unresolvable FormIDs in Interesting Inhabitants and Superior Sorting

## **2.0.2**

* Fixed Blacklist processing in some parts of [CLWA_SKSE_Sorting.psc](dist/Modules/SKSE/SuperiorSorting/source/scripts/CLWA_SKSE_Sorting.psc)
* Commented out `Debug.Trace()` calls in [CLWA_SKSE_Sorting.psc](dist/Modules/SKSE/SuperiorSorting/source/scripts/CLWA_SKSE_Sorting.psc)
* Removed unused Superior Sorting scripts

## 2.1.0

### Patches

* New "Central Patch API" plugin that supports patching Clockwork's sorting automatically, without the need for messy `Game.GetFormFromFile()` calls.

### Bug Fixes

* Clockwork Bug Fixes
  * Mage's Study Paintings hover in front of the wall
  * TODO: Dark Brotherhood cannot abduct you during the questline
    * Do note that they will be able to abduct you as soon as the questline completes
* Clockwork Bug fixes by [DarthVitrial](https://forums.nexusmods.com/index.php?/user/5014137-darthvitrial/)
  * Remove property that was removed from {SCRIPT} from the plugin
  * Removed 2 bad tint mappings
  * Gave the Shadow race "Advanced Avoidance" (a flag that makes the AI behave somewhat differently)
* Clockwork Project Optimization
  * Fixes an annoying bug with parts of the castle disappearing when looking at them from certain positions at certain angles.
    * Fixed by expanding the "Portals" 1 unit into the walls
  * Free FPS! Occlusion Panes are the best!
* Changed the fix for Lahar not affecting the stealth meter to a scripted method, removing the need for an overwrite
  * TODO: Also applied to Lamashtu

### Superior Sorting

* Added Ingredients container to the Work Room
* Fixed steam showing up before Steam Power is completed with the Ordinator compatibility
TODO: Apply change to Work Room box
* TODO: Added "Passed Lists," a cache to speed up sorting for items that have already passed/failed the filters.

### Interesting Inhabitants

* Added Wall Lean markers all around the castle
* TODO (Fix): Added a script to all Wall Lean markers in the Castle, preventing Gilded from using the markers.
* TODO: Create multiple elaborate scenes for cooking and tending to children

### Woodworker's Whim

#### Mount

* Clockwork's axe automatically mounts itself

#### System

* COMPLETELY REDONE! Rebuilt from THE GROUND UP!
* Split into a separate mod—don't worry, it'll still be bundled with Additional Clockwork, too :wink:
* Fast & Smooth
* Still supports all vanilla-compatible axes and still makes no modifications to the vanilla script
