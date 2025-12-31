#!/system/bin/sh

banner() {
    clear
    printf "\033[41m                                               \033[0m\n"
    printf "\033[41m                                               \033[0m\n"
    printf "\033[41m(One-click to clear all detection traces)\033[0m\n"
    printf "\033[41m                                               \033[0m\n"
    printf "\033[41m                                               \033[0m\n"
    sleep 3
    clear
}

progress() {
    printf "\033[31m[1/5] Clearing detector application data...\033[0m\n"
    sleep 0.5
    printf "\033[31m[2/5] Clearing file cache tool app (MT Manager, HyperCeiler, LuckyTool,....)\033[0m\n"
    sleep 0.5
    printf "\033[31m[3/5] Resetprop, reset system properties, clear custom rom,HMA paths...\033[0m\n"
    sleep 0.5
    printf "\033[31m[4/5] Clearing odex, art, cache Lsposed....\033[0m\n"
    sleep 0.5
    printf "\033[31m[5/5] Clearing...\033[0m\n"
    sleep 3
}

complete() {
    printf "\n"
    printf "\033[1;32mDone!\033[0m\n"
    printf "\033[1;32mt.me/yuriiroot\033[0m\n"
}


remove_path() {
    [ -n "$1" ] && rm -rf "$1" 2>/dev/null
}

detector_data() {   # For /storage/emulated/0/Android/data/* if exists
    remove_path "/storage/emulated/0/Android/data/me.garfieldhan.holmes"
    remove_path "/storage/emulated/0/Android/data/com.zhenxi.hunter"
    remove_path "/storage/emulated/0/Android/data/icu.nullptr.nativetest"
    remove_path "/storage/emulated/0/Android/data/icu.nullptr.applistdetector"
    remove_path "/storage/emulated/0/Android/data/com.byxiaorun.detector"
    remove_path "/storage/emulated/0/Android/data/io.github.huskydg.memorydetector"
    remove_path "/storage/emulated/0/Android/data/com.OrangeEnvironment.Detector"
    remove_path "/storage/emulated/0/Android/data/com.Longze.detector.pro2"
    remove_path "/storage/emulated/0/Android/data/rikka.safetynetchecker"
    remove_path "/storage/emulated/0/Android/data/io.github.vvb2060.keyattestation"
    remove_path "/storage/emulated/0/Android/data/io.github.vvb2060.mahoshojo"
    remove_path "/storage/emulated/0/Android/data/com.lingqing.detector"
    remove_path "/storage/emulated/0/Android/data/aidepro.top"
    remove_path "/storage/emulated/0/Android/data/com.junge.algorithmAidePro"
    remove_path "/storage/emulated/0/Android/data/chunqiu.safe"
    remove_path "/storage/emulated/0/Android/data/luna.safe.luna"
    remove_path "/storage/emulated/0/Android/data/io.liankong.riskdetector"
    remove_path "/storage/emulated/0/Android/data/com.studio.duckdetector"
    remove_path "/storage/emulated/0/Android/data/com.android.nativetest"
    remove_path "/storage/emulated/0/Android/data/com.byyoung.setting"
    remove_path "/storage/emulated/0/Android/data/com.scottyab.rootbeer"
    remove_path "/storage/emulated/0/Android/data/com.scottyab.rootbeer.sample"
    remove_path "/storage/emulated/0/Android/data/com.topjohnwu.magisk.detector"
    remove_path "/storage/emulated/0/Android/data/com.devadvance.rootcloak"
    remove_path "/storage/emulated/0/Android/data/com.fde.xposed.detector"
    remove_path "/storage/emulated/0/Android/data/com.zhenxi.checker"
    remove_path "/storage/emulated/0/Android/data/com.example.nativelibtest"
    remove_path "/storage/emulated/0/Android/data/com.example.memcheck"
    remove_path "/storage/emulated/0/Android/data/com.example.syscallchecker" 
    remove_path "/storage/emulated/0/Android/data/com.jrummyapps.rootchecker"
    remove_path "/storage/emulated/0/Android/data/com.kimchangyoun.magiskdetector"
    remove_path "/storage/emulated/0/Android/data/com.reveny.nativechecker"
    remove_path "/storage/emulated/0/Android/data/com.reveny.environmentchecker"
    remove_path "/storage/emulated/0/Android/data/com.reveny.rootchecker"
    remove_path "/storage/emulated/0/Android/data/com.guardian.detect"
    remove_path "/storage/emulated/0/Android/data/com.security.environmentchecker"
    remove_path "/storage/emulated/0/Android/data/com.integrity.checker"
    remove_path "/storage/emulated/0/Android/data/com.integrity.attestation"
    remove_path "/storage/emulated/0/Android/data/com.lody.virtual"
    remove_path "/storage/emulated/0/Android/data/com.lody.virtual.client"
    remove_path "/storage/emulated/0/Android/data/com.lody.virtual.server"
    remove_path "/storage/emulated/0/Android/data/com.lody.whale"
    remove_path "/storage/emulated/0/Android/data/com.kimchangyoun.rootbeerfresh"
    remove_path "/storage/emulated/0/Android/data/com.didikee.rootcheck"
    remove_path "/storage/emulated/0/Android/data/com.joeykrim.rootcheck"
    remove_path "/storage/emulated/0/Android/data/com.freeandroidtools.rootchecker"
    remove_path "/storage/emulated/0/Android/data/com.bluestacks.rootchecker"
    remove_path "/storage/emulated/0/Android/data/com.moonshine.checker"
    remove_path "/storage/emulated/0/Android/data/com.ramdroid.appdetector"
    remove_path "/storage/emulated/0/Android/data/com.smlj.rootcheck"
    remove_path "/storage/emulated/0/Android/data/com.devadvance.rootcloakplus"
    remove_path "/storage/emulated/0/Android/data/com.formyhm.hideroot"
    remove_path "/storage/emulated/0/Android/data/com.example.emulatordetector"
    remove_path "/storage/emulated/0/Android/data/com.vmcheck.detector"
    remove_path "/storage/emulated/0/Android/data/com.virtual.checker"
    remove_path "/storage/emulated/0/Android/data/com.antivm.detector"
    remove_path "/storage/emulated/0/Android/data/com.xposed.checker"
    remove_path "/storage/emulated/0/Android/data/com.google.snet.test"
    remove_path "/storage/emulated/0/Android/data/com.attestation.checker"
    remove_path "/storage/emulated/0/Android/data/com.integrity.check"
    remove_path "/storage/emulated/0/Android/data/com.native.checker"
    remove_path "/storage/emulated/0/Android/data/com.syscall.detector"
    remove_path "/storage/emulated/0/Android/data/com.memory.scan"
    remove_path "/storage/emulated/0/meow_detector.log"
    remove_path "/storage/emulated/0/keybox_status.json" 
    
}

detector_obb() { # Same as detector_data
    remove_path "/storage/emulated/0/Android/obb/io.github.vvb2060.mahoshojo"
    remove_path "/storage/emulated/0/Android/obb/icu.nullptr.applistdetector"
    remove_path "/storage/emulated/0/Android/obb/icu.nullptr.nativetest"
    remove_path "/storage/emulated/0/Android/obb/com.byxiaorun.detector"
    remove_path "/storage/emulated/0/Android/obb/io.github.huskydg.memorydetector"
    remove_path "/storage/emulated/0/Android/obb/com.OrangeEnvironment.Detector"
    remove_path "/storage/emulated/0/Android/obb/com.Longze.detector.pro2"
    remove_path "/storage/emulated/0/Android/obb/rikka.safetynetchecker"
    remove_path "/storage/emulated/0/Android/obb/io.github.vvb2060.keyattestation"
    remove_path "/storage/emulated/0/Android/obb/com.android.nativetest"
}

detector_media() { # Same as detector_data
    remove_path "/storage/emulated/0/Android/media/icu.nullptr.nativetest"
}

tool_apps_data() { # Same as detector_data, but for tool apps
    remove_path "/storage/emulated/0/Android/data/bin.mt.plus"
    remove_path "/storage/emulated/0/Android/data/bin.mt.plus.canary"
    remove_path "/storage/emulated/0/Android/data/com.omarea.vtools"
    remove_path "/storage/emulated/0/Android/data/moe.shizuku.privileged.api"
    remove_path "/storage/emulated/0/Android/data/com.estrongs.android.pop"
    remove_path "/storage/emulated/0/Android/data/com.coolapk.market"
    remove_path "/storage/emulated/0/MT2"
    remove_path "/storage/emulated/0/bin.mt.termux"
    remove_path "/storage/emulated/0/com.termux"
    remove_path "/storage/emulated/0/xzr.hkf"
    remove_path "/storage/emulated/0/Download/WechatXposed"
    remove_path "/storage/emulated/0/WechatXposed"
    remove_path "/storage/emulated/0/Android/naki"
    remove_path "/storage/emulated/0/最新版隐藏配置.json"
    remove_path "/storage/emulated/0/rlgg"
    remove_path "/storage/emulated/legacy"
    remove_path "/storage/emulated/com.luckyzyx.luckytool"
    remove_path "/storage/emulated/0/Android/data/com.sevtinge.hyperceiler"
    remove_path "/storage/emulated/0/Android/data/com.coderstory.toolkit"
}

remote_control_data_apps() { # Same as detector_data, but for remote control apps
    remove_path "/storage/emulated/0/.anydesk" 
    remove_path "/storage/emulated/0/Android/data/com.anydesk.anydeskandroid"
    remove_path "/storage/emulated/0/Android/data/com.teamviewer.teamviewer.market.mobile"
    remove_path "/storage/emulated/0/Android/data/com.teamviewer.quicksupport.market"
    remove_path "/storage/emulated/0/Android/data/com.sand.airdroid"
    remove_path "/storage/emulated/0/Android/data/com.sand.airmirror"
    remove_path "/storage/emulated/0/Android/data/com.koushikdutta.vysor"
    remove_path "/storage/emulated/0/Android/data/com.genymobile.scrcpy"
    remove_path "/storage/emulated/0/anydesk"
    remove_path "/storage/emulated/0/Android/data/com.microsoft.rdc.androidx"
    remove_path "/storage/emulated/0/Android/data/com.realvnc.viewer.android"
    remove_path "/storage/emulated/0/Android/data/com.splashtop.remote.pad.v2"
    remove_path "/storage/emulated/0/Android/data/com.dwservice.dwagent"
    remove_path "/storage/emulated/0/Android/data/com.carriez.flutter_hbb"
    remove_path "/storage/emulated/0/Android/data/com.carriez.flutter_hbbclient"
    remove_path "/storage/emulated/0/Android/data/com.rustdesk.rustdesk"
    remove_path "/storage/emulated/0/.rustdesk"
    remove_path "/storage/emulated/0/rustdesk"
    remove_path "/storage/emulated/0/Android/media/com.koushikdutta.vysor"
    remove_path "/storage/emulated/0/.vysor"
    remove_path "/storage/emulated/0/Vysor"
}

system_properties() { # For /data/property if exists
    remove_path "/data/property/persistent_properties"
    remove_path "/data/property"
}

