#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# Add patch
svn co https://github.com/kiddin9/openwrt-packages/trunk/firewall/patches package/network/config/firewall/patches

# Add turboacc
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-turboacc,shortcut-fe,pdnsd-alt,dnsforwarder,dnsproxy,luci-app-fullconenat,fullconenat} package/

# svn co https://github.com/openwrt/packages/branches/openwrt-22.03/utils/parted package/parted
svn co https://github.com/openwrt/openwrt/branches/openwrt-21.02/package/utils/dtc package/dtc

# Change luci base && status
rm -rf feeds/luci/modules/{luci-base,luci-mod-status}
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-base feeds/luci/modules/luci-base
svn co https://github.com/immortalwrt/luci/branches/openwrt-21.02/modules/luci-mod-status feeds/luci/modules/luci-mod-status

# Add diskman
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-diskman package/luci-app-diskman

# Add tinyfilemanager
svn co https://github.com/lynxnexy/packages/trunk/luci-app-tinyfilemanager package/luci-app-tinyfilemanager

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add atinout
svn co https://github.com/kiddin9/openwrt-packages/trunk/atinout package/atinout

# Add ethstatus
svn co https://github.com/kiddin9/openwrt-packages/trunk/{autocore,ethstatus,mhz} package/

# Add ramfree
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/luci-app-ramfree

# Add luci-app-adguardhome
git clone --depth 1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

# Add eqos
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos

# Add ssr-plus && passwall
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall

# Add passwal-package
rm -rf feeds/packages/net/xray-core
svn co https://github.com/kiddin9/openwrt-packages/trunk/{xray-core,lua-neturl,sagernet-core,ipt2socks,redsocks2,trojan,brook,dns2socks,dns2tcp,microsocks,tcping,chinadns-ng,hysteria,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,trojan-go,trojan-plus,v2ray-core,v2ray-plugin,xray-plugin,v2ray-geodata} package/passwall-package

# Change Golang
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/trunk/lang/golang feeds/packages/lang/golang

# Change dep qmi
sed -i 's/uqmi/rqmi/g' feeds/luci/protocols/luci-proto-qmi/Makefile

# Change python
rm -rf feeds/packages/lang/python/python-cryptography
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/python/python-cryptography feeds/packages/lang/python/python-cryptography

# Add default setting
# mkdir -p files/etc/uci-defaults
# pushd files/etc/uci-defaults
# wget https://raw.githubusercontent.com/davintagas/default/main/99-init-settings.sh
# popd
