#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修复编译错误
sed -i 's/CGO_ENABLED=0/CGO_ENABLED=1/g' package/app/cdnspeedtest/Makefile

# 1.修改默认ip
sed -i 's/192.168.1.1/192.168.2.3/g' package/base-files/files/bin/config_generate

# 2.修改主机名
sed -i 's/immortalwrt/Phicomm_N1/g' package/base-files/files/bin/config_generate

# 4.修改版本号
# sed -i "s/OpenWrt /0012h build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 5.修改默认主题
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile
# sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile
# 或
# default_theme='alpha'
# sed -i "s/bootstrap/$default_theme/g" feeds/luci/modules/luci-base/root/etc/config/luci
sed -i "s/luci-static\/bootstrap/luci-static\/argon/g" feeds/luci/modules/luci-base/root/etc/config/luci

# 6.设置ttyd免登录
# sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd

# 7.修正连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修改kucat标语，来自于sirpdboy
# sed -i 's/做事先做人，尊重他人劳动成果，是为人的基本准则！/Happy Every Day from sirpdboy,Best Regards!/g' feeds/luci/themes/luci-theme-kucat/htdocs/luci-static/kucat/img/logoword
# feeds/luci/themes/luci-theme-kucat/htdocs/luci-static/kucat/img/logourl

# 替换终端为bash
# sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# 删除默认密码
# sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# 禁用wifi
sed -i 's/disabled='0'/disabled='1'/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh
# 修改wifi名字
sed -i 's/ssid='ImmortalWrt'/ssid='N1ImmortalWrt'/' package/network/config/wifi-scripts/files/lib/wifi/mac80211.sh

# 修改本地时间格式
# sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm
# echo '修改时区'
# sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# 修改版本为编译日期
# date_version=$(date +"%y.%m.%d")
# orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
# sed -i "s/${orig_version}/R${date_version} by Huoleifeng/g" package/lean/default-settings/files/zzz-default-settings

# 修改晶晨宝盒默认配置
# 1.设置OpenWrt 文件的下载仓库
sed -i "s|amlogic_firmware_repo.*|amlogic_firmware_repo 'https://github.com/xuexijiaoben/My_immortalwrt'|g" feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic

# 2.设置 Releases 里 Tags 的关键字
sed -i "s|ARMv8|armsr|g" feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic

# 3.设置 Releases 里 OpenWrt 文件的后缀
# sed -i "s|.img.gz|.OPENWRT_SUFFIX|g" feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic

# 4.设置 OpenWrt 内核的下载路径
sed -i "s|amlogic_kernel_path.*|amlogic_kernel_path 'https://github.com/breakings/OpenWrt'|g" feeds/amlogic/luci-app-amlogic/root/etc/config/amlogic


# Add autocore support for armvirt
# sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/emortal/autocore/Makefile
# sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt||TARGET_armsr) \\/g' package/emortal/autocore/Makefile

# 编译 po2lmo (如果有po2lmo可跳过)
# pushd feeds/openclash/luci-app-openclash/tools/po2lmo
# make && sudo make install
# popd
