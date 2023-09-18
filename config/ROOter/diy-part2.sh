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
# sed -i 's/uqmi/rqmi/g' feeds/luci/protocols/luci-proto-qmi/Makefile
# sed -i 's/umbim/rmbim/g' feeds/luci/protocols/luci-proto-mbim/Makefile

# Add atinout
svn co https://github.com/kiddin9/openwrt-packages/trunk/atinout package/atinout

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add internet-detector
svn co https://github.com/gSpotx2f/luci-app-internet-detector/trunk/{luci-app-internet-detector,internet-detector} package/

# Add ramfree
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/luci-app-ramfree

# Add adguardhome
# rm -rf feeds/packages/net/adguardhome
# svn co https://github.com/kiddin9/openwrt-packages/trunk/adguardhome feeds/packages/net/adguardhome
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-adguardhome package/luci-app-adguardhome

# Add theme design
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-theme-design package/luci-theme-design

sed -i 's|/cgi-bin/luci/admin/status/overview|/cgi-bin/luci/admin/status/release_ram|g' package/luci-theme-design/luasrc/view/themes/design/header.htm
sed -i 's|/cgi-bin/luci/admin/services/openclash|/cgi-bin/luci/admin/modem/nets|g' package/luci-theme-design/luasrc/view/themes/design/header.htm
sed -i 's|/cgi-bin/luci/admin/status/realtime|/cgi-bin/luci/admin/modem/modlog|g' package/luci-theme-design/luasrc/view/themes/design/header.htm
sed -i 's|/cgi-bin/luci/admin/system/admin|/cgi-bin/luci/admin/modem/sms|g' package/luci-theme-design/luasrc/view/themes/design/header.htm

# Add default setting
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/rooter/99-init-settings.sh
popd

#
# ------------------------------- Other ends -------------------------------
