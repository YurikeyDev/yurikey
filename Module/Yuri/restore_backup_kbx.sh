#!/system/bin/sh

TSDIR="/data/adb/tricky_store"
BACKUP="$TSDIR/keybox.xml.bak"
RESTORELOC="$TSDIR/keybox.xml"

log_message() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [YURIKEY] $1"
}

if [ -f "$BACKUP" ]; then
  cp "$BACKUP" "$RESTORELOC"
  log_message "Backup keybox.xml restored successfully."
else
  log_message "No backup found for keybox.xml."
fi