#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
VERSION_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/version"
ARCHIVE_BASE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/archive"

LATEST_VERSION=""
CURRENT_VERSION="(unknown)"

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
    ui_print "- ✅ Latest version available: $LATEST_VERSION"
  else
    ui_print "- ❌ Failed to fetch version info."
    exit 1
  fi
}

detect_current_keybox_version() {
  ui_print "- Detecting version of existing keybox..."

  INDEX_URL="$ARCHIVE_BASE_URL/index.txt"

  if command -v curl >/dev/null 2>&1; then
    version_list=$(curl -fsSL "$INDEX_URL")
  elif command -v wget >/dev/null 2>&1; then
    version_list=$(wget -qO- "$INDEX_URL")
  else
    ui_print "- ❌ curl or wget not available"
    return
  fi

  [ -z "$version_list" ] && ui_print "- ⚠️ Couldn't fetch archive version list." && return

  for ver in $version_list; do
    url="$ARCHIVE_BASE_URL/$ver/yurikey.xml"
    TEMP_FILE="$TRICKY_DIR/tmp_decoded.xml"

    # İndir, kontrol et, decode et ve dosyaya yaz
    if command -v curl >/dev/null 2>&1; then
      response=$(curl -fsSL "$url")
    elif command -v wget >/dev/null 2>&1; then
      response=$(wget -qO- "$url")
    fi

    if [ -z "$response" ]; then
      continue
    fi

    echo "$response" | base64 -d 2>/dev/null > "$TEMP_FILE"

    if [ ! -s "$TEMP_FILE" ]; then
      rm -f "$TEMP_FILE"
      continue
    fi

    if [ -f "$TARGET_FILE" ] && cmp -s "$TARGET_FILE" "$TEMP_FILE"; then
      CURRENT_VERSION="$ver"
      rm -f "$TEMP_FILE"
      ui_print "- 📌 Current keybox matches archived version: $CURRENT_VERSION"
      return
    fi

    rm -f "$TEMP_FILE"
  done

  ui_print "- ⚠️ Couldn't identify current keybox version."
}

install_from_remote_archive() {
  local archive_url="$ARCHIVE_BASE_URL/$LATEST_VERSION/yurikey.xml"

  ui_print "- Installing keybox from dpejoh/yurikey"

  if [ -f "$TARGET_FILE" ]; then
    ui_print "- Backing up existing keybox..."
    mv "$TARGET_FILE" "$BACKUP_FILE"
  fi

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$archive_url" | base64 -d > "$TARGET_FILE"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$archive_url" | base64 -d > "$TARGET_FILE"
  else
    ui_print "- ❌ Error: curl or wget not available."
    exit 1
  fi

  if [ $? -eq 0 ]; then
    ui_print "- ✅ keybox.xml installed from version: $LATEST_VERSION"
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

if [ -f "$TARGET_FILE" ]; then
  detect_current_keybox_version
  if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    ui_print "- ✅ You are already using the latest keybox ($LATEST_VERSION). No update needed."
    exit 0
  else
    ui_print "- 🔄 Updating to latest version: $LATEST_VERSION"
    install_from_remote_archive
  fi
else
  ui_print "- 🆕 No existing keybox found. Installing version: $LATEST_VERSION"
  install_from_remote_archive
fi

sleep 2
am start -a android.intent.action.VIEW -d tg://resolve?domain=yuriiroot >/dev/null 2>&1