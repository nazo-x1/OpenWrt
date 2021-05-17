#!/bin/bash
#=================================================
./scripts/feeds install -a
sed -i 's/Os/O2/g' include/target.mk
sed -i 's?zstd$?zstd ucl upx\n$(curdir)/upx/compile := $(curdir)/ucl/compile?g' tools/Makefile
rm -rf package/network/services/ppp package/libs/libnfnetlink
svn co https://github.com/openwrt/openwrt/trunk/package/network/services/ppp package/network/services/ppp
svn co https://github.com/openwrt/openwrt/trunk/package/libs/libnfnetlink package/libs/libnfnetlink
rm -rf package/network/services/dnsmasq
svn co https://github.com/immortalwrt/immortalwrt/branches/master/package/network/services/dnsmasq package/network/services/dnsmasq
sed -i 's/+acme\( \|$\)/+acme +acme-dnsapi\1/g' package/*/*/luci-app-acme/Makefile
sed -i '$a /etc/sysupgrade.conf' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /etc/amule' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /etc/acme' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /etc/bench.log' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '$a /etc/acme' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '/\/etc\/profile/d' package/base-files/files/lib/upgrade/keep.d/base-files-essential
sed -i '/^\/etc\/profile/d' package/base-files/Makefile
# find target/linux/x86 -name "config*" -exec bash -c 'cat kernel.conf >> "{}"' \;
find target/linux -path "target/linux/*/config-*" | xargs -i sed -i '$a CONFIG_ACPI=y\nCONFIG_X86_ACPI_CPUFREQ=y\n \
CONFIG_NR_CPUS=128\nCONFIG_FAT_DEFAULT_IOCHARSET="utf8"\nCONFIG_CRYPTO_CHACHA20_NEON=y\nCONFIG_CRYPTO_CHACHA20POLY1305=y\nCONFIG_BINFMT_MISC=y' {}
sed -i 's/max_requests 3/max_requests 10/g' package/network/services/uhttpd/files/uhttpd.config
rm -rf ./feeds/packages/lang/{golang,node}
svn co https://github.com/immortalwrt/packages/trunk/lang/golang feeds/packages/lang/golang
svn co https://github.com/immortalwrt/packages/trunk/lang/node feeds/packages/lang/node

sed -i "s/+nginx\( \|$\)/+nginx-ssl\1/g"  package/*/*/*/Makefile
sed -i 's/+python\( \|$\)/+python3/g' package/*/*/*/Makefile
sed -i 's/PKG_BUILD_DIR:=/PKG_BUILD_DIR?=/g' feeds/luci/luci.mk
sed -i '/killall -HUP/d' feeds/luci/luci.mk
find package target -name inittab | xargs -i sed -i "s/askfirst/respawn/g" {}

sed -i 's/$(VERSION) &&/$(VERSION) ;/g' include/download.mk
date=`date +%m.%d.%Y`
# sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='%D %V %C by 0NAZO0'/g" package/base-files/files/etc/openwrt_release
sed -i "s/# REVISION:=x/REVISION:= $date/g" include/version.mk

if [ -f sdk.tar.xz ]; then
	mkdir sdk
	tar -xJf sdk.tar.xz -C sdk
	cp -rf sdk/*/staging_dir/* ./staging_dir/
	rm -rf sdk.tar.xz sdk
	sed -i '/\(tools\|toolchain\)\/Makefile/d' Makefile
	if [ -f /usr/bin/python ]; then
		ln -sf /usr/bin/python staging_dir/host/bin/python
	else
		ln -sf /usr/bin/python3 staging_dir/host/bin/python
	fi
	ln -sf /usr/bin/python3 staging_dir/host/bin/python3
fi
