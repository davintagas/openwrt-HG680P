#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

sed -i 's/^8e3a1824645f5e73ec44c897ac0755c53fb4a1f8/;openwrt-23.05/g' feeds.conf.default
sed -i 's/^7739e9f5b03b830f51d53c384be4baef95054cb3/;openwrt-23.05/g' feeds.conf.default
sed -i 's/^83ef3784a9092cfd0a900cc28e2ed4e13671d667/;openwrt-23.05/g' feeds.conf.default
sed -i 's/^9746ae8f964e18f04b64fbe1956366954ff223f8/;openwrt-23.05/g' feeds.conf.default
# other
# rm -rf package/utils/{ucode,fbtest}

