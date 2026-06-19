#!/system/bin/sh

# Function to check and reset property if it doesn't match the expected value
check_reset_prop() {
  local NAME=$1
  local EXPECTED=$2
  local VALUE=$(resetprop $NAME)
  [ -z $VALUE ] || [ $VALUE = $EXPECTED ] || resetprop -n $NAME $EXPECTED
}

# Function to check if a property contains a specific string and reset it
contains_reset_prop() {
  local NAME=$1
  local CONTAINS=$2
  local NEWVAL=$3
  [[ "$(resetprop $NAME)" = *"$CONTAINS"* ]] && resetprop -n $NAME $NEWVAL
}

# Wait for boot completion before applying changes
resetprop -w sys.boot_completed 0

# Bootloader and Verified Boot properties
check_reset_prop "ro.boot.vbmeta.device_state" "locked"
check_reset_prop "ro.boot.verifiedbootstate" "green"
check_reset_prop "ro.boot.flash.locked" "1"
check_reset_prop "ro.boot.veritymode" "enforcing"
check_reset_prop "ro.boot.warranty_bit" "0"
check_reset_prop "ro.warranty_bit" "0"
check_reset_prop "ro.debuggable" "0"
check_reset_prop "ro.force.debuggable" "0"
check_reset_prop "ro.secure" "1"
check_reset_prop "ro.adb.secure" "1"
check_reset_prop "ro.build.type" "user"
check_reset_prop "ro.build.tags" "release-keys"
check_reset_prop "ro.vendor.boot.warranty_bit" "0"
check_reset_prop "ro.vendor.warranty_bit" "0"
check_reset_prop "vendor.boot.vbmeta.device_state" "locked"
check_reset_prop "vendor.boot.verifiedbootstate" "green"
check_reset_prop "sys.oem_unlock_allowed" "0"

# MIUI specific properties
check_reset_prop "ro.secureboot.lockstate" "locked"

# Realme specific properties
check_reset_prop "ro.boot.realmebootstate" "green"
check_reset_prop "ro.boot.realme.lockstate" "1"

# Hide that we booted from recovery when magisk is in recovery mode
contains_reset_prop "ro.bootmode" "recovery" "unknown"
contains_reset_prop "ro.boot.bootmode" "recovery" "unknown"
contains_reset_prop "vendor.boot.bootmode" "recovery" "unknown"


# Partition verification (Hide warnings)
check_reset_prop "partition.system.verified" "0"
check_reset_prop "partition.vendor.verified" "0"
check_reset_prop "partition.product.verified" "0"
check_reset_prop "partition.system_ext.verified" "0"
check_reset_prop "partition.odm.verified" "0"

# OEM Unlock status
check_reset_prop "ro.oem_unlock_supported" "0"

# USB / ADB settings
check_reset_prop "persist.sys.usb.config" "none"
check_reset_prop "service.adb.root" "0"

# Boot / Verification status
check_reset_prop "ro.boot.selinux" "enforcing"
check_reset_prop "ro.boot.avb_version" "1.3"
check_reset_prop "ro.crypto.state" "encrypted"