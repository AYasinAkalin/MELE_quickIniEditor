# MELE Quick Ini Editor - Introduction
This small terminal application allows users and modders to apply certain changes to
Mass Effect 1: Legendary Edition's configuration files without replacing the whole file; losing possible early modifications in process.

Currently editable files are all `.ini` files inside `Coalesced_INT.bin`, `BIOEngine.ini` and `BIOGame.ini`.

### To Modders
Modders only need to provide users `.txt` files inside `MOD` folder as filled. Modders can also just share their changes in syntax provided below.

Your addition to `.txt` files will be reflected on the game's `.ini` files.

### Build the source code (for developers)
Use py2exe and provided `setup.py`.

```python setup.py py2exe```

### Run the program (for users)
Download the latest release, extract the `.zip` file, run `quickIniEditor.exe`.

You also need to fill `.txt` files inside `MOD` folder or replace the `.txt` file provided by your mod. Read below to learn more. 

This program won't change change your files unless you make changes to `.txt` files since they are shipped empty.

## Quick look at INI Files
`.ini` files consist of __sections__ and key-value pairs under each __section__. A key in a `.ini` file is called an __option__. An __option__ must have a value attached to it with `=`.

## Syntax

You only need to put lines using one of these syntax. Each line you are going to put is called a __modification line__. Syntax of a __modification line__ is below:

1) Syntax for replacing an existing __option__
```
vanillaString;;modificationString
```
2) Syntax for adding a new __option__
```
;;modificationString@[sectionName]
```
### vanillaString
`vanillaString` is one of the original line you are aiming to modify that is found on Mass Effect Legendary Edition's respective game's `.ini` file. 

This line `DefaultGame=SFXGame.BioSPGame` from `Mass Effect Legendary Edition\Game\ME1\BioGame\Config\BIOGame.ini` is an example to a `vanillaString`.

You should put `vanillaString`s as is.

### Delimiter (;;)
`;;` is delimiter between `vanillaString` and `modificationString`. Don't put spaces between the delimiter and `vanillaString` and `modificationString`.

### modificationString
Modified state of `vanillaString`. This includes your modification. Use the same __option__ name in the `vanillaString`.

This line `DefaultGame=Asimov` is a `modifiedString` example. __Option__ is still `DefaultGame`, but I changed its value to `Asimov` from `SFXGame.BioSPGame`.

### New Addition Operator (@)
`@` tells the program that a new __option__ that wasn't present is to be added.

If you use addition operator leave `vanillaString` part empty and always include a `sectionName` with brackets after the operator.

### sectionName
`sectionName` is a name of a section in an `.ini` file. It tells the program where you want your new __option__ to be put.

## Examples 
### Example 1
Consider the following modification line in  `ModsToBIOGame.txt`
```
DefaultGame=SFXGame.BioSPGame;;DefaultGame=Asimov
```

When the program runs, `DefaultGame=SFXGame.BioSPGame` inside `BIOGame.ini` will be replaced by `DefaultGame=Asimov`.

### Example 2
Consider the following modification lines in `ModsToBioEngine.txt`
```
GameName=Mass Effect;;GameName=Mass Effect 655
bEnableSpam=False;;bEnableSpam=True
;;NewOption=False@[URL]
;;NewOption=False@[A.New.Section]
;;NewOption=False@[A.New.Section]
;;Number=9995.12@[B.New.Section]
```
When the program runs, `BIOGame.ini` will include these changes:
- `GameName=Mass Effect` replaced by `GameName=Mass Effect 655`
- `bEnableSpam=False` replaced by `bEnableSpam=True`
- This new __option__ `NewOption=False` under `[URL]`
- A new section called `[A.New.Section]` with `NewOption=False` line under it.
- Another new section called `[B.New.Section]` with `Number=9995.12` line under it.

#### Takeaways from Example 2
1) There could be identical __options__ under different sections. 

This is why `NewOption=False` is added under `[A.New.Section]` even though the exact same __option__ with the same value was placed under `[URL]` section.

2) There could be only one __option__ with the same value under one section. 

For this reason second inquiry to insert `NewOption=False` under `[A.New.Section]` will be rejected by the program.

## File correspondence

| `.txt` File                        | `.ini` File                                  | `.ini` File's Location                             |
|------------------------------------|----------------------------------------------|----------------------------------------------------|
| ModsToBIOEngine.txt                | BIOEngine.ini                                | Game\ME1\BioGame\Config                            |
| ModsToBIOGame.txt                  | BIOGame.ini                                  | Game\ME1\BioGame\Config                            |
| ModsToCoaBIOCompat.txt             | -_-_BIOGame_Config_BIOCompat.ini             | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOCredits.txt            | -_-_BIOGame_Config_BIOCredits.ini            | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOEditor.txt             | -_-_BIOGame_BIOEditor.txt                    | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOEditorKeyBindings.txt  | -_-_BIOGame_Config_BIOEditorKeyBindings.ini  | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOEditorUserSettings.txt | -_-_BIOGame_Config_BIOEditorUserSettings.ini | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOEngine.txt             | -_-_BIOGame_Config_BIOEngine.ini             | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOGame.txt               | -_-_BIOGame_Config_BIOGame.ini               | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOLightmass.txt          | -_-_BIOGame_Config_BIOLightmass.ini          | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOInput.txt              | -_-_BIOGame_Config_BIOInput.ini              | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOParty.txt              | -_-_BIOGame_Config_BIOParty.ini              | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOQA.txt                 | -_-_BIOGame_Config_BIOQA.ini                 | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOStringTypeMap.txt      | -_-_BIOGame_Config_BIOStringTypeMap.ini      | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOUI.txt                 | -_-_BIOGame_Config_BIOUI.ini                 | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
| ModsToCoaBIOWeapon.txt             | -_-_BIOGame_Config_BIOWeapon.ini             | Game\ME1\BioGame\CookedPCConsole\Coalesced_INT.bin |
