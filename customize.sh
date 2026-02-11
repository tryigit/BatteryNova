# tryigitx
# shellcheck shell=sh

MODVER=$(grep_prop version "$MODPATH"/module.prop)

ui_print " "
ui_print " Version: $MODVER"
ui_print " Telegram: t.me/cleverestech"
ui_print " "
ui_print "- Android version check..."

# Validate API
case "$API" in
  ""|*[!0-9]*)
    ui_print " "
    ui_print "❗ Unable to detect a valid Android version."
    abort " "
    ;;
esac

# Error on < Android 11.
if [ "$API" -lt 28 ]; then
    ui_print " "
    ui_print "❗ You can't use this module on Android < 9"
    abort " "
fi

ui_print "- Setting permissions"
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH"/post-fs-data.sh 0 0 0755

ui_print " "
ui_print " - Done, please reboot system"
