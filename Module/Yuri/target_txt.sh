#!/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_TARGET] $1"
}

log_message "Start"

t='/data/adb/tricky_store/target.txt'
tees='/data/adb/tricky_store/tee_status'

# tee status 
teeBroken="false"
if [ -f "$tees" ]; then
    teeBroken=$(grep -E '^teeBroken=' "$tees" | cut -d '=' -f2 2>/dev/null || echo "false")
    if [ -z "$teeBroken" ]; then
        log_message "ERROR: Failed to parse teeBroken status"
        exit 1
    fi
fi

# add list special
rm -rf $"t"
fixed_targets="\
android
com.android.vending!
com.google.android.gsf!
com.google.android.gms!
io.github.vvb2060.keyattestation!
io.github.vvb2060.mahoshojo!
com.google.android.contactkeys!
com.google.android.ims!
com.google.android.safetycore!
com.google.android.apps.walletnfcrel!
com.google.android.apps.nbu.paisa.user!
gr.nikolasspyr.integritycheck!
com.youhu.laifu!
com.whatsapp!
com.whatsapp.w4b!
com.openai.chatgpt!
com.reveny.nativecheck!
icu.nullptr.nativetest!
com.android.nativetest!
io.liankong.riskdetector!
me.garfieldhan.holmes!
luna.safe.luna!
com.zhenxi.hunter!
com.studio.duckdetector!"
for entry in $fixed_targets; do
    if ! echo "$entry" >> "$t"; then
        log_message "ERROR: Failed to write $entry to $t"
        exit 1
    fi
done

# add list
log_message "Writing"

add_packages() {
    pkgs=$(pm list packages "$1" 2>/dev/null)
    if [ $? -ne 0 ] || [ -z "$pkgs" ]; then
        log_message "ERROR: Failed to list packages with flag $1"
        exit 1
    fi

    echo "$pkgs" | cut -d ":" -f 2 | while read -r pkg; do
        if [ -n "$pkg" ] && ! grep -q "^$pkg" "$t"; then
            if [ "$teeBroken" = "true" ]; then
                if ! echo "$pkg!" >> "$t"; then
                    log_message "ERROR: Failed to write $pkg! to $t"
                    exit 1
                fi
            else
                if ! echo "$pkg" >> "$t"; then
                    log_message "ERROR: Failed to write $pkg to $t"
                    exit 1
                fi
            fi
        fi
    done
}

# add user apps
add_packages "-3"

# add system apps
add_packages "-s"

log_message "Finish"
