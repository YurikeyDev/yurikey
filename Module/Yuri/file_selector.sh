#!/system/bin/sh
#!/system/bin/sh

TRICKY_DIR="/data/adb/tricky_store/keybox.xml"

cmd="$1"
arg="$2"

case "$cmd" in
  list)
    DIR="$arg"
    [ -z "$DIR" ] && DIR="/sdcard"
    [ ! -d "$DIR" ] && exit 1

    for f in "$DIR"/*; do
      [ -e "$f" ] || continue
      [ -d "$f" ] && echo "D|$f" || echo "F|$f"
    done
    ;;
  copy)
    SRC="$arg"
    mkdir -p "$(dirname "$TRICKY_DIR")"
    cp -f "$SRC" "$TRICKY_DIR" && chmod 644 "$TRICKY_DIR"
    echo OK
    ;;
esac
