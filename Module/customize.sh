#!/system/bin/sh

# Define important paths and file names
TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/Yurii0307/yurikey/main/key"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
REMOTE_FILE="$TRICKY_DIR/keybox"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
DEPENDENCY_MODULE="/data/adb/modules/tricky_store"
DEPENDENCY_MODULE_UPDATE="/data/adb/modules_update/tricky_store"
BBIN="/data/adb/Yurikey/bin"

# Show UI banner
ui_print ""
ui_print "*********************************"
ui_print "*****Yuri Keybox Installer*******"
ui_print "*********************************"
ui_print ""

# Check code
if ! command -v curl >/dev/null 2>&1 &&
   ! command -v wget >/dev/null 2>&1 &&
   ! command -v toybox >/dev/null 2>&1; then
  ui_print "- Cannot work without missing command."
  ui_print "- Tip: You can install a working BusyBox with network tools from:"
  ui_print "- https://mmrl.dev/repository/grdoglgmr/busybox-ndk"
  exit 0
fi

# Remove old module if legacy path exists (lowercase 'yurikey')
if [ -d "/data/adb/modules/yurikey" ]; then
  touch /data/adb/modules/yurikey/remove
fi

# Check if Tricky Store module is installed (required dependency)
if [ -d "$DEPENDENCY_MODULE_UPDATE" ] || [ -d "$DEPENDENCY_MODULE" ]; then
  ui_print "- Tricky Store installed"
else
  ui_print "- Error: Tricky Store module file not found!"
  ui_print "- Please install Tricky Store before using Yuri Keybox."
  return 0
fi

# A few wipes
if [ -d "$BBIN" ]; then
  rm -rf $BBIN
fi

# Function to download the remote keybox
fetch_remote_keybox() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" | base64 -d > "$REMOTE_FILE"
    if [ ! -f "$REMOTE_FILE" ]; then
      ui_print "ERROR: Remote script failed or no vaild keybox found. Aborting."
      return 1
    fi
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$REMOTE_URL" | base64 -d > "$REMOTE_FILE"
    if [ ! -f "$REMOTE_FILE" ]; then
      ui_print "ERROR: Remote script failed or no vaild keybox found. Aborting."
      return 1
    fi
  elif command -v toybox >/dev/null 2>&1; then
    toybox wget -qO- "$REMOTE_URL" | base64 -d > "$REMOTE_FILE"
    if [ ! -f "$REMOTE_FILE" ]; then
      ui_print "ERROR: Remote script failed or no vaild keybox found. Aborting."
      return 1
    fi
  else
    ui_print "- Cannot work without missing command."
    ui_print "- Tip: You can install a working BusyBox with network tools from:"
    ui_print "- https://mmrl.dev/repository/grdoglgmr/busybox-ndk"
    return 1
  fi
  return 0
}

# Function to update the keybox file
update_keybox() {
  ui_print "- Fetching remote keybox..."
  if ! fetch_remote_keybox; then
    ui_print "- Failed to fetch keybox!"
    return
  fi

  # Check if keybox already exists
  if [ -f "$TARGET_FILE" ]; then
    # If the new one is identical, skip update
    if cmp -s "$TARGET_FILE" "$REMOTE_FILE"; then
      ui_print "- Existing Yuri Keybox found. No changes made."
      rm -f "$REMOTE_FILE"
      return
    else
      # If the file differs, back up the old one
      ui_print "- Existing keybox is not by Yuri."
      ui_print "- Creating a backup..."
      mv "$TARGET_FILE" "$BACKUP_FILE"
      mv "$REMOTE_FILE" "$TARGET_FILE"
    fi
  else
    ui_print "- No keybox found. Creating a new one."
  fi
}
# Start main logic
ui_print "- Checking if there is an Yuri Keybox..."
mkdir -p "$TRICKY_DIR" # Make sure the directory exists
update_keybox          # Begin the update process

# Run bundled device-info.sh if present (already verified)
DEVICE_INFO_SCRIPT="$TMPDIR/webroot/common/device-info.sh"
if [ -f "$DEVICE_INFO_SCRIPT" ]; then
  sh "$DEVICE_INFO_SCRIPT"
else
  # fallback: run already-installed one
  if [ -f /data/adb/modules_update/Yurikey/webroot/common/device-info.sh ]; then
    sh /data/adb/modules_update/Yurikey/webroot/common/device-info.sh
  elif [ -f /data/adb/modules/yurikey/webroot/common/device-info.sh ]; then
    sh /data/adb/modules/yurikey/webroot/common/device-info.sh
  fi
fi