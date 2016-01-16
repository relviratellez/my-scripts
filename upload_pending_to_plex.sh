#!/bin/bash
#
# Note: This script must be runned from crontab each ~1hour, we need to give time to the network
#       to upload all pending files, there may be a lot of content here...
#

PLEX_SERVER="192.168.79.4"
INSPECT_DIR="/Users/ret/Downloads/torrent/finished"
PLEX_SERVER_DESTINATION_DIR="/mnt/NAS/torrent/"


echo "-------------------------------------------------"
echo "- PLEX SERVER FILE UPLOADER (PENDING DOWNLOADS) -"
echo "-------------------------------------------------"
echo " "

if [ "$(ls -A $INSPECT_DIR)" ]
then
	FILECOUNT=$(ls -l $INSPECT_DIR | wc -l)
  	echo "Inspected folder contains: $FILECOUNT files"
  	
	if ping -c 1 $PLEX_SERVER &> /dev/null
	then
		echo "Plex server is UP and running!!"
		echo "Uploading pending files to Plex server"
		scp -r $INSPECT_DIR/* ret@$PLEX_SERVER:$PLEX_SERVER_DESTINATION_DIR
		if [ "$?" -eq "0" ];
		then
		    echo "Upload OK! Deleting pending files..."
		    #rm -rf $INSPECT_DIR/*
		else
		    echo "Upload FAILED, we're keeping the files for the moment"
		fi
		
	else
	  echo "Plex server is DOWN, we'll try later..."
	fi
else
  	echo "Inspected folder is empty, ignoring.."
fi




