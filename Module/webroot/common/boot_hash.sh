#!/system/bin/sh

boot_hash=$(su -c "getprop ro.boot.vbmeta.digest")
file_path="/data/adb/boot_hash"

mkdir -p "$(dirname "$file_path")"

if [ -n "$boot_hash" ]; then
  echo "$boot_hash" > "$file_path"
  chmod 644 "$file_path"
  echo "Boot hash saved: $boot_hash"
  su -c "resetprop -n ro.boot.vbmeta.digest $boot_hash"
  echo "Boot hash updated successfully: $boot_hash"
else
  echo "Boot hash not found (vbmeta digest is empty)"
fi