#!/system/bin/sh

# Define important paths and file names
TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/Yurii0307/yurikey/main/key"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
DEPENDENCY_MODULE="/data/adb/modules/tricky_store"
DEPENDENCY_MODULE_UPDATE="/data/adb/modules_update/tricky_store"
BBIN="/data/adb/Yurikey/bin"

# Detailed log
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') [YURI_KEYBOX] $1"
}

log_message "Start"
log_message "Writing"

if ! command -v curl >/dev/null 2>&1 \
   && ! command -v wget >/dev/null 2>&1 \
   && ! command -v toybox >/dev/null 2>&1
then
  log_message "- Cannot work without missing command."
  log_message "- Tip: You can install a working BusyBox with network tools from:"
  log_message "- https://mmrl.dev/repository/grdoglgmr/busybox-ndk"
  return 1
fi

# Check if Tricky Store module is installed ( required dependency )
if [ -d "$DEPENDENCY_MODULE_UPDATE" ] || [ -d "$DEPENDENCY_MODULE" ]; then
  log_message "- Tricky Store installed"
else
  log_message "- Error: Tricky Store module file not found!"
  log_message "- Please install Tricky Store before using Yuri Keybox."
  return 0
fi
if [ -f "$TARGET_FILE" ]; then
  mv "$TARGET_FILE" "$BACKUP_FILE"
fi
# Function to download the remote keybox
fetch_remote_keybox() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" | base64 -d > "$TARGET_FILE"
    if [ ! -f "$TARGET_FILE" ]; then
      log_message "ERROR: Remote script failed or no vaild keybox found. Aborting."
      return 1
    fi
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$REMOTE_URL" | base64 -d > "$TARGET_FILE"
    if [ ! -f "$TARGET_FILE" ]; then
      log_message "ERROR: Remote script failed or no vaild keybox found. Aborting."
      return 1
    fi
  elif command -v toybox >/dev/null 2>&1; then
    toybox wget -qO- "$REMOTE_URL" | base64 -d > "$TARGET_FILE"
    if [ ! -f "$TARGET_FILE" ]; then
      log_message "ERROR: Remote script failed or no vaild keybox found. Aborting."
      return 1
    fi
  else
    return 1
  fi
  return 0
}

# Function to update the keybox file
update_keybox() {
  if ! fetch_remote_keybox; then
    mv "$BACKUP_FILE" "$TARGET_FILE"
    return 1
  fi
}

# Start main logic
mkdir -p "$TRICKY_DIR" # Make sure the directory exists
update_keybox          # Begin the update process

log_message "Finish"
