# tryigitx
# shellcheck shell=sh

MODVER=$(grep_prop version $MODPATH/module.prop)

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

# Optimization based on SoC features
ui_print " "
ui_print "- Optimizing script execution..."

RC_FILE="$MODPATH/system/etc/init/battery_tweaks.rc"

if [ ! -e "/sys/module/printk/parameters/console_suspend" ]; then
    ui_print "  Disabling console_suspend write (feature missing)"
    sed -i 's|^    write /sys/module/printk/parameters/console_suspend|    # write /sys/module/printk/parameters/console_suspend|' "$RC_FILE"
fi

if [ ! -e "/sys/module/msm_show_resume_irq/parameters/debug_mask" ]; then
    ui_print "  Disabling msm_show_resume_irq write (feature missing)"
    sed -i 's|^    write /sys/module/msm_show_resume_irq/parameters/debug_mask|    # write /sys/module/msm_show_resume_irq/parameters/debug_mask|' "$RC_FILE"
fi

ui_print " "
ui_print " "
ui_print " - Done, please reboot system"
