MODPATH="${0%/*}"

# Setup
set +o standalone
unset ASH_STANDALONE

sh $MODPATH/Yuri/kill_google_process.sh
sh $MODPATH/Yuri/yuri_keybox.sh
sh $MODPATH/Yuri/target_txt.sh
sh $MODPATH/Yuri/security_patch.sh

echo -e "$(date +%Y-%m-%d\ %H:%M:%S) Meets Strong Integrity with Yurikey✨✨"

sh $MODPATH/Yuri/author.sh

