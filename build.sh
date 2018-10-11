#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Configure
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
# Build and Install
make -j $SHED_NUM_JOBS &&
# Do not install static libraries
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile &&
make DESTDIR="$SHED_FAKE_ROOT" MANSUFFIX=ssl install || exit 1
# Install Documentation
if [ -n "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    mv -v "${SHED_FAKE_ROOT}/usr/share/doc/openssl" "${SHED_FAKE_ROOT}${SHED_PKG_DOCS_INSTALL_DIR}" &&
    cp -vfr doc/* "${SHED_FAKE_ROOT}${SHED_PKG_DOCS_INSTALL_DIR}" || exit 1
else
    rm -rf "${SHED_FAKE_ROOT}/usr/share/doc/openssl"
fi
