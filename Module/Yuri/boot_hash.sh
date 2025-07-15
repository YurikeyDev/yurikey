#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_BOOT_HASH] $1"
}

log_message "Start"

# Get vbmeta hash
boot_hash=$(su -c "getprop ro.boot.vbmeta.digest" 2>/dev/null)
[ -z "$boot_hash" ] && boot_hash="0000000000000000000000000000000000000000000000000000000000000000"

file_path="/data/adb/boot_hash"

# Create folder and write file
log_message "Writing"
mkdir -p "$(dirname "$file_path")"
echo "$boot_hash" > "$file_path"
chmod 644 "$file_path"
su -c "resetprop -n ro.boot.vbmeta.digest $boot_hash" >/dev/null 2>&1

log_message "Finish"