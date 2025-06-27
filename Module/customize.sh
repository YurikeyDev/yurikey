#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
VERSION_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/version"
ARCHIVE_BASE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/archive"

LATEST_VERSION=""

ui_print() {
  echo "$1"
}

fetch_latest_version() {
  ui_print "- Checking latest available keybox version..."
  if command -v curl >/dev/null 2>&1; then
    LATEST_VERSION=$(curl -fsSL "$VERSION_URL")
  elif command -v wget >/dev/null 2>&1; then
    LATEST_VERSION=$(wget -qO- "$VERSION_URL")
  else
    ui_print "- ❌ Error: curl or wget not available."
    exit 1
  fi

  if [ -n "$LATEST_VERSION" ]; then
    ui_print "- Latest version is: $LATEST_VERSION"
  else
    ui_print "- ❌ Failed to fetch version info."
    exit 1
  fi
}

install_from_remote_archive() {
  local archive_url="$ARCHIVE_BASE_URL/$LATEST_VERSION/yurikey.xml"

  ui_print "- Downloading keybox from: $archive_url"

  # Eski dosya varsa sil
  [ -f "$TARGET_FILE" ] && rm -f "$TARGET_FILE"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$archive_url" | base64 -d > "$TARGET_FILE"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$archive_url" | base64 -d > "$TARGET_FILE"
  else
    ui_print "- ❌ Error: curl or wget not available."
    exit 1
  fi

  if [ $? -eq 0 ]; then
    ui_print "- ✅ keybox.xml successfully installed from remote archive version: $LATEST_VERSION"
  else
    ui_print "- ❌ Failed to decode and install keybox."
    exit 1
  fi
}

# =====================
# 🚀 Starting Point
# =====================

ui_print ""
ui_print "*********************************"
ui_print "***** Yuri Keybox Installer *****"
ui_print "*********************************"
ui_print ""

mkdir -p "$TRICKY_DIR"

fetch_latest_version
install_from_remote_archive

sleep 2
am start -a android.intent.action.VIEW -d tg://resolve?domain=yuriiroot >/dev/null 2>&1