MODPATH="${0%/*}"

# Setup
set +o standalone
unset ASH_STANDALONE

for SCRIPT in \
  "kill_google_process.sh" \
  "target_txt.sh" \
  "security_patch.sh" \
  "boot_hash.sh" \
  "clear_trace.sh" \
  "yuri_keybox.sh"
do
  if ! sh "$MODPATH/Yuri/$SCRIPT"; then
    echo "- Error: $SCRIPT failed. Aborting."
    exit 1
  elif ! sh "$MODPATH/Yuri/yuri_keybox.sh"; then
    log_message "- Cannot fetch remote keybox. Aborting"
    log_message "- Tip: You can install a working BusyBox with network tools from:"
    log_message "- https://mmrl.dev/repository/grdoglgmr/busybox-ndk"
    exit 1
  fi
done


if [ -f /data/adb/modules_update/Yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules_update/Yurikey/webroot/common/device-info.sh
elif [ -f /data/adb/modules/yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules/yurikey/webroot/common/device-info.sh
fi

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with Yurikey Manager✨✨"
