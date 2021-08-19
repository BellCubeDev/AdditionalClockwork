# Extracting
For extraction, I tried to make things as space-efficient and user-friendly as possible.
That being said, it may be somewhat difficult to extract this mod manually because of how I
chose to efficiently organize the modules.

If you're looking for mod-caused bug fixes, integration, or consistency patches, look no further than the `Modules\IntegrationPatchesNConsistency` folder! This folder houses everything from sorting patches to simple bug fixes.

If you're looking for modules, look in the `Modules\Normal` (Modules that only need Clockwork) and `Modules\SKSE` (Take a wild guess at what else these modules need) folders. Here, you can find the parts of Clockwork Additions that don't directly relate with other mods. For instance, Extra Sorting (you have been teased), Courier Counterspell, and Shadowmarks. Modules that have translation files in the `translations` folder will have a `Description.txt` file in them telling you as much. 


-----

## The following is a non-exhaustive, simplified way to look at a FOMOD installer

When extracting modules, look for one in the FOMOD. Under the fomod folder, you can view ModuleConfig.xml (a plain text file). Within this file is everything needed for a FOMOD. Try looking for a line that looks like this:
```
<group name="Woodworker's Whim" type="SelectAny"> 
```
These lines are the Group lines. They tell you what module options you have. Next, look for lines like this:

```
<plugin name="PLUGIN NAME"> 
	<description>DESCRIPTION HERE</description> 
```
In this line you can see two things: The name of the module config (under "plugin name") and the description for it.
One thing to bear in mind: `&#13;&#10;` is a line ending/line break.