# tryigitx
# shellcheck shell=sh

MODVER=$(grep_prop version "$MODPATH"/module.prop)

ui_print "
 Version: $MODVER
 Telegram: t.me/cleverestech

- Android version check..."

# Validate API
case "$API" in
  ""|*[!0-9]*)
    ui_print "
❗ Unable to detect a valid Android version."
    abort " "
    ;;
esac

# Error on < Android 11.
if [ "$API" -lt 28 ]; then
    ui_print "
❗ You can't use this module on Android < 9"
    abort " "
fi

# Optimization based on SoC features
ui_print "
- Optimizing script execution..."

RC_FILE="$MODPATH/system/etc/init/battery_tweaks.rc"

disable_missing_feature() {
    feature_name="$1"
    sysfs_path="$2"
    if [ ! -e "$sysfs_path" ]; then
        ui_print "  Disabling $feature_name write (feature missing)"
        sed -i "s|^\([[:space:]]*\)write[[:space:]][[:space:]]*$sysfs_path|\1# write $sysfs_path|" "$RC_FILE"
    fi
}

disable_missing_feature "console_suspend" "/sys/module/printk/parameters/console_suspend"
disable_missing_feature "msm_show_resume_irq" "/sys/module/msm_show_resume_irq/parameters/debug_mask"

ui_print "

 - Done, please reboot system"
