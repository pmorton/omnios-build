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

PROG=ruby           # App name
VER=2.0.0-p0      # App version
VERHUMAN=$VER       # Human-readable version
#PVER=              # Branch (set in config.sh, override here if needed)
PKG=bia/runtime/ruby-20   # Package name (e.g. library/foo)
SUMMARY="Ruby 2.0"          # One-liner, must be filled in
DESC="Ruby 2.0 ($VER)"             # Longer description, must be filled in

#OK this is lame, but to build 1.9 you need 1.8

BUILD_DEPENDS_IPS="omniti/library/libyaml library/libffi omniti/library/libgdbm"
DEPENDS_IPS="omniti/library/libyaml library/libffi omniti/library/libgdbm"
BASE_RUBY=/opt/omni/bin/ruby
PREFIX=/opt/bia

# Ruby doesn't have the concept of library paths,
#   so only one arch can be installed in $PREFIX
# Default to 32-bit
[[ "$BUILDARCH" == "both" ]] && BUILDARCH=64
NOSCRIPTSTUB=true

CONFIGURE_OPTS="--without-gcc --enable-pthread --enable-shared ac_cv_func_dl_iterate_phdr=no --with-baseruby=$BASE_RUBY --with-opt-dir=/opt/bia --disable-install-doc"
# We're going to reset bindir/sbindir so we should preserve all the rest
CONFIGURE_OPTS_64="--prefix=$PREFIX
    --sysconfdir=$SYSCONFDIR
    --includedir=$PREFIX/include
    --bindir=$PREFIX/bin
    --sbindir=$PREFIX/sbin
    --libdir=$PREFIX/lib
    --libexecdir=$PREFIX/libexec
    --target=x86_64-pc-solaris2.11"


export CLFAGS="-I/usr/include/openssl"
export EXTLIBS=-lm
export CPPFLAGS="-I/usr/include/libelf -I/usr/include -I/usr/lib/libffi-3.0.10/include"

init
download_source $PROG $PROG $VER
VER=${VER/-p/.}
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: