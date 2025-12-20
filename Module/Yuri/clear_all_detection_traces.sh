#!/system/bin/sh

# detector data
rm -rf /storage/emulated/0/Android/data/me.garfieldhan.holmes
rm -rf /storage/emulated/0/Android/data/com.zhenxi.hunter
rm -rf /storage/emulated/0/Android/data/icu.nullptr.nativetest
rm -rf /storage/emulated/0/Android/data/com.byyoung.setting
rm -rf /storage/emulated/0/Android/data/bin.mt.plus
rm -rf /storage/emulated/0/Android/data/bin.mt.plus.canary
rm -rf /storage/emulated/0/Android/data/com.omarea.vtools
rm -rf /storage/emulated/0/Android/data/moe.shizuku.privileged.api
rm -rf /storage/emulated/0/Android/data/io.github.vvb2060.mahoshojo
rm -rf /storage/emulated/0/Android/data/icu.nullptr.applistdetector
rm -rf /storage/emulated/0/Android/data/com.byxiaorun.detector
rm -rf /storage/emulated/0/Android/data/io.github.huskydg.memorydetector
rm -rf /storage/emulated/0/Android/data/com.OrangeEnvironment.Detector
rm -rf /storage/emulated/0/Android/data/com.Longze.detector.pro2
rm -rf /storage/emulated/0/Android/data/rikka.safetynetchecker
rm -rf /storage/emulated/0/Android/data/io.github.vvb2060.keyattestation
rm -rf /storage/emulated/0/Android/data/com.estrongs.android.pop
rm -rf /storage/emulated/0/Android/data/com.lingqing.detector
rm -rf /storage/emulated/0/Android/data/aidepro.top
rm -rf /storage/emulated/0/Android/data/com.junge.algorithmAidePro
rm -rf /storage/emulated/0/Android/data/chunqiu.safe
rm -rf /storage/emulated/0/Android/data/luna.safe.luna
rm -rf /storage/emulated/0/Android/data/io.liankong.riskdetector
rm -rf /storage/emulated/0/Android/data/com.studio.duckdetector
rm -rf /storage/emulated/0/Android/obb/io.github.vvb2060.mahoshojo
rm -rf /storage/emulated/0/Android/obb/icu.nullptr.applistdetector
rm -rf /storage/emulated/0/Android/obb/com.byxiaorun.detector
rm -rf /storage/emulated/0/Android/obb/io.github.huskydg.memorydetector
rm -rf /storage/emulated/0/Android/obb/com.OrangeEnvironment.Detector
rm -rf /storage/emulated/0/Android/obb/com.Longze.detector.pro2
rm -rf /storage/emulated/0/Android/obb/rikka.safetynetchecker
rm -rf /storage/emulated/0/Android/obb/io.github.vvb2060.keyattestation
rm -rf /storage/emulated/0/Android/obb/com.android.nativetest
rm -rf /storage/emulated/0/Android/media/io.github.vvb2060.mahoshojo
rm -rf /storage/emulated/0/Android/media/icu.nullptr.applistdetector
rm -rf /storage/emulated/0/Android/media/com.byxiaorun.detector
rm -rf /storage/emulated/0/Android/media/io.github.huskydg.memorydetector
rm -rf /storage/emulated/0/Android/media/com.OrangeEnvironment.Detector
rm -rf /storage/emulated/0/Android/media/com.Longze.detector.pro2
rm -rf /storage/emulated/0/Android/media/rikka.safetynetchecker
rm -rf /storage/emulated/0/Android/media/io.github.vvb2060.keyattestation
# temp, sus file
rm -rf /data/property
rm -rf /data/property/persistent_properties
rm -rf /data/local/tmp/*
rm -rf /data/local/tmp/byyang
rm -rf /data/local/tmp/shizuku
rm -rf /data/local/tmp/shizuku_starter
rm -rf /data/local/tmp/HyperCeiler
rm -rf /data/local/tmp/luckys
rm -rf /data/local/tmp/input_devices
rm -rf /data/local/tmp/resetprop

# cache, lsposed module
rm -rf /data/system/graphicsstats
rm -rf /data/system/package_cache
rm -rf /data/system/NoActive
rm -rf /data/system/Freezer
rm -rf /data/system/junge
#scene
rm -rf /dev/memcg/scene_idle
rm -rf /dev/memcg/scene_active
rm -rf /dev/scene
rm -rf /dev/cpuset/scene-daemon

#sus folders/files generate by sus app
rm -rf /storage/emulated/0/WechatXposed
rm -rf /storage/emulated/0/Download/WechatXposed
rm -rf /storage/emulated/0/bin.mt.termux
rm -rf /storage/emulated/0/com.termux
rm -rf /storage/emulated/0/MT2
rm -rf /storage/emulated/0/rlgg
rm -rf /storage/emulated/0/xzr.hkf
rm -rf /storage/emulated/0/Android/naki
rm -rf /storage/emulated/legacy
rm -rf "/storage/emulated/0/最新版隐藏配置.json"

#reset prop (clean sus props)
resetprop sys.usb.adb.disabled 0
resetprop ro.boot.avb_version 1.2
resetprop ro.boot.vbmeta.avb_version 1.2
resetprop ro.boot.vbmeta.size 19968
resetprop ro.boot.vbmeta.digest d74bf68ce680f1f84679d10f25f07dbe92274a3f45c28dc061a6ae49a9b18ec4
resetprop ro.debuggable 0
resetprop ro.secure 1
resetprop ro.adb.secure 1

resetprop --delete persist.service.adb.enable
resetprop --delete persist.service.debuggable
resetprop --delete persist.zygote.app_data_isolation
resetprop --delete persist.hyperceiler.log.level

# Clean odex
su -c 'find /data/app -type f -name base.odex -delete' #U can remove the lsposed fix function in the web UI.

echo ""
echo "t.me/yuriiroot"
