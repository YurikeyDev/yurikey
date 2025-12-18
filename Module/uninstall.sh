#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
BBIN="/data/adb/Yurikey/bin"

ui_print() {
  echo "$1"
}

backup () {
if [ -f "$BACKUP_FILE" ]; then
  rm -f "$TARGET_FILE"
  mv "$BACKUP_FILE" "$TARGET_FILE"
fi
}

if [ -f "$TARGET_FILE" ]; then
  if grep -q "yuriiroot" "$TARGET_FILE"; then
    backup
  fi
fi

if [ -d "$BBIN" ]; then
  rm -rf $BBIN
fi
