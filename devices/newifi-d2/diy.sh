find target/linux/ramips/* -maxdepth 0 ! -path '*/patches-5.4' -exec rm -Rf '{}' \;
echo -e "\q" | svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/ramips target/linux/ramips
rm -Rf target/linux/ramips/.svn
echo -e "\q" | svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/ramips/patches-5.4 target/linux/ramips/patches-5.4

svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/lean/mt-drivers package/lean/mt-drivers

# sed -i 's?admin/status/channel_analysis??' package/feeds/luci/luci-mod-status/root/usr/share/luci/menu.d/luci-mod-status.json

# 此阶段对 config 的修改是无效的
# sed -i "s/CONFIG_PACKAGE_luci-app-nft-qos.*/CONFIG_PACKAGE_luci-app-nft-qos=n/g" .config