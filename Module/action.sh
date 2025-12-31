MODPATH="${0%/*}"

# Setup
set +o standalone
unset ASH_STANDALONE

if ! command -v curl >/dev/null 2>&1 \
   && ! command -v wget >/dev/null 2>&1 \
   && ! command -v toybox >/dev/null 2>&1
then
  log_message "- Cannot work without missing command."
  log_message "- Tip: You can install a working BusyBox with network tools from:"
  log_message "- https://mmrl.dev/repository/grdoglgmr/busybox-ndk"
  exit 1
fi

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


if [ -f /data/adb/modules_update/Yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules_update/Yurikey/webroot/common/device-info.sh
elif [ -f /data/adb/modules/yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules/yurikey/webroot/common/device-info.sh
fi

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with Yurikey Manager✨✨"
