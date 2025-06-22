  #!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/refs/heads/main/conf"
VERSION_URL="https://raw.githubusercontent.com/dpejoh/yurikey/refs/heads/main/version"

ui_print() {
  echo "$1"
}

version() {
  ui_print "- Checking latest available keybox..."

  if command -v curl >/dev/null 2>&1; then
    VERSION=$(curl -fsSL "$VERSION_URL")
    ui_print "- $VERSION version available."
  elif command -v wget >/dev/null 2>&1; then
    VERSION=$(wget -qO- "$VERSION_URL")
    ui_print "- $VERSION version available."
  else
    VERSION=""
    ui_print "- Failed to fetch version info."
  fi
}

override_keybox() {
  ui_print "- Downloading and overriding keybox.xml..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" | base64 -d > "$TARGET_FILE"  && ui_print "- keybox.xml successfully updated."
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$REMOTE_URL" | base64 -d > "$TARGET_FILE" && ui_print "- keybox.xml successfully updated."
  else
    ui_print "- Error: curl or wget not available."
    ui_print "- Cannot fetch remote keybox."
  fi
}

# Start logic
ui_print "- Checking if there is an existing keybox..."

mkdir -p "$TRICKY_DIR"

if [ -f "$TARGET_FILE" ]; then
  if grep -q "yuriiroot" "$TARGET_FILE"; then
    ui_print "- Existing Yuri Keybox found."
    version
    override_keybox
  else
    ui_print "- Existing keybox not by Yuri."
    ui_print "- Creating a backup..."
    mv "$TARGET_FILE" "$BACKUP_FILE"
    version
    override_keybox
  fi
else
  ui_print "- No keybox found. Creating a new one."
  touch "$TARGET_FILE"
  version
  override_keybox
fi