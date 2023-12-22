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
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic

# Add Custom Packges
git clone --depth 1 https://github.com/kiddin9/openwrt-packages.git package/kiddin
# Add modeminfo
cp -r package/kiddin/{luci-app-modeminfo,modeminfo,telegrambot,luci-app-modemband,modemband,luci-app-atinout,atinout,luci-app-sms-tool} package/
# Add driver L860
cp -r package/kiddin/{luci-proto-xmm,xmm-modem} package/
# Add internet-detector
cp -r package/kiddin/luci-app-internet-detector package/
# Add autocore
cp -r package/kiddin/autocore package/
# Change luci-base
rm -rf feeds/luci/modules/{luci-base,luci-mod-status,luci-mod-network,luci-mod-system}
cp -r package/kiddin/{luci-base,luci-mod-network,luci-mod-status,luci-mod-system} feeds/luci/modules/
# Add openclash
cp -r package/kiddin/luci-app-openclash package/
# Add ramfree
cp -r package/kiddin/luci-app-ramfree package/
# Add passwall
git clone -b main --depth 1 https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall
git clone -b main --depth 1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall-packages
# Change smartdns
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/packages/net/smartdns
cp -r package/kiddin/luci-app-smartdns feeds/luci/applications/
cp -r package/kiddin/smartdns feeds/packages/net/
# Change adguardhome
rm -rf feeds/packages/net/adguardhome
cp -r package/kiddin/adguardhome feeds/packages/net/
# Change Golang
git clone -b master --depth 1 https://github.com/openwrt/packages.git package/openwrt-golang
rm -rf feeds/packages/lang/golang
cp -r package/openwrt-golang/lang/golang feeds/packages/lang/
rm -rf package/openwrt-golang
# Add theme
cp -r package/kiddin/{luci-theme-design,luci-theme-argon,luci-app-design-config,luci-app-argon-config} package/
# Other
rm -rf package/network/config/firewall4
cp -r package/kiddin/firewall4 package/network/config/
cp -r package/kiddin/fullconenat-nft package/
rm -rf feeds/luci/applications/luci-app-firewall
cp -r package/kiddin/luci-app-firewall feeds/luci/applications/
rm -rf package/network/services/dnsmasq
cp -r package/kiddin/dnsmasq package/network/services/
rm -rf package/network/utils/nftables
cp -r package/kiddin/nftables package/network/utils/
rm -rf package/libs/libnftnl
cp -r package/kiddin/libnftnl package/libs/
# Add timezone
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/official/99-init-settings.sh
popd

# clear
rm -rf package/kiddin

#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
