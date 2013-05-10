#!/bin/bash
#
# Copyright © 2013 Vincent Sanders <vince@netsurf-browser.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
#   * The above copyright notice and this permission notice shall be included in
#     all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# NetSurf continuius integration build script for jenkins
#
# This script may be executed by jenkins jobs that use the core buildsystem


# The target for built artifacts - This does mean the artifacts of a
#  target must all be built on the same slave instance
ARTIFACT_HOME=${JENKINS_HOME}/artifacts-${TARGET}

# Ensure the artifact target directory exists 
mkdir -p ${ARTIFACT_HOME}
# Configure all build paths relative to prefix
export PREFIX=${ARTIFACT_HOME}
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PREFIX}/lib
export PATH=${PATH}:${PREFIX}/bin

# Obtain the native target
#NATIVE_TARGET=$(uname -s)
# Currently most tests do not work on targets except for Linux
NATIVE_TARGET="Linux" 

# currently core buildsystem doesnt use triplets so we need to adjust for that
case ${TARGET} in
    "m68k-atari-mint")
	make clean TARGET=atari
	make install TARGET=atari
	;;

    "m5475-atari-mint")
	make clean TARGET=m5475_atari
	make install TARGET=m5475_atari
	;;

    *)
	make clean
	make
        # run the tests on native platforms
	if [ "${TARGET}" = "${NATIVE_TARGET}" ]; then
	    make test
	fi
	make install
	;;
esac
