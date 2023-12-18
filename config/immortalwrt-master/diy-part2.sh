#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release

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
cp -r package/kiddin/{luci-app-modeminfo,modeminfo,telegrambot,luci-app-modemband,modemband,luci-app-atinout,atinout,luci-app-sms-tool,sms-tool} package/
# Add driver L860
cp -r package/kiddin/{luci-proto-xmm,xmm-modem} package/
# Add internet-detector
cp -r package/kiddin/luci-app-internet-detector package/
# Change smartdns
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/packages/net/smartdns
cp -r package/kiddin/luci-app-smartdns feeds/luci/applications/
cp -r package/kiddin/smartdns feeds/packages/net/
# Add timezone
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/official/99-init-settings.sh
popd

rm -rf package/kiddin
#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
