#!/system/bin/sh
# Define important paths and file names
TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/Yurii0307/yurikey/main/key"
REMOTE_FILE="$TRICKY_DIR/keybox"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
DECODE_FILE="$TRICKY_DIR/keybox_decode"
DEPENDENCY_MODULE="/data/adb/modules/tricky_store"
DEPENDENCY_MODULE_UPDATE="/data/adb/modules_update/tricky_store"
BBIN="/data/adb/Yurikey/bin"
ORG_PATH="$PATH"

# Show UI banner
ui_print ""
ui_print "__   __           _ _              "
ui_print "\\ \\ / /   _ _ __ (_) | _____ _   _ "
ui_print " \\ V / | | | '__|| | |/ / _ \\ | | |"
ui_print "  | || |_| | |   | |   <  __/ |_| |"
ui_print "  |_| \\__,_|_|   |_|_|\\_\\___|\\__, |"
ui_print "                             |___/ "
ui_print ""

# Remove old module if legacy path exists (lowercase 'yurikey')
if [ -d "/data/adb/modules/yurikey" ]; then
  touch /data/adb/modules/yurikey/remove
fi

# Check if Tricky Store module is installed (required dependency)
if [ ! -d "$DEPENDENCY_MODULE_UPDATE" ] && [ ! -d "$DEPENDENCY_MODULE" ]; then
  ui_print "- Error: Module Tricky Store file not found!"
  ui_print "- Please install module Tricky Store before using module Yurikey Manager"
  return 0
fi

# A few wipes
if [ -d "$BBIN" ]; then
  rm -rf $BBIN
fi

download() {
    PATH=/data/adb/magisk:/data/data/com.termux/files/usr/bin:$PATH
    if command -v curl >/dev/null 2>&1; then
        curl --connect-timeout 10 -Ls "$1"
    else
        busybox wget -T 10 --no-check-certificate -qO- "$1"
    fi
    PATH="$ORG_PATH"
}

# Function to download the remote keybox
get_keybox() {
    download "$REMOTE_URL" > "$REMOTE_FILE" || ui_print "Error: Keybox download failed, please add keybox manually!"

    if ! base64 -d "$REMOTE_FILE" > "$DECODE_FILE" 2>/dev/null; then
        ui_print "- Error: Base64 decode failed!"
        return 1
    fi
    return 0
}

# Function to update the keybox file
update_keybox() {
  ui_print "- Fetching remote Yuri keybox..."
  if ! get_keybox; then
    ui_print "- Failed to fetch Yuri keybox!"
    return
  fi

  # Check if keybox already exists
  if [ -f "$TARGET_FILE" ]; then
    # If the new one is identical, skip update
    if cmp -s "$TARGET_FILE" "$DECODE_FILE"; then
      ui_print "- Existing Yuri Keybox found. No changes made."
      rm -f "$REMOTE_FILE"
      return
    else
      # If the file differs, back up the old one
      ui_print "- This keybox is not by Yuri."
      ui_print "- Creating a backup keybox...."
      ui_print "- Existing Yuri Keybox now!"
      mv "$TARGET_FILE" "$BACKUP_FILE"
      mv "$DECODE_FILE" "$TARGET_FILE"
    fi
  else
    ui_print "- No keybox found! Creating a new one..."
    mv "$DECODE_FILE" "$TARGET_FILE"
    rm -f "$REMOTE_FILE"
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
