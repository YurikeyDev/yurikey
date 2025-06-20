  #!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/refs/heads/main/keybox.xml"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
VERSION_URL="https://raw.githubusercontent.com/dpejoh/yurikey/refs/heads/main/version"

ui_print() {
  echo "$1"
}

ui_print "Checking latest available keybox..."

VERSION=$(curl -fsSL "$VERSION_URL")
# If curl fails, fallback message
if [ -z "$VERSION" ]; then
  ui_print "Failed to fetch version info."
else
  ui_print "$VERSION version available"
fi
  
ui_print "Downloading and overriding keybox.xml..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$REMOTE_URL" -o "$TARGET_FILE" && ui_print "keybox.xml successfully updated."
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$TARGET_FILE" "$REMOTE_URL" && ui_print "keybox.xml successfully updated."
else
  ui_print "Error: curl or wget not available. Cannot fetch remote keybox."
fi