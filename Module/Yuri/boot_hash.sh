#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d %H:%M:%S) [SET_BOOT_HASH] $1"
}

log_message "Start"

# vbmeta hash'i al
boot_hash=$(su -c "getprop ro.boot.vbmeta.digest" 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$boot_hash" ]; then
    log_message "ERROR: Failed to get vbmeta digest or digest is empty"
    log_message "Tip: To fix this, please install the VBMeta Fixer module:"
    log_message "https://github.com/reveny/Android-VBMeta-Fixer/releases/latest"
    exit 1
fi

log_message "vbmeta digest: $boot_hash"

file_path="/data/adb/boot_hash"

# klasörü oluştur
if ! mkdir -p "$(dirname "$file_path")"; then
    log_message "ERROR: Failed to create directory: $(dirname "$file_path")"
    exit 1
fi

log_message "Writing boot hash to $file_path"

# dosyaya yaz
if ! echo "$boot_hash" > "$file_path"; then
    log_message "ERROR: Failed to write boot hash to $file_path"
    exit 1
fi

# izinleri ayarla
if ! chmod 644 "$file_path"; then
    log_message "ERROR: Failed to set permissions on $file_path"
    exit 1
fi

# resetprop ile sistemi güncelle
if ! su -c "resetprop -n ro.boot.vbmeta.digest $boot_hash" >/dev/null 2>&1; then
    log_message "ERROR: Failed to set ro.boot.vbmeta.digest with resetprop"
    exit 1
fi

log_message "Finish"