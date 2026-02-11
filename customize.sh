# tryigitx
# shellcheck shell=sh

ui_print " "
ui_print " Version: $MODVER"
ui_print " Telegram: t.me/cleverestech"
ui_print " "
ui_print "- Android version check..."
# Error on < Android 11.
if [ "$API" -lt 28 ]; then
    ui_print " "
    ui_print "❗ You can't use this module on Android < 9"
    abort " "
fi
ui_print " "
ui_print " "
ui_print " - Done, please reboot system"
