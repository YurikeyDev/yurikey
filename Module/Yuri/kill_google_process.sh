#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [KILL_GOOGLE] $1"
}

# Start
log_message "Start"

# Writing
log_message "Writing"
PKGS="com.android.vending"
for pkg in $PKGS; do
    am force-stop "$pkg"     >/dev/null 2>&1
    pm clear "$pkg"          >/dev/null 2>&1
done

# Finish
log_message "Finish"
