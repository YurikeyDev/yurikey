#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/conf"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
TMP_REMOTE="$TRICKY_DIR/remote_keybox.tmp"
SCRIPT_REMOTE="$TRICKY_DIR/remote_script.sh"
DEPENDENCY_MODULE="/data/adb/modules/tricky_store"

ui_print ""
ui_print "*********************************"
ui_print "*****Yuri Keybox Installer*******"
ui_print "*********************************"
ui_print ""

# Check for dependency: Tricky Store module
if [ ! -d "$DEPENDENCY_MODULE" ]; then
  ui_print "- Error: Tricky Store module not found!"
  ui_print "- Please install Tricky Store before using Yuri Keybox."
  exit 1
fi

fetch_remote_keybox() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" | base64 -d > "$SCRIPT_REMOTE"
    chmod +x "$SCRIPT_REMOTE"
    sh "$SCRIPT_REMOTE"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$REMOTE_URL" | base64 -d > "$SCRIPT_REMOTE"
    chmod +x "$SCRIPT_REMOTE"
    sh "$SCRIPT_REMOTE"
  else
    ui_print "- Error: curl or wget not available."
    ui_print "- Cannot fetch remote keybox."
    return 1
  fi
  return 0
}

update_keybox_if_needed() {
  ui_print "- Fetching remote keybox..."
  if ! fetch_remote_keybox; then
    return
  fi

  if [ -f "$TARGET_FILE" ]; then
    if cmp -s "$TARGET_FILE" "$TMP_REMOTE"; then
      ui_print "- Keybox is already up to date. No changes made."
      rm -f "$TMP_REMOTE"
      return
    else
      ui_print "- Keybox differs from remote. Backing up old keybox..."
      mv "$TARGET_FILE" "$BACKUP_FILE"
    fi
  else
    ui_print "- No existing keybox found. Will create a new one."
  fi

  mv "$TMP_REMOTE" "$TARGET_FILE"
  ui_print "- keybox.xml successfully updated."
}

# Start logic
ui_print "- Preparing Yuri Keybox..."
mkdir -p "$TRICKY_DIR"
update_keybox_if_needed

sleep 2
am start -a android.intent.action.VIEW -d tg://resolve?domain=yuriiroot >/dev/null 2>&1