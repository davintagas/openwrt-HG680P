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
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

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

# Add diskman
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-diskman package/luci-app-diskman

# Add ramfee
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-ramfree package/luci-app-ramfree

# Add autocore
svn co https://github.com/kiddin9/openwrt-packages/trunk/{autocore,mhz,ethstatus} package/

# Add theme
svn co https://github.com/kiddin9/openwrt-packages/trunk/{luci-theme-alpha,luci-theme-design,luci-theme-edge,luci-app-design-config} package/

# Add atinout
svn co https://github.com/kiddin9/openwrt-packages/trunk/atinout package/atinout

# Add tinyfilemanager
git clone --depth 1 https://github.com/davintagas/luci-app-tinyfilemanager.git package/luci-app-tinyfilemanager

# Add adguradhome
git clone --depth 1 https://github.com/davintagas/luci-app-adguardhome.git package/luci-app-adguardhome

# Add internet-detector
svn co https://github.com/gSpotx2f/luci-app-internet-detector/trunk/{luci-app-internet-detector,internet-detector} package/

# Add default
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/rooter/99-init-settings.sh
popd

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../config-openwrt/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
