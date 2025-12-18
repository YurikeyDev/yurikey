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
    if ! am force-stop "$pkg" >/dev/null 2>&1; then
        log_message "ERROR: Failed to force-stop $pkg"
        exit 1
    fi

    if ! cmd package trim-caches 0 "$pkg" >/dev/null 2>&1; then
        log_message "ERROR: Failed to clear cache for $pkg"
        exit 1
    fi
done

# Finish
log_message "Finish"
