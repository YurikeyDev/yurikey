#!/system/bin/sh

echo "Starting fix for Hide My Applist (HMA)..."
echo "Searching for suspicious folders..."

FOLDERS=$(find /data/system -maxdepth 1 -type d \( -iname "*hide*" -o -iname "*hma*" -o -iname "*applist*" \) 2>/dev/null)

if [ -z "$FOLDERS" ]; then
  echo "No HideMyApplist-related folder found. Nothing to delete."
else
  for FOLDER in $FOLDERS; do
    echo "Deleting folder: $FOLDER ..."
    rm -rf "$FOLDER"
    echo "Folder deleted: $FOLDER"
  done
fi

echo "Hide My Applist (HMA) fix completed."