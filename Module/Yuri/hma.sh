#!/system/bin/sh

if ! command -v curl >/dev/null 2>&1 \
   && ! command -v wget >/dev/null 2>&1 \
   && ! command -v toybox >/dev/null 2>&1
then
  log_message "- Cannot work without missing command."
  log_message "- Tip: You can install a working BusyBox with network tools from:"
  log_message "- https://mmrl.dev/repository/grdoglgmr/busybox-ndk"
  exit 1
fi

mkdir -p /data/user/0/org.frknkrc44.hma_oss/files
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "https://raw.githubusercontent.com/YurikeyDev/yurikey/refs/heads/main/config.json" -o /data/user/0/org.frknkrc44.hma_oss/files/config.json
elif command -v wget >/dev/null 2>&1; then
  wget -qO- "https://raw.githubusercontent.com/YurikeyDev/yurikey/refs/heads/main/config.json" -o /data/user/0/org.frknkrc44.hma_oss/files/config.json
elif command -v toybox >/dev/null 2>&1; then
  toybox wget -qO- "https://raw.githubusercontent.com/YurikeyDev/yurikey/refs/heads/main/config.json" -o /data/user/0/org.frknkrc44.hma_oss/files/config.json
else
  exit 1
fi
chmod 777 /data/user/0/org.frknkrc44.hma_oss/files/config.json
chown u0_a0:u0_a0 /data/user/0/org.frknkrc44.hma_oss/files/config.json
