#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
VERSION_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/version"
ARCHIVE_BASE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/archive"

ui_print() {
  echo "$1"
}

fetch_latest_version() {
  ui_print "- Checking latest available keybox version..."

  if command -v curl >/dev/null 2>&1; then
    VERSION=$(curl -fsSL "$VERSION_URL")
  elif command -v wget >/dev/null 2>&1; then
    VERSION=$(wget -qO- "$VERSION_URL")
  else
    ui_print "- ❌ Error: curl or wget not available."
    exit 1
  fi

  if [ -n "$VERSION" ]; then
    ui_print "- ✅ Latest version available: $VERSION"
  else
    ui_print "- ❌ Failed to fetch version info."
    exit 1
  fi
}

install_keybox_from_remote_archive() {
  ARCHIVE_URL="$ARCHIVE_BASE_URL/$VERSION/yurikey.xml"
  ui_print "- Downloading keybox from: $ARCHIVE_URL"

  if [ -f "$TARGET_FILE" ]; then
    ui_print "- Backing up existing keybox..."
    mv "$TARGET_FILE" "$BACKUP_FILE"
  fi

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$ARCHIVE_URL" | base64 -d > "$TARGET_FILE"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$ARCHIVE_URL" | base64 -d > "$TARGET_FILE"
  else
    ui_print "- ❌ Error: curl or wget not available."
    exit 1
  fi

  if [ $? -eq 0 ]; then
    ui_print "- ✅ keybox.xml successfully installed from archive version: $VERSION"
  else
    ui_print "- ❌ Failed to decode or write keybox."
    exit 1
  fi
}

# ===========================
# 🚀 Start
# ===========================

ui_print ""
ui_print "*********************************"
ui_print "***** Yuri Keybox Updater *******"
ui_print "*********************************"
ui_print ""

mkdir -p "$TRICKY_DIR"

fetch_latest_version
install_keybox_from_remote_archive