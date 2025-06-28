#!/bin/bash
#
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Themes
# git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth=1 https://github.com/xianfanjie/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
# git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
# git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear

# openlist
git clone --depth=1 https://github.com/xianfanjie/OpenList-OpenWRT package/openlist
sed -i '/golang-package/a \\tGO_PKG_DEFAULT_LDFLAGS:=-w -s -extldflags "-static"' package/openlist/openlist/Makefile
sed -i '/INSTALL_DATA/a \\t/usr/bin/upx --lzma --best $(1)\/usr\/bin\/openlist' package/openlist/openlist/Makefile

git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/emortal/automount package/emortal/cpufreq package/emortal/autocore
git_sparse_clone master https://github.com/immortalwrt/luci applications/luci-app-vlmcsd applications/luci-app-cpufreq
git_sparse_clone master https://github.com/immortalwrt/packages net/vlmcsd

# openclash
git_sparse_clone dev https://github.com/xianfanjie/OpenClash luci-app-openclash

# passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall luci-app-passwall
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall2 luci-app-passwall2

# git_sparse_clone master https://github.com/coolsnowwolf/luci applications/luci-app-vlmcsd
# git_sparse_clone master https://github.com/coolsnowwolf/packages net/vlmcsd
./scripts/feeds update -a

rm -rf feeds/packages/lang/golang
git clone --depth=1 https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
# 修改默认软件包源
#sed -i 's/downloads.openwrt.org/mirrors.pku.edu.cn\/openwrt/' include/version.mk package/base-files/image-config.in
# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# sed -i 's/PKG_VERSION:=1.37.0/PKG_VERSION:=1.36.0/' feeds/packages/net/aria2/Makefile
# sed -i 's/^PKG_HASH:=.*$/PKG_HASH:=58d1e7608c12404f0229a3d9a4953d0d00c18040504498b483305bcb3de907a5/' feeds/packages/net/aria2/Makefile

./scripts/feeds install -a


