https://github.com/immortalwrt/immortalwrt

[gecoosac](https://www.right.com.cn/FORUM/thread-8379292-1-1.html)

升级降级方法统一为：
1. 把 update-xxxxxx-openwrt.sh 及解压后得到的 img 镜像上传至 /mnt/mmcblk2p4
2. cd /mnt/mmcblk2p4
3. chmod 755 update-amlogic-openwrt.sh
4. ./update-amlogic-openwrt.sh ./openwrt*.img
5. 升级脚本为`update-amlogic-openwrt.sh` [点这里跳转](https://github.com/HoldOnBro/Actions-OpenWrt/releases/tag/ARMv8)


学习，硬盘合并、硬件信息等

https://github.com/chenmozhijin/OpenWrt-K

https://github.com/dzlea/ActionsBuildOpenWRT

兼容firewall4列表

https://github.com/openwrt/packages/issues/16818


openwrt 有原生的 flow offloading（软件流量分载），不需要经常崩溃的 sfe。
家用路由器开启 bbr 只会降低网络体验，除非你要在自己家开流媒体服务器。

passwall 需要把高级设置-防火墙工具选项，改为 NFtable 才能正常使用！
Passwall 新版把原来的自动切换节点功能改到SOCKS设置里面，所以要实现节点自动切换必需要“套娃”，具体设置请参考 https://github.com/xiaorouji/openwrt-passwall/issues/2708
另外如果觉得内存不够用，可以把不需要的插件关闭节省内存。
在 “系统” 下找到 “启动项” 把不需要的插件禁用，然后再停止该插件！
https://www.right.com.cn/forum/thread-8294637-1-1.html
