#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#

sed -i 's/zh_cn/en/g' package/lean/default-settings/files/zzz-default-settings
sed -i 's/CST-8/WIB-7/g' package/lean/default-settings/files/zzz-default-settings
sed -i 's/Shanghai/Jakarta/g' package/lean/default-settings/files/zzz-default-settings

# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Add passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall

svn co https://github.com/kiddin9/openwrt-packages/trunk/{v2ray-geodata,dns2socks,dns2tcp,microsocks,tcping,brook,chinadns-ng,hysteria,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,trojan-plus,v2ray-core,v2ray-plugin,xray-plugin,trojan-go,xray-core,sagernet-core,ipt2socks,trojan,lua-neturl,redsocks2} package/

# Add ssr-plus
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

# Add tinyfilemanager
git clone --depth 1 https://github.com/davintagas/luci-app-tinyfilemanager.git package/luci-app-tinyfilemanager

# Add atinout
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-atinout,atinout} package/

# Add modeminfo
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-modeminfo,modeminfo,telegrambot} package/

# Add driver l860-gl
svn co https://github.com/kiddin9/openwrt-packages/trunk/xmm-modem package/xmm-modem
sed -i 's/ACM0/ACM2/g' package/xmm-modem/root/etc/config/xmm-modem

# Add luci-app-adguardhome
git clone --depth 1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

# Add theme
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-argon-mod
rm -rf feeds/luci/applications/luci-app-argon-config
git clone --depth 1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth 1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth 1 https://github.com/thinktip/luci-theme-neobird package/luci-theme-neobird
git clone --depth 1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
svn co https://github.com/haiibo/packages/trunk/luci-theme-opentomcat package/luci-theme-opentomcat
svn co https://github.com/rosywrt/luci-theme-rosy/trunk/luci-theme-rosy package/luci-theme-rosy
svn co https://github.com/haiibo/openwrt-packages/trunk/luci-theme-atmaterial_new package/luci-theme-atmaterial_new

# Add eqos
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos

# Add filebrowser
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-app-filebrowser,filebrowser} package/
