MODPATH="${0%/*}"

# Setup
set +o standalone
unset ASH_STANDALONE

sh $MODPATH/Yuri/kill_google_process.sh
sh $MODPATH/Yuri/yuri_keybox.sh
sh $MODPATH/Yuri/target_txt.sh
sh $MODPATH/Yuri/security_patch.sh
sh $MODPATH/Yuri/boot_hash.sh
if [ -f /data/adb/modules_update/Yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules_update/Yurikey/webroot/common/device-info.sh
elif [ -f /data/adb/modules/yurikey/webroot/common/device-info.sh ]; then
  sh /data/adb/modules/yurikey/webroot/common/device-info.sh
fi

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with Yurikey Manager✨✨"


