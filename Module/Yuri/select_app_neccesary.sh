#!/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [KILL_ALL] $1"
}

# Start
log_message "Start"

t='/data/adb/tricky_store/target.txt'

# Writing
log_message "Writing"

# add list special
fixed_targets="\
android
com.android.vending!
com.google.android.gsf!
com.google.android.gms!
com.google.android.apps.walletnfcrel
com.openai.chatgpt!
com.reveny.nativecheck!
io.github.vvb2060.keyattestation!
io.github.vvb2060.mahoshojo!
icu.nullptr.nativetest!
com.android.nativetest!
io.liankong.riskdetector!
me.garfieldhan.holmes!
luna.safe.luna!
com.zhenxi.hunter!
gr.nikolasspyr.integritycheck!
com.youhu.laifu!
com.google.android.contactkeys!
com.google.android.ims!
com.google.android.safetycore!
com.whatsapp!
com.whatsapp.w4b!"
for entry in $fixed_targets; do
    if ! echo "$entry" >> "$t"; then
        log_message "ERROR: Failed to write $entry to $t"
        exit 1
    fi
done

log_message "Finish"