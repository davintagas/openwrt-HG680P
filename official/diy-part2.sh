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
git clone --depth 1 https://github.com/kiddin9/openwrt-packages.git package/kiddin

rm -rf package/kiddin/{luci-app-baidupcs-web,my-default-settings,luci-app-amlogic,baidupcs-web,basicstation,luci-app-apinger,luci-app-bitsrunlogin-go,luci-app-keepalived,luci-app-e2guardian,luci-app-e2guardian,luci-app-lorawan-basicstation}

svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

rm -rf feeds/packages/net/{xray-core,v2raya,v2ray-geodata,v2ray-core,uwsgi,trojan-go,transmission-web-control,transmission,telnet-bsd,tailscale,speedtestpp,smartdns,rp-pppoe,nginx,adguardhome,aria2,ariang,cloudreve,ddns-scripts,dnsproxy,frp,haproxy,keepalived,mwan3}
rm -rf feeds/packages/utils/{cgroupfs-mount,coremark,dockerd,watchcat}
rm -rf feeds/luci/applications/{luci-app-acme,luci-app-aria2,luci-app-attendedsysupgrade,luci-app-dawn,luci-app-ddns,luci-app-dockerman,luci-app-dump1090,luci-app-eoip,luci-app-firewall,luci-app-frpc,luci-app-frps,luci-app-ksmbd,luci-app-ltqtapi,luci-app-lxc,luci-app-mwan3,luci-app-natmap,luci-app-ocserv,luci-app-olsr-services,luci-app-olsr-viz,luci-app-omcproxy,luci-app-openwisp,luci-app-opkg,luci-app-pagekitec,luci-app-rp-pppoe-server,luci-app-samba4,luci-app-shadowsocks-libev,luci-app-smartdns,luci-app-snmpd,luci-app-squid,luci-app-transmission,luci-app-udpxy,luci-app-unbound,luci-app-upnp,luci-app-watchcat,luci-app-xinetd}
rm -rf feeds/luci/modules/{luci-base,luci-mod-network,luci-mod-status,luci-mod-system}
rm -rf feeds/packages/mail/msmtp
rm -rf feeds/packages/admin/netdata
rm -rf package/network/config/{firewall,firewall4,netifd}
rm -rf package/network/services/{dnsmasq,ppp}
rm -rf package/network/utils/nftables
rm -rf package/base-files
rm -rf package/system/opkg
rm -rf package/libs/{libnftnl,mbedtls,openssl}
rm -rf package/network/config/ltq-vdsl-app

# Add default setting
mkdir -p files/etc/uci-defaults
pushd files/etc/uci-defaults
wget https://raw.githubusercontent.com/davintagas/default/main/99-init-settings.sh
popd

rm -rf .git
git clone --depth 1 https://github.com/openwrt/openwrt.git
cd openwrt
cp -r .git ../
cd -
rm -rf openwrt
