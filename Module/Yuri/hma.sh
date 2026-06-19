#!/system/bin/sh

# Define important paths and file names
HMA_DIR="/data/user/0/org.frknkrc44.hma_oss/files"
HMA_FILE="/data/user/0/org.frknkrc44.hma_oss/files/config.json"
REMOTE_URL="https://raw.githubusercontent.com/YurikeyDev/yurikey/refs/heads/main/config.json"
ORG_PATH="$PATH"

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [HMA_OSS] $1"
}

download() {
    if command -v curl >/dev/null 2>&1; then
        curl -sL --connect-timeout 10 "$1"
    else
        wget -qO- -T 10 --no-check-certificate "$1"
    fi
}

if pm list packages | grep -q org.frknkrc44.hma_oss; then
  mkdir -p "$HMA_DIR"
  download "$REMOTE_URL" > "$HMA_FILE" || log_message "Error: HMA-oss configs download failed, please download and add it manually!"
elif pm list packages | grep -q com.tsng.hidemyapplist; then
  log_message "HMA is deprecated and not supported, please use latest HMA-oss to get latest configs"
else
  log_message "Error: HMA-oss not found, please install latest HMA-oss"
  exit 1
fi

chmod 777 "$HMA_FILE"
chown u0_a0:u0_a0 "$HMA_FILE"
