#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [PIF] $1"
}

log_message "Start"

TARGET_FILE="/data/adb/modules/playintegrityfix"

# Check if the directory exists 
if [ ! -d "$TARGET_FILE" ] && [ ! -f "$TARGET_FILE/module.prop" ]; then
    log_message "Error: Play Integrity Fix is not found, please install the latest Play Integrity Fix."
    exit 1
fi

fetch_pif () {
    # Extract the name from module.prop
    MODULE_NAME=$(grep "^name=" "$TARGET_FILE/module.prop" | cut -d= -f2-)
    if [ "$MODULE_NAME" = "Play Integrity Fix [INJECT]" ]; then
      log_message "Detected Play Integrity Fix [INJECTS]. Executing..."
      sh "$TARGET_FILE/autopif_ota.sh" || true
      sh "$TARGET_FILE/autopif.sh"
    elif [ "$MODULE_NAME" = "Play Integrity Fork" ]; then
      log_message "Detected Play Integrity Fork. Executing..."
      sh "$TARGET_FILE/autopif4.sh" -m || return
    else
      log_message "Unknown module $MODULE_NAME"
      log_message "Please use Play Integrity Fix [INJECTS] or Play Integrity Fork to update fingeprint"
      return
    fi
}

update_pif () {
    if ! fetch_pif; then
        log_message "Failed to update fingerprints!"
        return
    fi
}

# Start main logic
log_message "Writing"

# Ensure directory exists before proceeding
mkdir -p "$TARGET_FILE"
update_pif

log_message "Finish"
