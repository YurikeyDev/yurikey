#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_SECURITY_PATCH] $1"
}

log_message "Start"

sp="/data/adb/tricky_store/security_patch.txt"

current_year=$(date +%Y)
if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to get current year"
    exit 1
fi

current_month=$(date +%m | sed 's/^0*//')
if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to get current month"
    exit 1
fi

if [ "$current_month" -eq 1 ]; then
    prev_month=12
    prev_year=$((current_year - 1))
else
    prev_month=$((current_month - 1))
    prev_year=$current_year
fi

log_message "Writing"

formatted_month=$(printf "%02d" $prev_month)
if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to format previous month"
    exit 1
fi

if ! echo "all=${prev_year}-${formatted_month}-05" > "$sp"; then
    log_message "ERROR: Failed to write to $sp"
    exit 1
fi

log_message "Finish"