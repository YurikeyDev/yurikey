TMPDIR_FOR_VERIFY="$TMPDIR/.vunzip"
mkdir -p "$TMPDIR_FOR_VERIFY"

abort_verify() {
  ui_print "*********************************************************"
  ui_print "! $1"
  ui_print "! This zip may be corrupted, please try downloading again"
  abort    "*********************************************************"
}

file="META-INF/com/google/android/update-binary"
file_path="$TMPDIR_FOR_VERIFY/$file"
hash_path="$file_path.sha256"
unzip -o "$ZIPFILE" "META-INF/com/google/android/*" -d "$TMPDIR_FOR_VERIFY" >&2
[ -f "$file_path" ] || abort_verify "$file not exists"
if [ -f "$hash_path" ]; then
  (echo "$(cat "$hash_path")  $file_path" | sha256sum -c -s -) || abort_verify "Failed to verify $file"
  ui_print "- Verified update-binary"
else
  ui_print "- Download from Magisk app"
fi

ui_print "- Verifying all files in the zip..."

for hash_file in $(unzip -l "$ZIPFILE" | awk '{print $4}' | grep '\.sha256$'); do
  orig_file="${hash_file%.sha256}"

  unzip -o "$ZIPFILE" "$orig_file" -d "$TMPDIR_FOR_VERIFY" >&2 || abort_verify "File $orig_file not exists"
  unzip -o "$ZIPFILE" "$hash_file" -d "$TMPDIR_FOR_VERIFY" >&2 || abort_verify "Hash $hash_file not exists"

  file_path="$TMPDIR_FOR_VERIFY/$orig_file"
  hash_path="$TMPDIR_FOR_VERIFY/$hash_file"

  [ -f "$file_path" ] || abort_verify "$orig_file not exists after unzip"
  [ -f "$hash_path" ] || abort_verify "$hash_file not exists after unzip"

  # SHA256 doğrulama
  (echo "$(cat "$hash_path")  $file_path" | sha256sum -c -s -) || abort_verify "Failed to verify $orig_file"
done

ui_print "- All files verified successfully"