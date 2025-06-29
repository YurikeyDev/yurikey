#!/system/bin/sh
log_message() {
    echo "$(date +%Y-%m-%d\ %H:%M:%S) [SET_SECURITY_PATCH] $1"
}
log_message "Start"
sp="/data/adb/tricky_store/security_patch.txt"
log_message "Counting"
current_year=$(date +%Y)
current_month=$(date +%#m) 

if [ "$current_month" -eq 1 ]; then
  prev_month=12
  prev_year=$((current_year - 1))
else
  prev_month=$((current_month - 1))
  prev_year=$current_year
fi
log_message "Writing"
formatted_month=$(printf "%02d" $prev_month)
echo "all=${prev_year}-${formatted_month}-05" > "$sp"
log_message "Finish"
