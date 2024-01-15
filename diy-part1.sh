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

function merge_package(){
    # 参数1是分支名,参数2是库地址。所有文件下载到指定路径。
    # 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
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
    for folder in "$@"; do
        mv -f "$folder" "$rootdir/$localdir"
    done
    cd "$rootdir"
}

merge_package main https://github.com/kenzok8/small-package package luci-app-adguardhome
# bypass
# merge_package master https://github.com/kiddin9/openwrt-packages package luci-app-bypass lua-neturl redsocks2
# v2raya
# merge_package master https://github.com/v2rayA/v2raya-openwrt package luci-app-v2raya v2raya 


# echo 'src-git alist https://github.com/sbwml/luci-app-alist.git' >>feeds.conf.default
echo 'src-git amlogic https://github.com/ophub/luci-app-amlogic.git' >>feeds.conf.default
echo 'src-git lucky https://github.com/sirpdboy/luci-app-lucky.git' >>feeds.conf.default
# echo 'src-git ddnsgo https://github.com/sirpdboy/luci-app-ddns-go.git' >>feeds.conf.default
git clone --depth 1 https://github.com/sirpdboy/luci-app-autotimeset.git package/luci-app-autotimeset
git clone --depth 1 https://github.com/sirpdboy/luci-app-advancedplus.git package/luci-app-advancedplus
# git clone -b js --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic


# Add a feed source
# 添加额外软件包
# git clone --depth 1  https://github.com/ilxp/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
echo 'src-git cdnspeedtest https://github.com/immortalwrt-collections/openwrt-cdnspeedtest.git' >>feeds.conf.default
echo 'src-git cloudflarespeedtest https://github.com/mingxiaoyu/luci-app-cloudflarespeedtest.git' >>feeds.conf.default

# 仿istore
echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default


# 科学上网插件

# drop mosdns and v2ray-geodata packages that come with the source
# find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
# find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone -b v5 --depth 1 https://github.com/sbwml/luci-app-mosdns.git package/luci-app-mosdns
# git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# echo 'src-git openclash https://github.com/vernesong/OpenClash.git;dev' >>feeds.conf.default
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
# echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git ssrplus https://github.com/fw876/helloworld.git;master" >>feeds.conf.default


./scripts/feeds update -a
./scripts/feeds install -a

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
