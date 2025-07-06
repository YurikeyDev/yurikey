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
fi

# add list special
echo "android" >> "$t"
echo "com.android.vending!" >> "$t"
echo "com.google.android.gsf!" >> "$t"
echo "com.google.android.gms!" >> "$t"
echo "com.google.android.apps.walletnfcrel" >> "$t"
echo "com.openai.chatgpt!" >> "$t"
echo "com.reveny.nativecheck!" >> "$t"
echo "io.github.vvb2060.keyattestation!" >> "$t"
echo "io.github.vvb2060.mahoshojo!" >> "$t"
echo "icu.nullptr.nativetest!" >> "$t"
echo "com.android.nativetest!" >> "$t"
echo "io.liankong.riskdetector!" >> "$t"
echo "me.garfieldhan.holmes!" >> "$t"
echo "luna.safe.luna!" >> "$t"
echo "com.zhenxi.hunter!" >> "$t"
echo "gr.nikolasspyr.integritycheck!" >> "$t"
echo "com.youhu.laifu!" >> "$t"
echo "com.google.android.contactkeys!" >> "$t"
echo "om.google.android.ims!" >> "$t"
echo "com.google.android.safetycore!"  >> "$t"
echo "com.whatsapp!"  >> "$t"
echo "com.whatsapp.w4b!"  >> "$t"


# add list
log_message "Writing"
add_packages() {
    pm list packages "$1" | cut -d ":" -f 2 | while read -r pkg; do
        if [ -n "$pkg" ] && ! grep -q "^$pkg" "$t"; then
            if [ "$teeBroken" = "true" ]; then
                echo "$pkg!" >> "$t"
            else
                echo "$pkg" >> "$t"
            fi
        fi
    done
}

# add user apps
add_packages "-3"

# add system apps
add_packages "-s"
log_message "Finish"