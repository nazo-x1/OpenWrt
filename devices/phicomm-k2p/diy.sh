
find target/linux/ramips/* -maxdepth 0 ! -path '*/patches-5.4' -exec rm -Rf '{}' \;
echo -e "\q" | svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/ramips target/linux/ramips
rm -Rf target/linux/ramips/.svn
echo -e "\q" | svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/ramips/patches-5.4 target/linux/ramips/patches-5.4

svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/lean/mt-drivers package/lean/mt-drivers

sed -i 's/kmod-mt7615d_dbdc/kmod-mt7615d luci-app-mtwifi/g' target/linux/ramips/image/mt7621.mk

# sed -i 's?admin/status/channel_analysis??' package/feeds/luci/luci-mod-status/root/usr/share/luci/menu.d/luci-mod-status.json

rm -Rf files/etc/profile.d/sysinfo.sh

sed -i 's/O2/Os/g' include/target.mk

# sed -i '/unsplash.com/d' package/feeds/custom/luci-theme-edge/luasrc/view/themes/edge/sysauth.htm

# sed -i 's?<img src="<%=media%>/background/3.jpg" alt="img"/>??' package/feeds/custom/luci-theme-edge/luasrc/view/themes/edge/sysauth.htm

# rm -f package/feeds/custom/luci-theme-edge/htdocs/luci-static/edge/background/3.jpg
