#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [KILL_GOOGLE] $1"
}

# Start
log_message "Start"

# Writing
log_message "Writing"
PKGS="com.android.vending com.google.android.gms.unstable"
for pkg in $PKGS; do
    pid=$(pidof "$pkg")
    [ -n "$pid" ] && kill -9 "$pid"
done
# Finish
log_message "Finish"
