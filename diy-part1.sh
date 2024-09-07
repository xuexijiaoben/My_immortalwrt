#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 汇总常用插件

function merge_package() {
    # 参数1是分支名,参数2是库地址,参数3是所有文件下载到指定路径。
    # 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
    if [[ $# -lt 3 ]]; then
    	echo "Syntax error: [$#] [$*]" >&2
        return 1
    fi
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" target_dir="$3" && shift 3
    rootdir="$PWD"
    localdir="$target_dir"
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    # 使用循环逐个移动文件夹
    for folder in "$@"; do
        mv -f "$folder" "$rootdir/$localdir"
    done
    cd "$rootdir"
}

merge_package main https://github.com/kenzok8/small-package package/app luci-app-adguardhome
# merge_package master https://github.com/coolsnowwolf/luci package/app applications/luci-app-unblockmusic
# bypass
# merge_package master https://github.com/kiddin9/openwrt-packages package/app luci-app-bypass lua-neturl redsocks2
# v2raya
# merge_package master https://github.com/v2rayA/v2raya-openwrt package/app luci-app-v2raya v2raya 
merge_package main https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest package/app applications/luci-app-cloudflarespeedtest
merge_package master https://github.com/immortalwrt-collections/openwrt-cdnspeedtest package/app cdnspeedtest
merge_package v5 https://github.com/sbwml/luci-app-mosdns package/app luci-app-mosdns mosdns v2dat
merge_package main https://github.com/kenzok8/small-package package/app luci-app-fileassistant

# 集客AC
# merge_package main https://github.com/xuexijiaoben/My_immortalwrt package/app luci-app-gecoosac
# mkdir -p files/etc/gecoosac
# wget -P files/etc/gecoosac https://raw.githubusercontent.com/xuexijiaoben/My_immortalwrt/main/ac_linux_arm64
## wget -P files/etc/gecoosac https://raw.githubusercontent.com/xuexijiaoben/My_immortalwrt/main/ac_linux_amd64
# chmod -R 755 files
# sed -i 's|/usr/bin/gecoosac|/etc/gecoosac/ac_linux_arm64|g' package/app/luci-app-gecoosac/root/etc/config/gecoosac
## sed -i 's|/usr/bin/gecoosac|/etc/gecoosac/ac_linux_arm64|g' package/app/luci-app-gecoosac/root/etc/init.d/gecoosac
## sed -i 's|/usr/bin/gecoosac|/etc/gecoosac/ac_linux_arm64|g' package/app/luci-app-gecoosac/luasrc/model/cbi/gecoosac.lua
# chmod 755 package/app/luci-app-gecoosac/root/etc/init.d/gecoosac

merge_package main https://github.com/lwb1978/openwrt-gecoosac package/app luci-app-gecoosac
merge_package main https://github.com/lwb1978/openwrt-gecoosac package/app gecoosac

echo 'src-git alist https://github.com/sbwml/luci-app-alist.git' >>feeds.conf.default
echo 'src-git amlogic https://github.com/ophub/luci-app-amlogic.git' >>feeds.conf.default
# echo 'src-git lucky https://github.com/sirpdboy/luci-app-lucky.git' >>feeds.conf.default
echo 'src-git lucky https://github.com/gdy666/luci-app-lucky.git' >>feeds.conf.default
# echo 'src-git ddnsgo https://github.com/sirpdboy/luci-app-ddns-go.git' >>feeds.conf.default
git clone --depth 1 https://github.com/sirpdboy/luci-app-autotimeset.git package/app/luci-app-autotimeset
git clone --depth 1 https://github.com/sirpdboy/luci-app-advancedplus.git package/app/luci-app-advancedplus
git clone -b js --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/app/luci-app-unblockneteasemusic

# Add a feed source
# 添加额外软件包
git clone --depth 1  https://github.com/ilxp/luci-app-ikoolproxy.git package/app/luci-app-ikoolproxy

# 仿istore
echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default


# 科学上网插件

# drop mosdns and v2ray-geodata packages that come with the source
# find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
# find ./ | grep Makefile | grep mosdns | xargs rm -f

echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
# echo "src-git ssrplus https://github.com/fw876/helloworld.git;master" >>feeds.conf.default
# merge_package master https://github.com/fw876/helloworld package/app/ssrplus lua-neturl redsocks2 shadow-tls v2raya luci-app-ssr-plus

# 开发版openclash
merge_package dev https://github.com/vernesong/OpenClash package/app luci-app-openclash
# echo 'src-git openclash https://github.com/vernesong/OpenClash.git;dev' >>feeds.conf.default
# 下载openclash内核
mkdir -p package/app/luci-app-openclash/root/etc/openclash/core/
wget -qO- https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-arm64.tar.gz | tar xOvz > package/app/luci-app-openclash/root/etc/openclash/core/clash
wget -qO- https://raw.githubusercontent.com/vernesong/OpenClash/core/master/premium/clash-linux-arm64-2023.08.17-13-gdcc8d87.gz | gunzip -c > package/app/luci-app-openclash/root/etc/openclash/core/clash_tun
wget -qO- https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz | tar xOvz > package/app/luci-app-openclash/root/etc/openclash/core/clash_meta
wget -qO- https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat > package/app/luci-app-openclash/root/etc/openclash/GeoIP.dat
wget -qO- https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat > package/app/luci-app-openclash/root/etc/openclash/GeoSite.dat
chmod +x package/app/luci-app-openclash/root/etc/openclash/core/clash*

./scripts/feeds update -a
\rm -rf feeds/packages/net/cdnspeedtest
\rm -rf feeds/ssrplus/mosdns
\rm -rf feeds/packages/net/mosdns
# \rm -rf feeds/luci/applications/luci-app-mosdns feeds/packages/utils/v2dat
\rm -rf feeds/luci/applications/luci-app-passwall
# \rm -rf feeds/luci/applications/luci-app-ddns-go
\rm -rf feeds/luci/applications/luci-app-alist
\rm -rf feeds/luci/applications/luci-app-unblockneteasemusic

rm -rf feeds/luci/applications/luci-app-openclash
# fix shadowsocks-rust
rm feeds/packages/net/shadowsocks-rust/Makefile
cp feeds/passwall_packages/shadowsocks-rust/Makefile feeds/packages/net/shadowsocks-rust
# wget -P feeds/packages/net/shadowsocks-rust https://raw.githubusercontent.com/kenzok8/small-package/main/shadowsocks-rust/Makefile

merge_package openwrt-23.05 https://github.com/coolsnowwolf/luci feeds/luci/applications applications/luci-app-pppwn
merge_package master https://github.com/coolsnowwolf/packages feeds/packages/multimedia multimedia/pppwn-cpp
merge_package master https://github.com/coolsnowwolf/luci feeds/luci/applications applications/luci-app-easymesh

# fix : ubus_call_umdns()=ubus.c@1385
rm package/network/services/umdns/files/umdns.init
rm package/network/services/umdns/files/umdns.json
wget -P package/network/services/umdns/files https://raw.githubusercontent.com/openwrt/openwrt/main/package/network/services/umdns/files/umdns.init
wget -P package/network/services/umdns/files https://raw.githubusercontent.com/openwrt/openwrt/main/package/network/services/umdns/files/umdns.json

# temporary fix Ruby 3.3.3 ERROR
# rm -rf feeds/packages/lang/ruby
# merge_package openwrt-23.05 https://github.com/immortalwrt/packages feeds/packages/lang lang/ruby

./scripts/feeds install -a

# 修复feeds错误
sed -i 's/+libpcre/+libpcre2/g' package/feeds/telephony/freeswitch/Makefile

# 主题
git clone https://github.com/thinktip/luci-theme-neobird.git feeds/luci/themes/luci-theme-neobird
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git feeds/luci/themes/luci-theme-opentomcat
git clone -b js https://github.com/sirpdboy/luci-theme-kucat.git feeds/luci/themes/luci-theme-kucat
git clone https://github.com/derisamedia/luci-theme-alpha.git feeds/luci/themes/luci-theme-alpha

# echo '### Argon Theme Config ###'
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b master  https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config # if have
git clone https://github.com/jerrykuku/luci-app-argon-config.git feeds/luci/applications/luci-app-argon-config

./scripts/feeds update -a
./scripts/feeds install -a

# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
