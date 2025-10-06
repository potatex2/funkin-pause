# Haxe Wallpaper for Lively Wallpaper
Oh, hey. You found another one of my hyperfixations lurking in the Internet. Well done.

Now, what *exactly* does this one have in store for us?

## Current Features - init:

* Backdrop to prevent screen burn, I guess?
* Current **local** time indicator, decent if you have your taskbar auto-hidden
* Camera instance for bopping on beat
* Metadata file for if custom background music will be added, with proper BPM bops *with some inconsistencies for now*
* goober bopping as well, i live in your walls teehee
* Currently, two buttons to allow for opening desktop file directory and a quick shutdown of your system. *I can do much more than that. >:3* **(DISCLAIMER, NO UNETHICAL OR ILLEGAL PRACTICES WILL BE DONE TO YOUR PC IN THIS PROJECT.)**
* More to come when my hyperfixation continues.

## Overview
**Please note:** I'm too damn broke to get Wallpaper Engine, HOWEVER Lively Wallpaper works very similar to that software, so this will be the focus for this repo.

This repo contains Haxe files for an interactive wallpaper that is currently based on a customized Psych Engine (RIP 03/31/2025) pause substate*

<sup>*PauseSubState.hx based off of [version 0.7.3](https://github.com/ShadowMario/FNF-PsychEngine/releases/tag/0.7.3)</sup>

To prevent interactivity issues, keyboard inputs are not allowed or set as defined in Project.xml. You can enable them by commenting out `<haxedef name="FLX_NO_KEYBOARD" />`, but **make sure your desktop icons are set to hidden**.

## How do I apply it? - Setup
In order to use this wallpaper, you're obviously going to need [the software](https://www.rocksdanister.com/lively) itself. **It is important that you use the INSTALLER VERSION instead of the Microsoft Store version, as there are compatibility differences present between each of them.**

Once installed, go to settings and make sure that this:
<img width="850" height="664" alt="temp1" src="https://github.com/user-attachments/assets/5d7e9be9-7765-45cd-8cca-d564590603db" />

is set to Direct3D (assuming your PC supports it). You can also keep it to **Foreground process** if you don't want it to persistently play over your friends yapping in Discord. :P

Then go to the Wallpaper tab and ensure that this is set to "Mouse".
<img width="847" height="236" alt="temp2" src="https://github.com/user-attachments/assets/8c963dec-bd23-4875-b8f1-0da6d01c668a" />

As mentioned above, keyboard input is available, but for the purpose of this template, *we're not using them*.

**Optional:** Go to Screensaver and follow the setup instructions on the Windows Settings section if you want to use this as a screensaver instead (it's really cool trust me :D ).

You can run any sort of file or other application that handles its own independent window, but I'm not the app creator, so [check out the repo yourself.](https://github.com/rocksdanister/lively)

## How do I make it? - Compilation
Since this project is comprised fully from Haxe, you'll need the haxelibs associated with the project itself. But to get THOSE, you'll need the installer and version control software, as well as Haxe itself.

**From BUILDING.md in Psych Engine 0.7.3:**

---
### Windows & Mac

For `git`, you're likely gonna want [git-scm](https://git-scm.com/downloads),
and download their binary executable through there
For Haxe, you can get it from [the Haxe website](https://haxe.org/download/)

**(Next step is Windows only, Mac users may skip this)**

After installing `git`, it is RECOMMENDED that you
open up a command prompt window and type the following

```
curl -# -O https://download.visualstudio.microsoft.com/download/pr/3105fcfe-e771-41d6-9a1c-fc971e7d03a7/8eb13958dc429a6e6f7e0d6704d43a55f18d02a253608351b6bf6723ffdaf24e/vs_Community.exe
vs_Community.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 -p
```
this will use `curl`, which is a tool for downloading certain files through the command-line,
to Download the binary for Microsoft Visual Studio with the specific package you need for compiling on Windows.

for Building the [app], in pretty much EVERY system, you're going to want to execute `haxelib setup`

---

For the libraries you need to run this, run `haxelib install <library>` with the listed versions below for the following:

<img width="151" height="178" alt="image" src="https://github.com/user-attachments/assets/ac16b22a-172c-482c-9afe-9b761c399d26" />

### Important: For the purpose of this project, flixel 5.8.0 has been modified for compatibility, and the version folder in libs/ MUST be added to `C:\Users\<user>\lime`. Ensure the version is confirmed with `haxelib set flixel 5.8.0`.

#### Now you might be tired of all the hassle yuo had setting all this up, so *how do you see if it works?*

In the root directory in the terminal, run `lime [test | build] windows` and wait a couple minutes for everything to build, depending on how good your hardware is. If you ran `test`, the window *should* open with no errors, and there's your wallpaper! _Well, MY wallpaper since you probably went to test this first..._

# Compile-time errors can be easily resolved. Please report any runtime errors in the Issues tab of this repo.

---
**\~ PotateX2**
Edited on 10/06/2025, 12:20 am.