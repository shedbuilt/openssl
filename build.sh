#!/bin/bash
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make -j $SHED_NUMJOBS
# Do not install static libraries
sed -i 's# libcrypto.a##;s# libssl.a##;/INSTALL_LIBS/s#libcrypto.a##' Makefile
make DESTDIR=${SHED_FAKEROOT} MANSUFFIX=ssl install
mv -v ${SHED_FAKEROOT}/usr/share/doc/openssl{,-1.1.0f}
cp -vfr doc/* ${SHED_FAKEROOT}/usr/share/doc/openssl-1.1.0f
