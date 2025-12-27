#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/hzzmonetvn/yurikey/refs/heads/main/key"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
TMP_FILE="$TRICKY_DIR/keybox.xml.tmp"

DEPENDENCY_MODULE="/data/adb/modules/tricky_store"
DEPENDENCY_MODULE_UPDATE="/data/adb/modules_update/tricky_store"

log_message() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [YURI_KEYBOX] $1"
}

log_message "Start"

if [ -d "$DEPENDENCY_MODULE_UPDATE" ] || [ -d "$DEPENDENCY_MODULE" ]; then
  log_message "Tricky Store installed"
else
  log_message "Error: Tricky Store not found"
  exit 1
fi

mkdir -p "$TRICKY_DIR"

if [ -f "$TARGET_FILE" ]; then
  mv "$TARGET_FILE" "$BACKUP_FILE"
fi

fetch_and_decode() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" | tr -d '\r\n ' | base64 -d > "$TMP_FILE"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$REMOTE_URL" | tr -d '\r\n ' | base64 -d > "$TMP_FILE"
  else
    log_message "No curl or wget"
    return 1
  fi

  [ ! -s "$TMP_FILE" ] && return 1
  return 0
}

log_message "Fetching keybox"

if ! fetch_and_decode; then
  log_message "Failed to fetch or decode keybox"
  exit 1
fi

mv "$TMP_FILE" "$TARGET_FILE"
chmod 600 "$TARGET_FILE"

log_message "Keybox updated"

URL="https://raw.githubusercontent.com/hzzmonetvn/yurikey/refs/heads/main/status.json"
PROP="/data/adb/modules/Yurikey/module.prop"

STATUS="$(curl -fsSL "$URL" | tr -d '\r\n')"

if [ -n "$STATUS" ] && [ -f "$PROP" ]; then
  sed -i "s|^description=.*|description=$STATUS|" "$PROP"
fi

log_message "Finish"
