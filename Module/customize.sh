#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/refs/heads/main/keybox.xml"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"

ui_print() {
  echo "$1"
}

override_keybox() {
  ui_print "Downloading and overriding keybox.xml..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" -o "$TARGET_FILE" && ui_print "keybox.xml successfully updated."
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$TARGET_FILE" "$REMOTE_URL" && ui_print "keybox.xml successfully updated."
  else
    ui_print "Error: curl or wget not available. Cannot fetch remote keybox."
  fi
}

# Start logic
ui_print "Checking if there is an existing keybox..."

mkdir -p "$TRICKY_DIR"

if [ -f "$TARGET_FILE" ]; then
  if grep -q "yuriiroot" "$TARGET_FILE"; then
    ui_print "Existing keybox was made by Yuri. Overriding it."
    override_keybox
  else
    ui_print "A keybox already exists but it wasn't made by yuriiroot."
    ui_print "Creating a backup and overriding with the new one..."
    mv "$TARGET_FILE" "$BACKUP_FILE"
    override_keybox
  fi
else
  ui_print "No keybox found. Creating a new one."
  touch "$TARGET_FILE"
  override_keybox
fi
