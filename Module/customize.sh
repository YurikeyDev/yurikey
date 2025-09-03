#!/system/bin/sh

# Define important paths and file names
TRICKY_DIR="/data/adb/tricky_store"
REMOTE_URL="https://raw.githubusercontent.com/dpejoh/yurikey/main/conf"
TARGET_FILE="$TRICKY_DIR/keybox.xml"
BACKUP_FILE="$TRICKY_DIR/keybox.xml.bak"
TMP_REMOTE="$TRICKY_DIR/remote_keybox.tmp"
SCRIPT_REMOTE="$TRICKY_DIR/remote_script.sh"
DEPENDENCY_MODULE="/data/adb/modules/tricky_store"
BUSYBOX_MODULE="/data/adb/modules/busybox-ndk"
BBIN="/data/adb/Yurikey/bin"

# Show UI banner
ui_print ""
ui_print "*********************************"
ui_print "*****Yuri Keybox Installer*******"
ui_print "*********************************"
ui_print ""

# Remove old module if legacy path exists (lowercase 'yurikey')
if [ -d "/data/adb/modules/yurikey" ]; then
  touch /data/adb/modules/yurikey/remove
fi

# Check if Tricky Store module is installed (required dependency)
if [ ! -d "$DEPENDENCY_MODULE" ]; then
  ui_print "- Error: Tricky Store module not found!"
  ui_print "- Please install Tricky Store before using Yuri Keybox."
  abort
fi

# Busybox Modules
if [ -d "$BUSYBOX_MODULE" ]; then
  ui_print "- If you're only using the Busybox for Android NDK module for YuriKey."
  ui_print "- We recommend removing it."
  ui_print "- You may no longer need it."
fi

# A few wipes
if [ -d "$BBIN" ]; then
  rm -rf $BBIN
fi

# Detect device architecture
find_arch() {
  local abi
  abi=$(getprop ro.product.cpu.abi)
  case "$abi" in
    arm64*) ARCH=arm64 ;;
    arm*)   ARCH=arm ;;
    x86_64*) ARCH=x86_64 ;;
    x86*)   ARCH=x86 ;;
    mips64*) ARCH=mips64 ;;
    mips*)   ARCH=mips ;;
    *) ui_print "- Unknown architecture: $abi"; abort ;;
  esac
}

# Install busybox binary to $BBIN
install_busybox() {
  ui_print "- Installing BusyBox..."
  find_arch
  mkdir -p "$BBIN"
  cp -f "$TMPDIR/busybox/busybox-$ARCH" "$BBIN/busybox"
  chmod 755 "$BBIN/busybox"
  ui_print "- BusyBox installed at $BBIN/busybox"
}

# Function to download the remote keybox
fetch_remote_keybox() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE_URL" | base64 -d > "$SCRIPT_REMOTE"
    chmod +x "$SCRIPT_REMOTE"
    if ! sh "$SCRIPT_REMOTE"; then
      ui_print "- Error: Remote script failed. Aborting."
      return 1
    fi
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$REMOTE_URL" | base64 -d > "$SCRIPT_REMOTE"
    chmod +x "$SCRIPT_REMOTE"
    if ! sh "$SCRIPT_REMOTE"; then
      ui_print "- Error: Remote script failed. Aborting."
      return 1
    fi
  else
    ui_print "- Error: curl or wget not found."
    ui_print "- Attempting to install bundled BusyBox..."
    install_busybox || {
      ui_print "- BusyBox install failed. Aborting."
      return 1
    }
    ui_print "- The installation is retried accordingly."
    if "$BBIN/busybox" curl --version >/dev/null 2>&1; then
      "$BBIN/busybox" curl -fsSL "$REMOTE_URL" | "$BBIN/busybox" base64 -d > "$SCRIPT_REMOTE"
      chmod +x "$SCRIPT_REMOTE"
      if ! sh "$SCRIPT_REMOTE"; then
        ui_print "- Error: Remote script failed. Aborting."
        return 1
      fi
    elif "$BBIN/busybox" wget --version >/dev/null 2>&1; then
      "$BBIN/busybox" wget -qO- "$REMOTE_URL" | "$BBIN/busybox" base64 -d > "$SCRIPT_REMOTE"
      chmod +x "$SCRIPT_REMOTE"
      if ! sh "$SCRIPT_REMOTE"; then
        ui_print "- Error: Remote script failed. Aborting."
        return 1
      fi
    else
      ui_print "- Error: Neither curl nor wget found in BusyBox. Aborting."
      return 1
    fi
  fi
  return 0
}

# Function to update the keybox file
update_keybox() {
  ui_print "- Fetching remote keybox..."
  if ! fetch_remote_keybox; then
    ui_print "- Failed to fetch remote keybox!"
    return
  fi

  # Check if keybox already exists
  if [ -f "$TARGET_FILE" ]; then
    # If the new one is identical, skip update
    if cmp -s "$TARGET_FILE" "$TMP_REMOTE"; then
      ui_print "- Existing Yuri Keybox found. No changes made."
      rm -f "$TMP_REMOTE"
      rm -rf "$SCRIPT_REMOTE"
      return
    else
      # If the file differs, back up the old one
      ui_print "- Existing keybox not by Yuri."
      ui_print "- Creating a backup..."
      mv "$TARGET_FILE" "$BACKUP_FILE"
      rm -rf "$SCRIPT_REMOTE"
    fi
  else
    ui_print "- No keybox found. Creating a new one."
  fi

  # Move the downloaded keybox into place
  mv "$TMP_REMOTE" "$TARGET_FILE"
  rm -rf "$SCRIPT_REMOTE"
  ui_print "- keybox.xml successfully updated."
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