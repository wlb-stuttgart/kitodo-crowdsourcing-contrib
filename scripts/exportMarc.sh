#!/bin/bash

# This script transforms the internal Kitodo metadata file to MARCXML for export to K10+

processId=$1
signatur=$2

# make sure all necessary files and folders exist
SAXON_JAR="/usr/share/java/Saxon-HE.jar"
KITODO_DIR=/usr/local/kitodo
XSLT_DIR="$KITODO_DIR/xslt"
KITODO_TO_MARCXML_MAPPING_FILE="$XSLT_DIR/kitodo2mark.xsl"
PROCESSES_DIR="$KITODO_DIR/metadata"
PROCESS_DIR="$PROCESSES_DIR/$processId"
METADATA_FILE="$PROCESS_DIR/meta.xml"

if [ ! -e $KITODO_DIR ]
then
	echo "ERROR: Kitodo core directory $KITODO_DIR does not exist!"
	exit 1
fi

if [ ! -e $XSLT_DIR ]
then
	echo "ERROR: XSLT mapping directory $XSLT_DIR does not exist!"
	exit 1
fi

if [ ! -e $KITODO_TO_MARCXML_MAPPING_FILE ]
then
	echo "ERROR: Kitodo to MARCXML mapping file $KITODO_TO_MARCXML_MAPPING_FILE does not exist!"
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

if [ ! -e "$METADATA_FILE" ]
then
	echo "ERROR: Process metadata file $METADATA_FILE does not exist!"
	exit 1
fi

if [ ! -e "$SAXON_JAR" ]
then
	echo "ERROR: Saxon JAR file $SAXON_JAR does not exist!"
	exit 1
fi

# create "marcxml" folder in process folder
MARCXML_FOLDER="$PROCESS_DIR/marcxml"
if [ ! -e "$MARCXML_FOLDER" ]
then
  mkdir "$MARCXML_FOLDER"
fi

# verify new directory was created successfully
if [ ! -e "$MARCXML_FOLDER" ]
then
	echo "ERROR: Marc XML directory $MARCXML_FOLDER was not created successfully!"
	exit 1
fi

MARC_XML_FILE="$MARCXML_FOLDER/${signatur}_marc.xml"

# use Saxon to transform meta.xml file in Kitodo internal format into Marc XML for K10+ export
java -jar $SAXON_JAR -xsl:$KITODO_TO_MARCXML_MAPPING_FILE -s:"$METADATA_FILE" -o:"$MARC_XML_FILE"

# verify Marc XML file was created successfully and is not empty
if [ ! -s "$MARC_XML_FILE" ]
then
	echo "ERROR: Marc XML file $MARC_XML_FILE was not created successfully!"
	exit 1
fi

exit 0
