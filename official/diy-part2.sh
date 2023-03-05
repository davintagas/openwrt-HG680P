#!/bin/bash
#========================================================================================================================
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata}

# Change dnsmasq
rm -rf package/network/services/dnsmasq
svn co https://github.com/openwrt/openwrt/trunk/package/network/services/dnsmasq package/network/services/dnsmasq
rm -rf package/libs/libubox
svn co https://github.com/openwrt/openwrt/trunk/package/libs/libubox package/libs/libubox
rm -rf package/system/ubus
svn co https://github.com/openwrt/openwrt/trunk/package/system/ubus package/system/ubus

# change luci-base
rm -rf feeds/luci/modules/{luci-base,luci-mod-status}
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-base,luci-mod-status} feeds/luci/modules/

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add modeminfo
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-modeminfo,modeminfo,telegrambot} package/

# Add atinout
svn co https://github.com/kiddin9/openwrt-packages/trunk/{atinout,luci-app-atinout} package/

# Add ramfree
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/luci-app-ramfree

# Add internet-detector
svn co https://github.com/gSpotx2f/luci-app-internet-detector/trunk/{luci-app-internet-detector,internet-detector} package/

# Add autocore
svn co https://github.com/kiddin9/openwrt-packages/trunk/{autocore,mhz} package/

# Add luci-app-adguardhome
git clone --depth 1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

# Add tinyfilemanager
git clone --depth 1 https://github.com/davintagas/luci-app-tinyfilemanager.git package/luci-app-tinyfilemanager

# Add luci-app-diskman
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-diskman package/luci-app-diskman

# Add theme
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-theme-argon,luci-theme-edge,luci-app-argon-config} package/

# Add passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall

# passwall-package
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/{dns2socks,dns2tcp,microsocks,tcping,brook,chinadns-ng,hysteria,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,trojan-plus,v2ray-core,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin} package/

# Add timezone
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/99-init-settings.sh
popd
