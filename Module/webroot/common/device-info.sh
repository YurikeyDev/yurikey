#!/system/bin/sh

INFO_PATH="/data/adb/modules/Yurikey/webroot/json/device-info.json"
CHECK_SCRIPT="/data/adb/modules/Yurikey/webroot/common/dev-check.sh"

android_ver=$(getprop ro.build.version.release)
kernel_ver=$(uname -r)

# Root Implementation
if [ -d "/data/adb/ksu" ]; then
  root_type="KernelSU"
elif [ -d "/sbin/.magisk" ] || [ -f "/data/adb/magisk" ]; then
  root_type="Magisk"
elif [ -f "/data/apatch/apatch" ]; then
  root_type="Apatch"
else
  root_type="Unknown"
fi

# Output JSON
cat <<EOF > "$INFO_PATH"
{
  "android": "$android_ver",
  "kernel": "$kernel_ver",
  "root": "$root_type"
}
EOF
