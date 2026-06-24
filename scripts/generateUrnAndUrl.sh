#!/bin/bash

# This script creates URN and URL metadata for a process.

processId=$1
taskId=$2
signaturePrefix=$3	# e.g. "PSLH"
signaturePostfix=$4	# e.g. "001692"

numberOfArguments="$#"

# NOTE: this is a workaround since Kitodo incorrectly treats signatures like "PSLH 001692" as two separate parameters "PSLH" and "001692", therefore we need 4 instead of 3 parameters for process-ID, task-ID and signature here!
if [ $numberOfArguments -ne 4 ];
then
  echo "Wrong number of arguments! Expected 4 parameters, got $numberOfArguments parameters. Usage: $0 <process-ID> <task-ID> <signature-prefix> <signature-postix>"
  exit 1
fi

KITODO_DIR=/usr/local/kitodo

signature="$signaturePrefix $signaturePostfix"
METADATA_DIR="$KITODO_DIR"/metadata
processDir="$METADATA_DIR"/"$processId"

echo "Creating URN and URL for process with ID $processId"

# change all characters in signature to lowercase (bash)
signature=${signature,,}
# change all characters in signature to lowercase (sh)
#signature=$($signature | tr '[:upper:]' '[:lower:]')

# remove whitespace from signature (bash)
signature=$(echo "$signature" | tr -d '[:space:]')
# remove whitespace from signature (sh)
#signature=$($signature | tr -d ' ')

ACTIVE_MQ_CLIENT="$KITODO_DIR"/scripts/crowdsourcing/kitodo-activemq-client-0.3-jar-with-dependencies.jar

# verify that signature contains only alphanumeric characters
if [[ "$signature" =~ [^a-zA-Z0-9] ]];
then
  echo "ERROR: signature '$signature' contains non-alphanumeric characters!"
  # add correction comment to task via AcitveMQ about unallowed special characters in signature
  java -jar $ACTIVE_MQ_CLIENT tcp://localhost:61616?closeAsync=false "TaskActionQueue" "$taskId" "Signatur enthält unerlaubte Sonderzeichen" "ERROR_OPEN"
  exit 1
fi

urn="urn:nbn:de:bsz:24-digibib-$signature"
url="http://digital.wlb-stuttgart.de/purl/$signature"

# skip if process already contains the created URN
if grep -q "<kitodo:metadata name=\"2050\">$urn</kitodo:metadata>" "$processDir/meta.xml";
then
  echo "Process $processId already contains URN metadata '$urn', skip adding it again"
else
  # add URN metadata to process using ActiveMQ and KitodoScript
  echo "Adding URN '$urn' as metadata to process $processId"
  java -jar $ACTIVE_MQ_CLIENT tcp://localhost:61616?closeAsync=false "KitodoScriptQueue" "$taskId" "action:addData key:2050 \"value:$urn\"" "$processId"
  # wait until file has been updated
  seconds_passed=0
  until grep -q "<kitodo:metadata name=\"2050\">$urn</kitodo:metadata>" "$processDir/meta.xml"
  do
      echo "Waiting for URN metadata to be added to meta.xml file..."
      sleep "$(( seconds_passed ++ ))"
      if (( seconds_passed > 5 ))
      then
        echo "ERROR: unable to add URN '$urn' to process $processId after 5 seconds, aborting..."
        exit 1
      fi
  done
  echo "URN metadata found after $seconds_passed in process $processId"
fi


# skip if process already contains the created URL
if grep -q "<kitodo:metadata name=\"4950\">$url</kitodo:metadata>" "$processDir/meta.xml";
then
  echo "Process $processId already contains URL metadata '$url', skip adding it again"
else
  # add URL metadata to process using ActiveMQ and KitodoScript
  echo "Adding URL '$url' as metadata to process $processId"
  java -jar $ACTIVE_MQ_CLIENT tcp://localhost:61616?closeAsync=false "KitodoScriptQueue" "$taskId" "action:addData key:4950 \"value:$url\"" "$processId"
  # wait until file has been updated
  seconds_passed=0
  until grep -q "<kitodo:metadata name=\"4950\">$url</kitodo:metadata>" "$processDir/meta.xml"
  do
      echo "Waiting for URL metadata to be added to meta.xml file..."
      sleep "$(( seconds_passed ++ ))"
      if (( seconds_passed > 5 ))
      then
        echo "ERROR: unable to add URL '$url' to process $processId after 5 seconds, aborting..."
        exit 1
      fi
    done
    echo "URN metadata found after $seconds_passed in process $processId"
fi

exit 0

