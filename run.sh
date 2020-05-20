#!/usr/bin/env bash

# Contentful Bash Back-up - Teemu Tammela 2019-2020 (teemu.tammela@auralcandy.net)
# Distributed under GNU General Public License v3.0

# Print help message
function show_help {

  echo ""
  echo "Usage: ./run.sh [-t </PATH/TO/TARGET_DIR>] [-m <MANAGEMENT_TOKEN>] [-s <SPACE_ID>] [-e <ENVIRONMENT_ID>] [-f]"
  echo ""
  echo " -t    Path to Back-up Target Directory"
  echo " -m    Contentful Management Token"
  echo " -s    Contentful Space ID"
  echo " -e    Contentful Environment ID (optional, default 'master')"
  echo " -f    Download Asset Files (optional)"
  echo ""

}

# Read command line parameters
while getopts ":t:m:s:e:f" OPTION; do

  case ${OPTION} in

    # Back-up target directory path
    t) BACKUP_DIR=$OPTARG ;;

    # Contentful management token
    m) MANAGEMENT_TOKEN=$OPTARG ;;

    # Contentful space ID
    s) SPACE_ID=$OPTARG ;;

    # Contentful environment ID
    e) ENVIRONMENT=$OPTARG ;;

    # Download asset files
    f) DOWNLOAD_FILES="--download-assets" ;;

    # Help
    \?) show_help; exit 1 ;;

  esac

done

# Verify that required parameters are not empty
if [[ -z "$BACKUP_DIR" ||-z "$MANAGEMENT_TOKEN" || -z "$SPACE_ID" ]]; then
  show_help
  exit 1
fi

# Set 'master' as default environment if not defined
if [ -z "$ENVIRONMENT" ]; then
  ENVIRONMENT="master"
fi

# Verify that back-up directory exists and is writable
if [ -d "$BACKUP_DIR" ] && [ -w "$BACKUP_DIR" ]; then

  # Change location to back-up directory
  cd $BACKUP_DIR

  # Set timestamp and define file names
  DATE=$(date "+%Y-%m-%d_%H.%M.%S")
  MONTH=$(date "+%Y-%m")
  JSON_FILE="entries-$DATE.json"
  LOG_FILE="logs/$MONTH/export-$DATE.log"

  # Create directories for entries and logs
  mkdir -p "entries"
  mkdir -p "entries/$MONTH"
  mkdir -p "logs"
  mkdir -p "logs/$MONTH"

  # Get Contentful CLI executable path
  CONTENTFUL=`which contentful`

  # Export entries from Contentful
  $CONTENTFUL space export --management-Token $MANAGEMENT_TOKEN --space-id $SPACE_ID --environment-id $ENVIRONMENT --content-only --content-file $JSON_FILE $DOWNLOAD_FILES > $LOG_FILE

  # Ensure export JSON file exist
  if [ -f $JSON_FILE ]; then

    # Compress export JSON file into a ZIP package
    zip "entries/$MONTH/entries-$DATE.zip" $JSON_FILE >> $LOG_FILE

    # Delete export JSON file
    rm $JSON_FILE

  fi

# Back-up directory does not exist or is not writable
else

  echo "Directory $BACKUP_DIR does not exist or is not writable."
  exit 1

fi