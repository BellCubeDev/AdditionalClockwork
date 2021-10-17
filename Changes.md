# Changelog

## 0.1.0

Added: Woodworker's Whim

## 0.2.0

Added: two compatibility  patches for High Poly Project.

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
  * Fixed both secret cabinets which were not proerly aligned with the wall, allowing you to see a rather large gap between the wall and cabinet
  * Added in the missing ceiling tile in the Armoury
  * Aligned the paintings behind the Mage's Study workstations with the wall
* MANY maintainence changes for the repo
* Added Interesting Inhabitants as a testing module
  * Includes most of the features that will be present in the final release
  * Should be entirely stable and cause no harm to your saved game
    * I take no responsibility for damages to your save caused by using a testing plugin.
* Restructured `dist\translations\` folder to apply some of my new-found knowledge on the FOMOD installer
