rm -Rf target/linux/{ramips,generic}
svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/ramips target/linux/ramips
svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/generic target/linux/generic

# 此阶段对 config 的修改是无效的
# sed -i "s/CONFIG_PACKAGE_luci-app-nft-qos.*/CONFIG_PACKAGE_luci-app-nft-qos=n/g" .config

echo "src-git small https://github.com/kenzok8/small" >>feeds.conf

./scripts/feeds update -a
./scripts/feeds install -a

sed -i 's,$(STAGING_DIR_HOST)/bin/upx,upx,' package/feeds/small/*/Makefile
sed -i 's,$(STAGING_DIR_HOST)/bin/upx,upx,' package/community/*/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# Modify default SSID
sed -i "s/DISTRIB_ID.*/DISTRIB_ID=Newifi-D2/g" package/base-files/files/etc/openwrt_release

# Modify hostname
sed -i 's/OpenWrt/Newifi-D2/g' package/base-files/files/bin/config_generate
