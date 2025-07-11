MODPATH="${0%/*}"

# Setup
set +o standalone
unset ASH_STANDALONE

for SCRIPT in \
  "kill_google_process.sh" \
  "yuri_keybox.sh" \
  "target_txt.sh" \
  "security_patch.sh" \
  "boot_hash.sh"
do
  if ! sh "$MODPATH/Yuri/$SCRIPT"; then
    echo "- Error: $SCRIPT failed. Aborting."
    exit 1
  fi
done

if [ -f /data/adb/modules_update/Yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules_update/Yurikey/webroot/common/device-info.sh
elif [ -f /data/adb/modules/yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules/yurikey/webroot/common/device-info.sh
fi

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with Yurikey Manager✨✨"
