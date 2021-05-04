SHELL = /bin/bash

OPENSSL_DIR = "openssl-1.1.1g"
OPENSSL_TAR = "openssl-1.1.1g-hobbled.tar.xz"
OPENSSL_URL = "https://src.fedoraproject.org/lookaside/pkgs/rpms/openssl/openssl-1.1.1g-hobbled.tar.xz/sha512/7cd351d8fd4a028edcdc6804d8b73af7ff5693ab96cafd4f9252534d4e8e9000e22aefa45f51db490da52d89f4e5b41d02452be0b516fbb0fe84e36d5ca54971/openssl-1.1.1g-hobbled.tar.xz"

all:
	wget -O $(OPENSSL_TAR) "$(OPENSSL_URL)"
	tar -xf $(OPENSSL_TAR)
	pushd $(OPENSSL_DIR); \
	cp ../debian ./ -r; \
	cp debian/patches/ec_curve.c crypto/ec/; \
	cp debian/patches/ectest.c test/; \
	mkdir .pc/; \
	echo series > .pc/.quilt_series; \
	echo debian/patches > .pc/.quilt_patches; \
	quilt upgrade; \
	quilt push -a; \
	DEB_BUILD_OPTIONS=nocheck DEB_CFLAGS_APPEND=-DOPENSSL_FIPS DEB_CPPFLAGS_APPEND=-DOPENSSL_FIPS dpkg-buildpackage -b -rfakeroot -us -uc                                                                                                                                                                                                                                  
