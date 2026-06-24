#!/bin/bash

# This script removes link to MARCXML file in global directory

processId=$1
signatur=$2

# make sure all necessary files and folders exist
KITODO_DIR=/usr/local/kitodo
PROCESSES_DIR="$KITODO_DIR/metadata"
PROCESS_DIR="$PROCESSES_DIR/$processId"
METADATA_FILE="$PROCESS_DIR/meta.xml"
MARCXML_LINKS_DIR="/wlb/crowdsourcing/marcxml"
MARCXML_FOLDER="$PROCESS_DIR/marcxml"
MARC_XML_FILENAME="${signatur}_marc.xml"
MARC_XML_FILE="$MARCXML_FOLDER/${MARC_XML_FILENAME}"
MARC_XML_LINK="${MARCXML_LINKS_DIR}/${MARC_XML_FILENAME}"

if [ ! -e $KITODO_DIR ]
then
	echo "ERROR: Kitodo core directory $KITODO_DIR does not exist!"
	exit 1
fi

if [ ! -e $PROCESSES_DIR ]
then
	echo "ERROR: Kitodo metadata directory $PROCESSES_DIR does not exist!"
	exit 1
fi

if [ ! -e "$PROCESS_DIR" ]
then
	echo "ERROR: Process directory $PROCESS_DIR does not exist!"
	exit 1
fi

if [ ! -e $MARCXML_LINKS_DIR ]
then
	echo "ERROR: Marc XML Links directory $MARCXML_LINKS_DIR does not exist!"
	exit 1
fi


if [ ! -e "$MARCXML_FOLDER" ]
then
	echo "ERROR: Marc XML directory $MARCXML_FOLDER does not exist!"
	exit 1
fi

# verify Marc XML file was created successfully and is not empty
if [ ! -e "$MARC_XML_FILE" ]
then
	echo "ERROR: Marc XML file $MARC_XML_FILE does not exist!"
	exit 1
fi

# no action if link not found
if [ ! -e "$MARC_XML_LINK" ]
then
    exit 0
fi

# remove link
if [ ! -L "$MARC_XML_LINK" ]
then
    echo "ERROR: Could not delete link (not a link): $MARC_XML_LINK !"
	exit 1
fi

rm "$MARC_XML_LINK"

if [ $? -ne 0 ]
then
	echo "ERROR: Deleting link failed $MARC_XML_LINK !"
	exit 1
fi


exit 0
