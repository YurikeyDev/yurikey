#!/system/bin/sh

# Define important paths and file names
TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/conf"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
TMP_REMOTE="$TRICKY_DIR/remote_keybox.tmp"
SCRIPT_REMOTE="$TRICKY_DIR/remote_script.sh"
DEPENDENCY_MODULE="/data/adb/modules/tricky_store"

# Show UI banner
ui_print ""
ui_print "*********************************"
ui_print "*****Yuri Keybox Installer*******"
ui_print "*********************************"
ui_print ""

# Remove old module if legacy path exists (lowercase 'yurikey')
if [ -d "/data/adb/modules/yurikey" ]; then
  touch /data/adb/modules/yurikey/remove
fi

# Remove unauthorized module if it exists (MagiskLabs - copied YuriRoot code)
if [ -d "/data/adb/modules/MagiskLabs" ]; then
  touch /data/adb/modules/MagiskLabs/remove
fi

# Check if Tricky Store module is installed (required dependency)
if [ ! -d "$DEPENDENCY_MODULE" ]; then
  ui_print "- Error: Tricky Store module not found!"
  ui_print "- Please install Tricky Store before using Yuri Keybox."
  exit 1
fi

# Function to download the remote keybox
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

# Function to update the keybox file
update_keybox() {
  ui_print "- Fetching remote keybox..."
  if ! fetch_remote_keybox; then
    ui_print "- Failed to fetch remote keybox!"
    return
  fi

  # Check if keybox already exists
  if [ -f "$TARGET_FILE" ]; then
    # If the new one is identical, skip update
    if cmp -s "$TARGET_FILE" "$TMP_REMOTE"; then
      ui_print "- Existing Yuri Keybox found. No changes made."
      rm -f "$TMP_REMOTE"
      return
    else
      # If the file differs, back up the old one
      ui_print "- Existing keybox not by Yuri."
      ui_print "- Creating a backup..."
      mv "$TARGET_FILE" "$BACKUP_FILE"
    fi
  else
    ui_print "- No keybox found. Creating a new one."
  fi

  # Move the downloaded keybox into place
  mv "$TMP_REMOTE" "$TARGET_FILE"
  ui_print "- keybox.xml successfully updated."
}

# Start main logic
ui_print "- Checking if there is an Yuri Keybox..."
mkdir -p "$TRICKY_DIR" # Make sure the directory exists
update_keybox          # Begin the update process

# Open Telegram channel at the end
sleep 2
am start -a android.intent.action.VIEW -d tg://resolve?domain=yuriiroot >/dev/null 2>&1
