#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [KILL_ALL] $1"
}

# Start
log_message "Start"

# Writing
log_message "Writing"
PKGS="com.android.vending com.google.android.gsf com.google.android.gms com.google.android.contactkeys com.google.android.ims com.google.android.safetycore com.google.android.apps.walletnfcrel com.google.android.apps.nbu.paisa.user com.zhenxi.hunter com.reveny.nativecheck io.github.vvb2060.keyattestation io.github.vvb2060.mahoshojo icu.nullptr.nativetest com.android.nativetest io.liankong.riskdetector me.garfieldhan.holmes luna.safe.luna com.zhenxi.hunter gr.nikolasspyr.integritycheck com.youhu.laifu"

for pkg in $PKGS; do
    if ! am force-stop "$pkg" >/dev/null 2>&1; then
        log_message "ERROR: Failed to force-stop $pkg"
        exit 1
    fi

    if ! pm clear "$pkg" >/dev/null 2>&1; then
        log_message "ERROR: Failed to clear data for $pkg"
        exit 1
    fi
done

# Finish
log_message "Finish"
