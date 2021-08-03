# Additional Clockwork

A repo hosting Additional Clockwork's FOMOD, including the in-progress one.

## Structure
`dist\` - The folder containing the FOMOD itself.

# Nexus Description

Additional Clockwork is a _**MODULAR**_ suite of ESL-flagged ESP addons developed by BellCube Dev for the mod [Clockwork](https://www.nexusmods.com/skyrimspecialedition/mods/4155) by Antistar.
Unless otherwise specified, all modules can be imported mid-game.

**Want to track my development progress?**
[I have an article all about that](https://www.nexusmods.com/skyrimspecialedition/articles/3214)!

**Have an idea?**
[Suggest it here](https://www.nexusmods.com/skyrimspecialedition/mods/47087/?tab=forum&topic_id=10280988)!

## Modules

### **Courier Counterspell**

\(banner coming soon, I hope to make a gigantic jab at [this MTG card](https://gatherer.wizards.com/pages/card/Details.aspx?multiverseid=2148)\)

Uses a script to disable World Interaction events (aka Random Encounters) when at Clockwork Castle, which primarily **_fixes the courier issue_**. No more monomaniacal correspondence-wizard. Rain or shine, GET OFF MY LAWN!
For an in-depth technical look, see [the dedicated article](https://www.nexusmods.com/skyrimspecialedition/articles/3232).

![Marked Shadows](https://raw.githubusercontent.com/BellCubeDev/bellcubedev.github.io/live/Assets/Nexus/Images/ShadowmarksBanner.png)

Made of three modules, which each add "Guild" (Member) shadowmarks to these locations:

* The Castle's front door
* The Travel Room's door to the Main Hall
* Each of the Terminus locations (two in Riften, one everywhere else)

![Woodworker's Whim](https://raw.githubusercontent.com/BellCubeDev/bellcubedev.github.io/live/Assets/Nexus/Images/WoodworkersWhim.png)

Adds two things: An Axe Mount to the Work Room and a script that searches for dropped/mounted axes nearby for you to chop wood with.

Really made up of three modules:

* The script enabled **globally (does _NOT_ require Clockwork)**
* The script enabled **ONLY in the Work Room** (**_redundant_** if the Global module is enabled)
* An Axe mount for the Work Room

## **Minor Tweaks & Changes**

Now with even less impact on gameplay!

* ### **Mausoleum Dummy Dor Fix**
    When leaving Nurndural for the first time, there is a scene that plays with Lamashtu and Shadow. While the scene plays out, you are prevented from leaving by a fake door. However, this fake door, when disappears, is EXTREMELY NOTICEABLE if you look at the door. Of course, I had to fix this. My efficient brethren, you can rest easy now. (So long as you're not fixing the pipes right now, you should be fine for a mid-game install)
* ### **Clockwork Title Remover**
    Removes the giant floating Clockwork title that appears when you first enter the Castle's valley **([idea](https://forums.nexusmods.com/index.php?showtopic=10280988/#entry97162223) by [Foamimi](https://forums.nexusmods.com/index.php?/user/42417205-foamimi/))**.

## **Integration, Patches, and Consistency**

You know. Standard patches etc.

### **High Poly Project**

* #### **Coals Fix:**
Uses High Poly Project's mesh for the coals instead of the vanilla mesh. (needs new game) (See project images)
* #### **Hay Fix:**
Fixes the hay [z-fighting](https://en.wikipedia.org/w/index.php?title=Z-fighting&oldid=1031681976#:~:text=z-fighting%2C%20also%20called%20stitching%20or%20planefighting%2C%20is%20a%20phenomenon%20in%203d%20rendering%20that%20occurs%20when%20two%20or%20more%20primitives%20have%20very%20similar%20distances%20to%20the%20camera.&text=this%20then%20means%20that%20when%20a%20specific%20pixel%20is%20being%20rendered%2C%20it%20is%20nearly%20random%20which%20one%20of%20the%20two%20primitives%20are%20drawn%20in%20that%20pixel) that appears all throughout Clockwork Castle when using HPP's mesh (needs new game)
(Thankfully, Skyrim's rendering engine doesn't throw hissy fits when there's z-fighting and just picks one and goes with it Thus, this is more of a small aesthetic change than a must-have like the Coals Fix)

## **Sorting**
Honestly one of my biggest reasons for creating this project.

* ### **[Complete Alchemy and Cooking Overhaul](https://www.nexusmods.com/skyrimspecialedition/mods/19924)** (**Food**, **Ingredients**)
* ### **[Rare Curios](https://en.uesp.net/wiki/Skyrim:Rare_Curios)** (**Ingredients**)

## **Additional Recommendations**

Other mods I recommend playing Clockwork with. (#NOTSpon)

* [Book Covers Skyrim](https://www.nexusmods.com/skyrimspecialedition/mods/901)
* [Embers HD](https://www.nexusmods.com/skyrimspecialedition/mods/14368)
* [Essentials Ragdoll on Knockdown](https://www.nexusmods.com/skyrimspecialedition/mods/24974) (for when you accidentally kill Lamashtu)
* [Immersive Autosaves](https://www.nexusmods.com/skyrimspecialedition/mods/34567)
* [Realistic Ragdolls and Force](https://www.nexusmods.com/skyrimspecialedition/mods/1439)
* [Reverb and Ambience Overhaul](https://www.nexusmods.com/skyrimspecialedition/mods/701)
* [Rustic Soulgems](https://www.nexusmods.com/skyrimspecialedition/mods/5785)

## **Credits**

### **[Antistar:](https://www.nexusmods.com/skyrimspecialedition/users/60908)**

* [Still replying within a day of comments](https://forums.nexusmods.com/index.php?showtopic=5060895&p=91927523) on their ancient mod project (Logitech G for the win!)
* Providing development support, ideas, and overall being a great person on the internet.
* Assets from Clockwork (used in Lahar's Labor).

#### Assets

* [Wallpaper](https://www.nexusmods.com/skyrimspecialedition/mods/4155#:~:text=a%20number%20of%20miscellaneous%20works%20like%20wallpaper%20patterns&text=to%20the%20best%20of%20my%20knowledge%20have%20all%20been%20in%20the%20public%20domain%20for%20a%20long%20time%20also.)

### **[LucidAPs](https://www.nexusmods.com/skyrimspecialedition/users/3180451)**

* Allowing me to extract the coals fix mesh from High Poly Project's smelter mesh. Stunning work!