tmp_data() {    # For /data/local/tmp if exists
    remove_path "/data/local/tmp/shizuku"
    remove_path "/data/local/tmp/shizuku_starter"
    remove_path "/data/local/tmp/byyang"
    remove_path "/data/local/tmp/HyperCeiler"
    remove_path "/data/local/tmp/luckys"
    remove_path "/data/local/tmp/input_devices"
    remove_path "/data/local/tmp/resetprop"

    rm -rf /data/local/tmp/* 2>/dev/null    # delete all on /data/local/tmp

    mkdir -p /data/local/tmp 2>/dev/null    # recreate, but this working?
}

system_data() { # For /data/system if exists
    remove_path "/data/system/graphicsstats"
    remove_path "/data/system/package_cache"
    remove_path "/data/system/NoActive"
    remove_path "/data/system/Freezer"
    remove_path "/data/system/junge"
    remove_path "/data/swap_config.conf"
}

dev_paths() { # For /dev
    remove_path "/dev/memcg/scene_idle"
    remove_path "/dev/memcg/scene_active"
    remove_path "/dev/scene"
    remove_path "/dev/cpuset/scene-daemon"
}

user_data() { # For /data/user/0
    remove_path "/data/user/0/com.juom"
}

reset_prop() { # Changing on build.prop file
    while [ "$(getprop sys.boot_completed)" != "1" ]; do
        sleep 1
    done
    # USB / ADB
    resetprop sys.usb.adb.disabled 1
    resetprop persist.sys.usb.config mtp
    resetprop sys.usb.config mtp
    resetprop sys.usb.state mtp
    resetprop service.adb.root 0
    resetprop service.adb.tcp.port -1
    resetprop --delete persist.service.adb.enable
    resetprop --delete persist.service.debuggable
    
    # Clear Detection HMA, Tools
    resetprop --delete persist.zygote.app_data_isolation
    resetprop --delete persist.hyperceiler.log.level
    resetprop --delete persist.com.luckyzyx.luckytool.log.level
    resetprop --delete persist.com.luckyzyx.luckytool.debug
    resetprop --delete persist.com.luckyzyx.luckytool.enable
    

    # Development mode
    resetprop persist.sys.developer_options 0
    resetprop persist.sys.dev_mode 0
    resetprop persist.sys.debuggable 0
    settings put global development_settings_enabled 0
    settings put global adb_enabled 0
    settings put global oem_unlock_allowed 0
    settings put global adb_enabled 0
    settings put global development_settings_enabled 0
    settings put global oem_unlock_allowed 0
    settings put global adb_wifi_enabled 0
    settings put global adb_wifi_port -1
    
    # Debug flags
    resetprop ro.debuggable 0
    resetprop ro.secure 1
    resetprop ro.adb.secure 1
    resetprop ro.build.type user
    resetprop ro.build.tags release-keys
    resetprop --delete persist.sys.developer_options
    resetprop --delete persist.sys.dev_mode
    
    # Boot / AVB 
    resetprop ro.boot.avb_version 1.2
    resetprop ro.boot.vbmeta.avb_version 1.2
    resetprop ro.boot.vbmeta.size 19968
    resetprop ro.boot.vbmeta.digest d74bf68ce680f1f84679d10f25f07dbe92274a3f45c28dc061a6ae49a9b18ec4

    resetprop ro.boot.verifiedbootstate green
    resetprop vendor.boot.verifiedbootstate green
    resetprop ro.boot.flash.locked 1
    resetprop ro.boot.vbmeta.device_state locked
    resetprop vendor.boot.vbmeta.device_state locked
    resetprop ro.secureboot.lockstate locked
    resetprop ro.boot.warranty_bit 0
    resetprop ro.boot.force_normal_boot 1
    resetprop ro.boot.realme.lockstate 1

    # OEM unlock
    resetprop ro.oem_unlock_supported 0
    resetprop sys.oem_unlock_allowed 0

    # SELinux (only fake if it is actually enforcing)
    if [ "$(getenforce 2>/dev/null)" = "Enforcing" ]; then
        resetprop ro.boot.selinux enforcing
        resetprop ro.build.selinux 1
    fi

    # Emulator traces
    resetprop ro.kernel.qemu 0
    resetprop ro.boot.qemu 0
    resetprop ro.hardware.virtual_device 0
}

odex_files() { # Delete all odex files
    su -c 'find /data/app -type f -name base.odex -delete' 2>/dev/null
}

main() {
    banner
    progress

    detector_data
    detector_obb
    detector_media
    tool_apps_data
    remote_control_data_apps
    system_properties
    tmp_data
    system_data
    dev_paths
    user_data
    reset_prop

    clear
    odex_files
    
    complete
}

main