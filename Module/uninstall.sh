#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"

ui_print() {
  echo "$1"
}

backup () {
if [ -f "$BACKUP_FILE" ]; then
  rm -f "$TARGET_FILE"
  ui_print "- Removed Yuri Keybox."
  mv "$BACKUP_FILE" "$TARGET_FILE"
  ui_print "- Restored previous keybox."
else
  ui_print "- No backup found to restore."
fi
}

ui_print "- Uninstalling Yuri keybox..."


if [ -f "$TARGET_FILE" ]; then
  if grep -q "yuriiroot" "$TARGET_FILE"; then
    ui_print "- Existing Yuri Keybox found."
    backup
    ui_print "- Uninstall complete."
  else
    ui_print "- Existing keybox not by Yuri."
    ui_print "- Nothing Done."
  fi
fi