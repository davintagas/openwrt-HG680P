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
#
rm -rf feeds/packages/net/{trojan-go,v2ray-core,v2ray-geodata}

# Change libnftnl
rm -rf package/libs/libnftnl
svn co https://github.com/kiddin9/openwrt-packages/trunk/libnftnl package/libs/libnftnl

# Change dnsmasq
rm -rf package/network/services/dnsmasq
svn co https://github.com/kiddin9/openwrt-packages/trunk/dnsmasq package/network/services/dnsmasq

# Change Firewall
rm -rf package/network/config/{firewall4,firewall,netifd}
svn co https://github.com/kiddin9/openwrt-packages/trunk/{firewall4,firewall,netifd} package/network/config/

# Change nftable
rm -rf package/network/utils/nftables
svn co https://github.com/kiddin9/openwrt-packages/trunk/nftables package/network/utils/nftables

# Add fullconenat
svn co https://github.com/kiddin9/openwrt-packages/trunk/{fullconenat,nft-fullcone} package/

# Add turboacc
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-turboacc,shortcut-fe,pdnsd-alt,dnsforwarder,dnsproxy} package/

# Change luci-app-firewall
rm -rf feeds/luci/applications/luci-app-firewall
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-firewall feeds/luci/applications/luci-app-firewall

# Change luci-base
rm -rf feeds/luci/modules/{luci-base,luci-mod-status}
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-base,luci-mod-status} feeds/luci/modules/

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add tinyfilemanager
git clone --depth 1 https://github.com/davintagas/luci-app-tinyfilemanager.git package/luci-app-tinyfilemanager

# Add filebrowser
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-filebrowser,filebrowser} package/

# Add atinout
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-atinout,atinout} package/

# Add modeminfo
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-modeminfo,modeminfo,telegrambot} package/

# Add driver l860-gl
svn co https://github.com/kiddin9/openwrt-packages/trunk/xmm-modem package/xmm-modem
sed -i 's/ACM0/ACM2/g' package/xmm-modem/root/etc/config/xmm-modem

# Add ethstatus
svn co https://github.com/kiddin9/openwrt-packages/trunk/{autocore,ethstatus,mhz} package/

# Add ramfree
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/luci-app-ramfree

# Add luci-app-adguardhome
git clone --depth 1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

# Add wrtwmon
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-wrtbwmon,wrtbwmon} package/

# Add useronline
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-onliner package/luci-app-onliner

# Add ssr-plus && passwall
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall

# Add passwal-package
svn co https://github.com/kiddin9/openwrt-packages/trunk/{lua-neturl,sagernet-core,ipt2socks,redsocks2,trojan,brook,dns2socks,dns2tcp,microsocks,tcping,chinadns-ng,hysteria,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,trojan-go,trojan-plus,v2ray-core,v2ray-plugin,xray-plugin,v2ray-geodata} package/passwall-package

# Add modemband
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-modemband,modemband,sms-tool} package/

# Add theme
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-argon-config,luci-theme-argon,luci-theme-edge} package/

# Add eqosip to limit
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos

# Add default setting
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/99-init-settings.sh
popd
