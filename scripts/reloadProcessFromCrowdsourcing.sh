#!/bin/sh

# This script is called periodically via a cronjob to check for processes returned from the crowdsourcing tool.
# If any such processes are found, their updated metadata file is copied back into the corresponding kitodo process
# directory and the corresponding workflow step "Aktualisierung der Metadaten" is closed via ActiveMQ.

KITODO_DIR=/usr/local/kitodo
CROWDSOURCING_DIR=/wlb/crowdsourcing/austausch
CROWDSOURCING_EXPORT_DIR="$CROWDSOURCING_DIR"/processes/export

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ################"

if [ ! -d "$KITODO_DIR" ];
then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Kitodo directory '$KITODO_DIR' not found!"
  exit 1
fi

if [ ! -d "$CROWDSOURCING_EXPORT_DIR" ];
then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Crowdsourcing directory '$CROWDSOURCING_EXPORT_DIR' not found!"
  exit 1
fi

if [ -z "$( ls -A "$CROWDSOURCING_EXPORT_DIR" )" ];
then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Crowdsourcing export directory '$CROWDSOURCING_EXPORT_DIR' is empty, nothing to do."
  exit 0
fi

META_XML="meta.xml"
METADATA_DIR="$KITODO_DIR"/metadata
ACTIVE_MQ_CLIENT="$KITODO_DIR"/scripts/crowdsourcing/kitodo-activemq-client-0.3-jar-with-dependencies.jar

for dir in "$CROWDSOURCING_EXPORT_DIR"/*; do
  if ! [ -L "$dir" ];
  then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: '$dir' is not a link!"
    continue
  fi

  if ! [ -d "$dir" ];
  then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: '$dir' does not point to directory!"
    continue
  fi

  src_file="$dir/$META_XML"
  if [ ! -f "$src_file" ];
  then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: '$src_file' is not a file!"
    continue
  fi

  folder_name=$(basename "$dir")
  target_dir="$METADATA_DIR/$folder_name"
  taskIdFile="$target_dir/reimportTaskId"

  if [ ! -f "$taskIdFile" ];
  then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: '$taskIdFile' containing ID of re-import task to close does not exist"
    continue
  fi

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] checking for ID of 're-import from crowdsourcing' task"
  if [ ! -s "$taskIdFile" ];
  then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: '$taskIdFile' containing ID of re-import task to close is empty"
    continue
  fi
  currentTaskId=$(cat "$taskIdFile")

  cp "$src_file" "$target_dir/"
  if cp "$src_file" "$target_dir/";
  then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] meta.xml file copied from '$dir' to '$target_dir'"
    # delete link to source folder from crowdsourcing dir to mark successful metadata update
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] removing symbolic link '$dir'"
    rm "${dir%/}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] symbolic link '$dir' removed"
    #  - close current task of process with ID equaling "dir" via ActiveMQ
    java -jar $ACTIVE_MQ_CLIENT tcp://localhost:61616?closeAsync=false "FinalizeTaskQueue" "$currentTaskId" "Metadaten vom Crowdsourcing-Tool re-importiert"
    # TODO:
    #  - (optional) update metadata via KitodoScript
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Successfully reloaded metadata for process '$dir' from crowdsourcing tool"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: Unable to copy updated file '$src_file' to '$target_dir'!"
  fi
done

exit 0
