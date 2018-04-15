#!/bin/bash
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic && \
make -j $SHED_NUM_JOBS || exit 1
# Do not install static libraries
sed -i 's# libcrypto.a##;s# libssl.a##;/INSTALL_LIBS/s#libcrypto.a##' Makefile && \
make DESTDIR="$SHED_FAKE_ROOT" MANSUFFIX=ssl install || exit 1
mv -v "${SHED_FAKE_ROOT}"/usr/share/doc/openssl{,-1.1.0g}
cp -vfr doc/* "${SHED_FAKE_ROOT}/usr/share/doc/openssl-1.1.0g"
