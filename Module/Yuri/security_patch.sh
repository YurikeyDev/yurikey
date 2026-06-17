#!/system/bin/sh

log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_SECURITY_PATCH] $1"
}

log_message "Start"

sp="/data/adb/tricky_store/security_patch.txt"

# Get current year / month / day
current_year=$(date +%Y) || {
    log_message "Error: Failed to get current year"
    exit 1
}

current_month=$(date +%m | sed 's/^0*//') || {
    log_message "Error: Failed to get current month"
    exit 1
}

current_day=$(date +%d | sed 's/^0*//') || {
    log_message "Error: Failed to get current day"
    exit 1
}

# Logic: Security Patch drop on the 5th. 
if [ "$current_day" -lt 10 ]; then
  # Before the 5th: Use previous month
  if [ "$current_month" -eq 1 ]; then
    target_month=12
    target_year=$((current_year - 1))
  else
    target_month=$((current_month - 1))
    target_year=$current_year
  fi
else
  # On or after the 10th: Use current month
  target_month=$current_month
  target_year=$current_year
fi

# Format the target month to always have two digits (e.g., 03)
formatted_month=$(printf "%02d" "$target_month") || {
  log_message "Error: Failed to format month"
  exit 1
}

patch_date="${target_year}-${formatted_month}-05"

log_message "Writing"

# Write correct Trickystore format
cat > "$sp" <<EOF
system=prop
boot=$patch_date
vendor=$patch_date
EOF

if [ $? -ne 0 ]; then
    log_message "Error: Failed to write $sp"
    exit 1
fi

log_message "Finish"
