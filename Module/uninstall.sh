#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"

ui_print() {
  echo "$1"
}

ui_print "- Uninstalling Yuri keybox..."

# Remove the current keybox
if [ -f "$TARGET_FILE" ]; then
  rm -f "$TARGET_FILE"
  ui_print "- Removed keybox.xml"
else
  ui_print "- keybox.xml not found."
fi

ui_print "- Restoring the previous keybox..."
# Restore the backup
if [ -f "$BACKUP_FILE" ]; then
  mv "$BACKUP_FILE" "$TARGET_FILE"
  ui_print "- Restored previous keybox."
else
  ui_print "- No backup found to restore."
fi

ui_print "- Uninstall complete."
