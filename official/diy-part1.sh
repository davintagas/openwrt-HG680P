#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: master
#========================================================================================================================

# Uncomment a feed source
# sed -i 's/#src-git helloworld/src-git helloworld/g' ./feeds.conf.default
# sed -i 's/\"#src-git\"/\"src-git\"/g' feeds.conf.default

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
sed  -i 's/^dba8a0102e5965cad58a871335002e9c964b6719/;openwrt-22.03/g' feeds.conf.default
sed  -i 's/^96ec0cd3ccfe954f13fd5a337efdd70374dde03f/;openwrt-22.03/g' feeds.conf.default
sed  -i 's/^85028704f688a6768d3f10d5d3c10a799a121e0d/;openwrt-22.03/g' feeds.conf.default
sed  -i 's/^1d2031a5c82816483c51bca15649e2957fbe2bc2/;openwrt-22.03/g' feeds.conf.default

# other
# rm -rf package/lean/{samba4,luci-app-samba4,luci-app-ttyd}
