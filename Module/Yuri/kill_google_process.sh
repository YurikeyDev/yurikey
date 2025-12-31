#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [KILL_GOOGLE] $1"
}

# Start
log_message "Start"

# Writing
log_message "Writing"
PKGS="com.android.vending com.google.android.gms com.google.android.gsf"

for pkg in $PKGS; do
    if ! am force-stop "$pkg" >/dev/null 2>&1; then
        log_message "ERROR: Failed to force-stop $pkg"
        exit 1
    fi

    if ! pm clear --cache-only "$pkg" >/dev/null 2>&1; then
        log_message "ERROR: Failed to clear cache for $pkg"
        exit 1
    fi
done

# Finish
log_message "Finish"
