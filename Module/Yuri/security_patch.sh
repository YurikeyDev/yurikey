#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_SECURITY_PATCH] $1"
}

log_message "Start"

sp="/data/adb/tricky_store/security_patch.txt"

# Get current year / month
current_year=$(date +%Y) || {
    log_message "ERROR: Failed to get current year"
    exit 1
}

current_month=$(date +%m | sed 's/^0*//') || {
    log_message "ERROR: Failed to get current month"
    exit 1
}

# Calculate previous month
if [ "$current_month" -eq 1 ]; then
    prev_month=12
    prev_year=$((current_year - 1))
else
    prev_month=$((current_month - 1))
    prev_year=$current_year
fi

formatted_month=$(printf "%02d" "$prev_month") || {
    log_message "ERROR: Failed to format month"
    exit 1
}

patch_date="${prev_year}-${formatted_month}-05"

log_message "Writing"

# Write correct Trickystore format
cat > "$sp" <<EOF
system=prop
boot=$patch_date
vendor=$patch_date
EOF

if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to write $sp"
    exit 1
fi

log_message "Finish"