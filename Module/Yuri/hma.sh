#!/system/bin/sh
mkdir -p /data/user/0/org.frknkrc44.hma_oss/files
curl -L "https://raw.githubusercontent.com/YurikeyDev/yurikey/refs/heads/main/config.json" -o /data/user/0/org.frknkrc44.hma_oss/files/config.json
chmod 777 /data/user/0/org.frknkrc44.hma_oss/files/config.json
chown u0_a0:u0_a0 /data/user/0/org.frknkrc44.hma_oss/files/config.json
