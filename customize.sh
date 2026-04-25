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


if [ ! -e "/sys/module/msm_show_resume_irq/parameters/debug_mask" ]; then
    ui_print "  Disabling msm_show_resume_irq write (feature missing)"
    sed -i 's|^\([[:space:]]*\)write[[:space:]][[:space:]]*/sys/module/msm_show_resume_irq/parameters/debug_mask|\1# write /sys/module/msm_show_resume_irq/parameters/debug_mask|' "$RC_FILE"
fi

ui_print "

 - Done, please reboot system"
