#!/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [KILL_ALL] $1"
}

# Start
log_message "Start"

t='/data/adb/tricky_store/target.txt'

# Writing
log_message "Writing"
rm -rf "$t"
# add list special
fixed_targets="\
android
com.android.vending
com.google.android.gsf
com.google.android.gms
com.google.android.ims
io.github.vvb2060.keyattestation?
io.github.vvb2060.mahoshojo?
io.github.qwq233.keyattestation?
com.google.android.contactkeys
com.google.android.safetycore
com.google.android.apps.walletnfcrel
com.google.android.apps.nbu.paisa.user
com.reveny.nativecheck?
icu.nullptr.nativetest?
com.android.nativetest?
io.liankong.riskdetector?
me.garfieldhan.holmes?
luna.safe.luna?
com.zhenxi.hunter?
com.studio.duckdetector?
com.eltavine.duckdetector?
com.rem01gaming.disclosure?
wu.keyChain.test?
com.kikyps.crackme?
com.chunqiunativecheck?"
for entry in $fixed_targets; do
    if ! echo "$entry" >> "$t"; then
        log_message "Error: Failed to write $entry to $t"
        exit 1
    fi
done

log_message "Finish"
