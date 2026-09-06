MODPATH="${0%/*}"

# ensure not running in busybox ash standalone shell
set +o standalone
unset ASH_STANDALONE

for SCRIPT in \
  "kill_google_process.sh" \
  "target_txt.sh" \
  "security_patch.sh" \
  "boot_hash.sh" \
  "yuri_keybox.sh"
do
  if ! sh "$MODPATH/Yuri/$SCRIPT"; then
    echo "- Error: $SCRIPT failed. Aborting..."
    exit 1
  fi
done
  sh "$MODPATH/Yuri/pif.sh"
# Hide Zygisk Next
if [ -f "/data/adb/modules/zygisksu/bin/zygiskd" ]; then
 ZN="/data/adb/modules/zygisksu/bin/zygiskd"
 $ZN enforce-denylist just_umount
 $ZN memory-type anonymous
 $ZN linker builtin
fi

if [ -f /data/adb/modules_update/Yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules_update/Yurikey/webroot/common/device-info.sh
elif [ -f /data/adb/modules/yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules/yurikey/webroot/common/device-info.sh
fi

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with Yurikey Manager✨✨"
