#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_BOOT_HASH] $1"
}
log_message "Start"

boot_hash=$(su -c "getprop ro.boot.vbmeta.digest")
file_path="/data/adb/boot_hash"

mkdir -p "$(dirname "$file_path")"

if [ -n "$boot_hash" ]; then
    log_message "Writing"
    echo "$boot_hash" > "$file_path"
    chmod 644 "$file_path"
    
    su -c "resetprop -n ro.boot.vbmeta.digest $boot_hash"
    log_message "Finish"
else
    log_message "Boot hash not found (vbmeta digest is empty)"
fi