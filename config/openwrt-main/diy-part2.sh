#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add driver l860-gl
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-proto-xmm,xmm-modem} package/

# Add Modeminfo
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-modeminfo,modeminfo} package/

# Add atinout
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-atinout,atinout} package/

# Add sms
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-sms-tool,sms-tool} package/

# Add modemband
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-modemband,modemband,telegrambot} package/

# Add adguardhome
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/luci-app-adguardhome

# Add passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall-package
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall

# Add ramfree
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/luci-app-ramfree

# Change luci-base & status
rm -rf feeds/luci/modules/{luci-base,luci-mod-status}
svn co https://github.com/immortalwrt/luci/branches/openwrt-23.05/modules/{luci-base,luci-mod-status} feeds/luci/modules/
svn co https://github.com/kiddin9/openwrt-packages/trunk/autocore package/autocore

# Add internet-detector
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-internet-detector/{luci-app-internet-detector,internet-detector} package/

# Set timezone
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/official/99-init-settings.sh
popd

