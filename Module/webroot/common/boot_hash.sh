#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_BOOT_HASH] $1"
}

log_message "Start"

# Get vbmeta hash
boot_hash=$(su -c "getprop ro.boot.vbmeta.digest" 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$boot_hash" ]; then
    boot_hash="0000000000000000000000000000000000000000000000000000000000000000"
fi

file_path="/data/adb/boot_hash"

# Create the folder
if ! mkdir -p "$(dirname "$file_path")"; then
    log_message "ERROR: Failed to create directory: $(dirname "$file_path")"
    exit 1
fi

# Write to file
if ! echo "$boot_hash" > "$file_path"; then
    log_message "ERROR: Failed to write boot hash to $file_path"
    exit 1
fi

# Set permissions
if ! chmod 644 "$file_path"; then
    log_message "ERROR: Failed to set permissions on $file_path"
    exit 1
fi

# Update system with resetprop
if ! su -c "resetprop -n ro.boot.vbmeta.digest $boot_hash" >/dev/null 2>&1; then
    log_message "ERROR: Failed to set ro.boot.vbmeta.digest with resetprop"
    exit 1
fi

log_message "Finish"