#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

sed -i 's/ssid=LEDE/ssid=$([ $devidx -eq 0 ] \&\& echo "OpenWrt_5G" || echo "OpenWrt_2.4G")/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认IP
sed -i 's/192.168.1/192.168.0/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1/192.168.0/g' package/base-files/luci2/bin/config_generate
# 修改默认主机名
sed -i 's/LEDE/OpenWrt/g' package/base-files/files/bin/config_generate
sed -i 's/LEDE/OpenWrt/g' package/base-files/luci2/bin/config_generate
# 修改默认时区
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate
sed -i 's/UTC/CST-8/g' package/base-files/luci2/bin/config_generate
# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-light/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-ssl-nginx/Makefile
# 修改显示时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm
# 替换默认web服务器为nginx
sed -i 's/luci-light/luci-nginx/g' feeds/luci/collections/luci/Makefile
