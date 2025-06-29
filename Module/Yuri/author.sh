log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') [AUTHOR] $1"
}
log_message "Opening author page..."
nohup am start -a android.intent.action.VIEW -d https://t.me/yuriiroot >/dev/null 2>&1 &
log_message "Program completed..."
