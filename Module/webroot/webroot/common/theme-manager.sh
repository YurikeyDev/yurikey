#!/system/bin/sh

if [ -d "/data/adb/modules_update/Yurikey" ]; then
  BASE_PATH="/data/adb/modules_update/Yurikey"
else
  BASE_PATH="/data/adb/modules/Yurikey"
fi

THEME_CONFIG_PATH="$BASE_PATH/webroot/json/theme-config.json"
THEME_PARAM="$1"

save_theme() {
  local theme_name="$1"

  if [ -z "$theme_name" ]; then
    echo "Error: Theme name is required"
    exit 1
  fi

  if [ ! -f "$THEME_CONFIG_PATH" ]; then
    echo "Error: Theme config file not found at $THEME_CONFIG_PATH"
    exit 1
  fi

  cp "$THEME_CONFIG_PATH" "$THEME_CONFIG_PATH.backup"

  TEMP_CONFIG="/tmp/yurikey-theme-config-temp.json"
  sed "s/\"selected_theme\": \"[^\"]*\"/\"selected_theme\": \"$theme_name\"/" "$THEME_CONFIG_PATH" > "$TEMP_CONFIG"

  if grep -q "selected_theme" "$TEMP_CONFIG" && grep -q "themes" "$TEMP_CONFIG"; then
    mv "$TEMP_CONFIG" "$THEME_CONFIG_PATH"
    chmod 644 "$THEME_CONFIG_PATH"
    echo "Theme '$theme_name' saved"
  else
    echo "Error: Failed to update theme config"
    rm -f "$TEMP_CONFIG"
    exit 1
  fi
}

get_theme() {
  if [ -f "$THEME_CONFIG_PATH" ]; then
    grep "selected_theme" "$THEME_CONFIG_PATH" | sed 's/.*"selected_theme": *"\([^"]*\)".*/\1/' | head -1
  else
    echo "dark-blue"
  fi
}

case "$THEME_PARAM" in
  "get")
    get_theme
    ;;
  "save")
    if [ -z "$2" ]; then
      echo "Error: Theme name required for save operation"
      exit 1
    fi
    save_theme "$2"
    ;;
  *)
    echo "Usage: $0 {get|save} [theme_name]"
    echo "  get - Get the current theme"
    echo "  save [theme_name] - Save the selected theme"
    exit 1
    ;;
esac