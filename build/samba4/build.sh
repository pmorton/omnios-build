#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=samba
VER="4.0.3"
VERHUMAN=$VER
PKG=service/network/samba4
SUMMARY="$PROG - CIFS server and domain controller"
DESC="$SUMMARY ($VERS)"

DEPENDS_IPS="service/network/dns/mdns developer/build/autoconf
             system/library system/library/gcc-4-runtime system/library/math"
PREFIX=/usr/local
#BUILDDIR=$PROG-$VER/source3
BUILDARCH=32
CONFIGURE_OPTS="
    --prefix=$PREFIX
    --bindir=$PREFIX/bin
    --sbindir=$PREFIX/sbin
    --mandir=$PREFIX/man
    --infodir=$PREFIX/info
    --sysconfdir=/etc/samba
    --with-configdir=/etc/samba
    --with-privatedir=/etc/samba/private
    --localstatedir=/var
    --sharedstatedir=/var
    --bundled-libraries=ALL
    --with-winbind
    --with-ads
    --with-ldap
    --with-pam
    --with-iconv
    --with-acl-support
    --with-syslog
    --with-aio-support
    --enable-fhs
"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/samba
    logcmd cp $SRCDIR/files/manifest-samba-nmbd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/nmbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-smbd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/smbd.xml
    logcmd cp $SRCDIR/files/manifest-samba-winbindd.xml \
        $DESTDIR/lib/svc/manifest/network/samba/winbindd.xml
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: