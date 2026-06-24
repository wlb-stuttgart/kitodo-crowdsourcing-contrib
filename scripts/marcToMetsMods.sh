#!/bin/bash
set -euo pipefail

processId=$1
processTitle=$2
signatur=$3

kitodoDirectory=/usr/local/kitodo
exportDirectory=$kitodoDirectory/hotfolder-crowdsourcing
metadataDirectory=$kitodoDirectory/metadata
processDirectory=$metadataDirectory/$processId
marcDirectory=$processDirectory/marcxml
internalMetadataFile="$processDirectory/meta.xml"
marc2modsMappingFile=$kitodoDirectory/xslt/marc21slim2modsKitodo.xsl
saxonFile=/usr/share/java/Saxon-HE.jar

# 1. Locate exported METS file, created by regular export mapping
processExportDir=$exportDirectory/$processTitle

if [ ! -e "$processExportDir" ]
then
  echo "ERROR: Process export directory '$processExportDir' does not exist!"
  exit 1
fi

processExportFile="$processExportDir"/"$processTitle".xml

if [ ! -f "$processExportFile" ]
then
  echo "ERROR: Process export file '$processExportFile' is not a file!"
  exit 1
fi

# 2. Locate MARCXML file, created for K10+ export

if [ ! -e "$marcDirectory" ]
then
  echo "ERROR: process marc directory '$marcDirectory' does not exist!"
  exit 1
fi

marcxmlFile="$marcDirectory/${signatur}_marc.xml"

if [ ! -e "$marcxmlFile" ]
then
  echo "ERROR: process Marc XML file '$marcxmlFile' does not exist!"
  exit 1
fi

if [ ! -e "$internalMetadataFile" ]
then
  echo "ERROR: internal metadata file file '$internalMetadataFile' does not exist!"
  exit 1
fi

# 2.a Alternatively, re-create MARCXML file (because internal meta.xml may contain new data re-imported from K10+)

# 3. Locate Marc-to-Mods transformation file from Library of Congress
if [ ! -e $marc2modsMappingFile ]
then
  echo "ERROR: Marc to Mods mapping file '$marc2modsMappingFile' does not exist!"
  exit 1
fi

# 4. Locate Saxon.jar
if [ ! -e $saxonFile ]
then
  echo "ERROR: Saxon module '$saxonFile' does not exist!"
  exit 1
fi

# 5. Transform MARCXML file to MODS using Marc-to-Mods mapping from Library of Congress
modsExportFilename="$processExportDir"/"$processTitle"mods.xml
java -jar $saxonFile -xsl:$marc2modsMappingFile -s:"$marcxmlFile" -o:"$modsExportFilename"

# verify MODS file was created successfully and is not empty
if [ ! -s "$modsExportFilename" ]
then
  echo "ERROR: MODS file '$modsExportFilename' was not created successfully!"
  exit 1
fi

# 6. Replace METADATA placeholder in <mets:xmlData> with MODS content created in step 5
awk -v ef="$modsExportFilename" '
BEGIN {
  while ((getline line < ef) > 0) {
    r = r (r ? ORS : "") line
  }
  close(cf0)
}
{
  gsub(/METADATAPLACEHOLDER/,r)
}
1
' "$processExportFile" > "${processExportFile}.tmp"

if [ $? -ne 0 ]
then
  echo "ERROR: Replace METADATA placeholder in file '$processExportFile' failed!"
  exit 1
fi

mv "${processExportFile}.tmp" "$processExportFile"
if [ $? -ne 0 ]
then
  echo "ERROR: Moving temporary file to '$processExportFile' failed!"
  exit 1
fi

# Clean up
#rm "$modsExportFilename"

exit 0
