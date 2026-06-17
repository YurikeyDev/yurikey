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

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [YURI_KEYBOX] $1"
}
log_message "Start"

# Check if Tricky Store module is installed (required dependency)
if [ ! -d "$DEPENDENCY_MODULE_UPDATE" ] && [ ! -d "$DEPENDENCY_MODULE" ]; then
  log_message "Error: Tricky Store module file not found!"
  log_message "Please install Tricky Store before using Yuri Keybox."
  exit 1
fi

# Backup keybox before fetching
if [ -f "$TARGET_FILE" ]; then
  mv "$TARGET_FILE" "$BACKUP_FILE"
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
    download "$REMOTE_URL" > "$REMOTE_FILE" || log_message "Error: Keybox download failed, please download and add it manually!"

    if ! base64 -d "$REMOTE_FILE" > "$DECODE_FILE" 2>/dev/null; then
        log_message "Error: Base64 decode failed!"
        rm -f "$REMOTE_FILE"
        mv "$BACKUP_FILE" "$TARGET_FILE"
        return 1
    fi

    rm -f "$REMOTE_FILE"
    mv "$DECODE_FILE" "$TARGET_FILE"
    return 0
}

# Function to update the keybox file
update_keybox() {
  if ! get_keybox; then
    log_message "Failed to fetch keybox!"
    return
  fi
}

# Start main logic
log_message "Writing"

mkdir -p "$TRICKY_DIR" # Make sure the directory exists
update_keybox          # Begin the update process

log_message "Finish"
