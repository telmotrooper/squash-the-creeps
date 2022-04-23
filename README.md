# <img src="icon.png" width="40px" height="40px"/> Squash the Creeps 

**Squash the Creeps** is a freeware game developed in the [Godot Engine](https://godotengine.org/) where you control a squid-like creature and squash incoming enemies.

It is based in the isometric 3D game of the same name implemented in the tutorial [Create Your First Complete 3D Game with Godot](https://youtu.be/YiE9tcoCfhE) by [GDQuest](https://www.gdquest.com/).

## Download

You can **[download here](https://github.com/telmotrooper/squash-the-creeps/releases/latest)** the latest version of the game for Windows, Linux and Mac, thanks to the wonderful [Godot Export](https://github.com/firebelley/godot-export) GitHub Action.

## Screenshots

<img src="screenshot.png" width="75%" height="75%" />

## FAQ

#### **Where are the settings stored?**

* Windows: `%APPDATA%/Godot/app_userdata/Squash the Creeps/settings.cfg`
* Linux: `~/.local/share/godot/app_userdata/Squash the Creeps/settings.cfg`
* Mac: `~/Library/Application Support/Godot/app_userdata/Squash the Creeps/settings.cfg`

#### **I'm getting error "Mixed tabs and spaces in indentation"**

If you get this error, go in the editor and click `Editor > Editor Settings... > General > Text Editor > Indent`, then change **Type** to `Spaces` and **Size** to `2`. Then close the project, reset the file changes with `git reset --hard` and reopen the project. You should now be able to edit the files without running into the error.

#### **(MacOS) "Squash the Creeps.app" is damaged and can't be opened**

The application is't signed, so you'll have to run to disable the checks running the following command `xattr -cr "Squash the Creeps.app"` in the folder where the game is.
