#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/refs/heads/main/conf"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"

log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') [YURI_KEYBOX] $1"
}

log_message "Start"

override_keybox() {
    log_message "Writing"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$REMOTE_URL" | base64 -d > "$TARGET_FILE"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- "$REMOTE_URL" | base64 -d > "$TARGET_FILE"
    fi
}

# Start logic
mkdir -p "$TRICKY_DIR"

if [ -f "$TARGET_FILE" ]; then
    if ! grep -q "yuriiroot" "$TARGET_FILE"; then
        mv "$TARGET_FILE" "$BACKUP_FILE"
    fi
    override_keybox
else
    touch "$TARGET_FILE"
    override_keybox
fi

log_message "Finish"