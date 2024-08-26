#!/usr/bin/env bash

# This script is used to build the game for Linux, Windows and Mac.
# Usage:
# ./build.sh
# ./build.sh <version>

GAME_NAME=squash-the-creeps
EXPORT_PATH=~/Desktop
TIME_STAMP=$(date -u +"%Y%m%d-%H%M%S")

if [ -n "$1" ]; then
    TIME_STAMP=v$1
fi

FILE_NAME="$GAME_NAME"_"$TIME_STAMP"

EXPORT_LINUX_NAME=$FILE_NAME"_linux"
EXPORT_WINDOWS_NAME=$FILE_NAME"_windows"
MAC_NAME=$FILE_NAME"_mac"

LINUX_FILE_EXTENSION="x86_64"
WINDOWS_FILE_EXTENSION="exe"
MAC_FILE_EXTENSION="zip"

godot --headless --export-release "Linux" $EXPORT_PATH/$FILE_NAME.$LINUX_FILE_EXTENSION
godot --headless --export-release "Windows Desktop" $EXPORT_PATH/$FILE_NAME.$WINDOWS_FILE_EXTENSION
godot --headless --export-release "macOS" $EXPORT_PATH/$MAC_NAME.$MAC_FILE_EXTENSION

7z a $EXPORT_PATH/$EXPORT_LINUX_NAME.7z $EXPORT_PATH/$FILE_NAME.$LINUX_FILE_EXTENSION
7z a $EXPORT_PATH/$EXPORT_WINDOWS_NAME.7z $EXPORT_PATH/$FILE_NAME.$WINDOWS_FILE_EXTENSION $EXPORT_PATH/$FILE_NAME.pck
