#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/conf"
VERSION_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/version"
TMP_REMOTE="$TRICKY_DIR/remote_keybox.tmp"

ui_print() {
  echo "$1"
}

version() {
  ui_print "- Checking latest available keybox..."

  if command -v curl >/dev/null 2>&1; then
    VERSION=$(curl -fsSL "$VERSION_URL")
    ui_print "- $VERSION version available."
  elif command -v wget >/dev/null 2>&1; then
    VERSION=$(wget -qO- "$VERSION_URL")
    ui_print "- $VERSION version available."
  else
    VERSION=""
    ui_print "- Failed to fetch version info."
  fi
}

fetch_remote_keybox() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" | base64 -d > "$TMP_REMOTE"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$REMOTE_URL" | base64 -d > "$TMP_REMOTE"
  else
    ui_print "- Error: curl or wget not available."
    ui_print "- Cannot fetch remote keybox."
    return 1
  fi
  return 0
}

update_keybox_if_needed() {
  ui_print "- Checking for keybox update..."
  if ! fetch_remote_keybox; then
    return
  fi

  if [ -f "$TARGET_FILE" ]; then
    if cmp -s "$TARGET_FILE" "$TMP_REMOTE"; then
      ui_print "- Keybox is already up to date. No changes made."
      rm -f "$TMP_REMOTE"
      return
    else
      ui_print "- Remote keybox differs. Backing up current keybox..."
      mv "$TARGET_FILE" "$BACKUP_FILE"
    fi
  else
    ui_print "- No existing keybox found. Will create a new one."
  fi

  mv "$TMP_REMOTE" "$TARGET_FILE"
  ui_print "- keybox.xml successfully updated."
}

# Start logic
ui_print "- Checking if there is an existing keybox..."

mkdir -p "$TRICKY_DIR"

if [ -f "$TARGET_FILE" ]; then
  if grep -q "yuriiroot" "$TARGET_FILE"; then
    ui_print "- Existing Yuri Keybox found."
    version
    update_keybox_if_needed
  else
    ui_print "- Existing keybox not by Yuri."
    ui_print "- Creating a backup..."
    mv "$TARGET_FILE" "$BACKUP_FILE"
    version
    update_keybox_if_needed
  fi
else
  ui_print "- No keybox found. Creating a new one."
  version
  update_keybox_if_needed
fi