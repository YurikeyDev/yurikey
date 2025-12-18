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
do
  if ! sh "$MODPATH/Yuri/$SCRIPT"; then
    echo "- Error: $SCRIPT failed. Aborting."
    exit 1
  fi
done

if command -v curl >/dev/null 2>&1; then
 su -c "yuri_keybox.sh"
else
 ui_print "- Cannot fetch remote keybox."
 ui_print "- Tip: You can install a working BusyBox with network tools from:"
 ui_print "- https://mmrl.dev/repository/grdoglgmr/busybox-ndk"
 exit 1
fi

if [ -f /data/adb/modules_update/Yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules_update/Yurikey/webroot/common/device-info.sh
elif [ -f /data/adb/modules/yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules/yurikey/webroot/common/device-info.sh
fi

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with Yurikey Manager✨✨"
