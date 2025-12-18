#!/system/bin/sh
# delete_twrp_folder.sh
# Script to delete TWRP folder from Android internal storage

echo "Starting deletion of TWRP folder..."

# Define the TWRP folder path (adjust if needed)
TWRP_FOLDER="/sdcard/TWRP"

if [ -d "$TWRP_FOLDER" ]; then
  echo "- Found folder $TWRP_FOLDER. Deleting..."
  rm -rf "$TWRP_FOLDER"
  echo "Folder deleted successfully."
else
  echo "- Folder $TWRP_FOLDER not found. Nothing to delete."
fi

echo "TWRP folder deletion script completed."