#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

# This controls (in seconds) when to switch to the next image
INTERVAL=300
MONITOR="DP-1"
HYPRPAPER_CONFIG="$CONFIG_HOME/hypr/hyprpaper.conf"

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
	echo "Usage:
	$0 <dir containing images> <flags>"
	exit 1
fi

IMG_DIR=$1

while getopts "imc:" flag; do
	case $flag in
	i)
		INTERVAL=$OPTARG
		;;
	m)
		MONITOR=$OPTARG
		;;
	c)
		HYPRPAPER_CONFIG=$OPTARG
		;;
	esac
done

while true; do
	find "$IMG_DIR" |
		while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done |
		sort -n | cut -d':' -f2- |
		while read -r img; do
			hyprctl hyprpaper preload $img
			hyprctl hyprpaper wallpaper "$MONITOR,$img"
			echo "Changin wallpaper to $img"
			sleep $INTERVAL
		done
done
