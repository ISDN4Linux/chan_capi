#
# Copyright (c) 2012 Hans Petter Selasky. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
#
# Makefile for Asterisk PBX CAPI channel driver
#

VERSION=2.0.16
CONFIGFILE=${.CURDIR}/config.h
GREP?=grep

#
# For FreeBSD:
#
PREFIX?=/usr/local
INCLUDEDIR?=${PREFIX}/include
LIBDIR?=${PREFIX}/lib/asterisk/modules
ETCDIR?=${PREFIX}/etc/asterisk
MANDIR?=${PREFIX}/man/man

#
# For NetBSD:
#
# PREFIX?=/usr/pkg
# INCLUDEDIR?=${PREFIX}/include
# LIBDIR?=${PREFIX}/lib/asterisk/modules
# ETCDIR?=${PREFIX}/etc/asterisk
# MANDIR?=${PREFIX}/man/man
#

#
# For Linux:
#
# PREFIX?=/usr
# INCLUDEDIR?=${PREFIX}/include
# LIBDIR?=${PREFIX}/lib/asterisk/modules
# ETCDIR?=/etc/asterisk
# MANDIR?=${PREFIX}/man/man
#

SHLIB_NAME=	chan_capi.so

CFLAGS+=	-D_GNU_SOURCE
CFLAGS+=	-D_REENTRANT
CFLAGS+=	-DCRYPTO
CFLAGS+=	-fblocks

MKLINT=		no
WARNS=		3

NO_WERROR=
NOGCCERROR=
NO_PROFILE=

.if defined(HAVE_DEBUG)
CFLAGS+=	-DHAVE_DEBUG
CFLAGS+=	-g
.endif

DPADD+=         ${LIBCAPI20}
LDADD+=         -lcapi20

INCS=
MAN=

CFLAGS+=	-I${INCLUDEDIR}
LDFLAGS+=	-L${PREFIX}/lib

SRCS+=	c20msg.c
SRCS+=	chan_capi.c
SRCS+=  config.h

FILES+= capi.conf.sample
FILESDIR=${ETCDIR}

CLEANFILES+= config.h

config.h: ${.CURDIR}/Makefile
	rm -f ${CONFIGFILE}
	touch ${CONFIGFILE}

	@echo ""
	@echo "Configuring ..."
	@echo ""

	@echo "/*" >> ${CONFIGFILE}
	@echo " * automatically generated by Makefile $(date)" >> ${CONFIGFILE}
	@echo " */" >> ${CONFIGFILE}
	@echo >> ${CONFIGFILE}
	@echo "#ifndef _CHAN_CAPI_CONFIG_H" >> ${CONFIGFILE}
	@echo "#define _CHAN_CAPI_CONFIG_H" >> ${CONFIGFILE}
	@echo >> ${CONFIGFILE}

	@echo "#define ASTERISKVERSION \"${VERSION}\"" >> ${CONFIGFILE}
	@echo "" >> ${CONFIGFILE}

	@((${GREP} -q "ast_moh_start" ${INCLUDEDIR}/asterisk/musiconhold.h) && ( \
	echo "#define CC_AST_MOH_PRESENT" >> ${CONFIGFILE} ; \
	echo " * Found: ast_moh_start" \
	)) || ( \
	echo "#undef CC_AST_MOH_PRESENT" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_moh_start" \
	)

	@((${GREP} -q "struct ast_codec_pref" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#undef CC_OLD_CODEC_FORMATS" >> ${CONFIGFILE} ; \
	echo " * Found: struct ast_codec_pref" ; \
	)) || ( \
	((${GREP} -q "struct ast_codec_pref" ${INCLUDEDIR}/asterisk/format_pref.h) && ( \
	echo "#undef CC_OLD_CODEC_FORMATS" >> ${CONFIGFILE} ; \
	echo " * Found: struct ast_codec_pref" ; \
	)) || ( \
	echo "#define CC_OLD_CODEC_FORMATS" >> ${CONFIGFILE} ; \
	echo " * Not Found: struct ast_codec_pref" ; \
	) \
	)

	@((${GREP} -q "struct ast_channel_tech" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_HAVE_TECH_PVT" >> ${CONFIGFILE} ; \
	echo " * Found: struct ast_channel_tech" ; \
	)) || ( \
	echo "#undef CC_AST_HAVE_TECH_PVT" >> ${CONFIGFILE} ; \
	echo " * Not Found: struct ast_channel_tech, using old pvt" ; \
	)

	@((${GREP} -q "ast_bridged_channel" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_HAS_BRIDGED_CHANNEL" >> ${CONFIGFILE} ; \
	echo " * Found: ast_bridged_channel" ; \
	)) || ( \
	echo "#undef CC_AST_HAS_BRIDGED_CHANNEL" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_bridged_channel" ; \
	)

	@((${GREP} -q "ast_bridge_result" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_HAS_BRIDGE_RESULT" >> ${CONFIGFILE} ; \
	echo " * Found: ast_bridge_result" ; \
	)) || ( \
	echo "#undef CC_AST_HAS_BRIDGE_RESULT" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_bridge_result" ; \
	)

	@((${GREP} -q "struct ast_channel ..rc, int timeoutms" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_BRIDGE_WITH_TIMEOUTMS" >> ${CONFIGFILE} ; \
	echo " * Found: Bridge with timeoutms" ; \
	)) || ( \
	echo "#undef CC_AST_BRIDGE_WITH_TIMEOUTMS" >> ${CONFIGFILE} ; \
	echo " * Not Found: Timeoutms in bridge" ; \
	)

	@((${GREP} -q "ast_dsp_process.struct.*needlock" ${INCLUDEDIR}/asterisk/dsp.h) && ( \
	echo "#define CC_AST_DSP_PROCESS_NEEDLOCK" >> ${CONFIGFILE} ; \
	echo " * Found: ast_dsp_process() needs needlock" ; \
	)) || ( \
	echo "#undef CC_AST_DSP_PROCESS_NEEDLOCK" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_dsp_process() needs needlock" ; \
	)

	@((${GREP} -q "ast_dsp_set_digitmode" ${INCLUDEDIR}/asterisk/dsp.h) && ( \
	echo "#define CC_AST_DSP_SET_DIGITMODE" >> ${CONFIGFILE} ; \
	echo " * Found: ast_dsp_set_digitmode" ; \
	)) || ( \
	echo "#undef CC_AST_DSP_SET_DIGITMODE" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_dsp_set_digitmode" ; \
	)

	@((${GREP} -q "struct ast_callerid" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_CHANNEL_HAS_CID" >> ${CONFIGFILE} ; \
	echo " * Found: struct ast_callerid" ; \
	)) || ( \
	echo "#undef CC_AST_CHANNEL_HAS_CID" >> ${CONFIGFILE} ; \
	echo " * Not Found: struct ast_callerid" ; \
	)

	@((${GREP} -q "struct timeval delivery" ${INCLUDEDIR}/asterisk/frame.h) && ( \
	echo "#define CC_AST_FRAME_HAS_TIMEVAL" >> ${CONFIGFILE} ; \
	echo " * Found: struct timeval delivery" ; \
	)) || ( \
	echo "#undef CC_AST_FRAME_HAS_TIMEVAL" >> ${CONFIGFILE} ; \
	echo " * Not Found: struct timeval delivery" ; \
	)

	@((${GREP} -q "transfercapability" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_CHANNEL_HAS_TRANSFERCAP" >> ${CONFIGFILE} ; \
	echo " * Found: transfercapability" ; \
	)) || ( \
	echo "#undef CC_AST_CHANNEL_HAS_TRANSFERCAP" >> ${CONFIGFILE} ; \
	echo " * Not Found: transfercapability" ; \
	)

	@((${GREP} -q "ast_set_read_format(" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_HAVE_SET_READ_FORMAT" >> ${CONFIGFILE} ; \
	echo " * Found: ast_set_read_format" ; \
	)) || ( \
	echo "#undef CC_AST_HAVE_SET_READ_FORMAT" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_set_read_format" ; \
	)

	@((${GREP} -q "ast_set_write_format(" ${INCLUDEDIR}/asterisk/channel.h) && ( \
	echo "#define CC_AST_HAVE_SET_WRITE_FORMAT" >> ${CONFIGFILE} ; \
	echo " * Found: ast_set_write_format" ; \
	)) || ( \
	echo "#undef CC_AST_HAVE_SET_WRITE_FORMAT" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_set_write_format" ; \
	)

	@((${GREP} -q "ast_config_load" ${INCLUDEDIR}/asterisk/config.h) && ( \
	echo " * Found: ast_config_load" ; \
	)) || ( \
	echo "#define ast_config_load(x) ast_load(x)" >> ${CONFIGFILE} ; \
	echo "#define ast_config_destroy(x) ast_destroy(x)" >> ${CONFIGFILE} ; \
	echo " * Not Found: ast_config_load" ; \
	)

	@((${GREP} -q "AST_CONTROL_HOLD" ${INCLUDEDIR}/asterisk/frame.h) && ( \
	echo "#define CC_AST_CONTROL_HOLD" >> ${CONFIGFILE} ; \
	echo " * Found: AST_CONTROL_HOLD" ; \
	)) || ( \
	echo "#undef CC_AST_CONTROL_HOLD" >> ${CONFIGFILE} ; \
	echo " * Not Found: AST_CONTROL_HOLD" ; \
	)

	@((${GREP} -q "struct ast_custom_function " ${INCLUDEDIR}/asterisk/pbx.h) && ( \
	echo "#define CC_AST_CUSTOM_FUNCTION" >> ${CONFIGFILE} ; \
	echo " * Found: struct ast_custom_function" ; \
	)) || ( \
	echo "#undef CC_AST_CUSTOM_FUNCTION" >> ${CONFIGFILE} ; \
	echo " * Not Found: struct ast_custom_function" ; \
	)

.if exists(${INCLUDEDIR}/asterisk/devicestate.h)
	@echo "#undef CC_AST_NO_DEVICESTATE" >> ${CONFIGFILE}
	@echo " * Found: devicestate.h"
.else
	@echo "#define CC_AST_NO_DEVICESTATE" >> ${CONFIGFILE}
	@echo " * Not Found: devicestate.h"
.endif

	@echo "#define ___CC_AST_VERSION(a,b) a##b" >> ${CONFIGFILE}
	@echo "#define __CC_AST_VERSION(a,b) ___CC_AST_VERSION(a,b)" >> ${CONFIGFILE}

	@((${GREP} -q "ASTERISK_VERSION_NUM.*108" ${INCLUDEDIR}/asterisk/version.h) && ( \
	echo "#define CC_AST_VERSION __CC_AST_VERSION(0x,ASTERISK_VERSION_NUM)" >> ${CONFIGFILE} ; \
	echo " * Found: Asterisk version 1.8.x" ; \
	)) || ( \
	((${GREP} -q "ASTERISK_VERSION_NUM.*106" ${INCLUDEDIR}/asterisk/version.h) && ( \
	echo "#define CC_AST_VERSION __CC_AST_VERSION(0x,ASTERISK_VERSION_NUM)" >> ${CONFIGFILE} ; \
	echo " * Found: Asterisk version 1.6.x" ; \
	)) || ( \
	((${GREP} -q "ASTERISK_VERSION_NUM.*104" ${INCLUDEDIR}/asterisk/version.h) && ( \
	echo "#define CC_AST_VERSION __CC_AST_VERSION(0x,ASTERISK_VERSION_NUM)" >> ${CONFIGFILE} ; \
	echo " * Found: Asterisk version 1.4.x" ; \
	)) || ( \
	((${GREP} -q "ASTERISK_VERSION_NUM.*0102" ${INCLUDEDIR}/asterisk/version.h) && ( \
	echo "#define CC_AST_VERSION __CC_AST_VERSION(0x,ASTERISK_VERSION_NUM)" >> ${CONFIGFILE} ; \
	echo " * Found: Asterisk version 1.2.x" ; \
	)) || ( \
	((${GREP} -q "ASTERISK_VERSION_NUM[ 	]*10" ${INCLUDEDIR}/asterisk/version.h) && ( \
	echo "#define CC_AST_VERSION __CC_AST_VERSION(0x,ASTERISK_VERSION_NUM)" >> ${CONFIGFILE} ; \
	echo " * Found: Asterisk version 10.1.x" ; \
	)) || ( \
	(([ -f ${INCLUDEDIR}/asterisk/ast_version.h ] && ( \
	echo "#define CC_AST_VERSION __CC_AST_VERSION(0x,110000)" >> ${CONFIGFILE} ; \
	echo "#define CC_AST_NO_VERSION" >> ${CONFIGFILE} ; \
	echo " * Found: Asterisk version 11.1.x or compatible" ; \
	)) || ( \
	echo " * Not Found: Asterisk version" ; \
	exit 1 ; \
	) \
	) \
	) \
	) \
	) \
	) \
	)

.if exists(${INCLUDEDIR}/asterisk/version.h)
	@echo "#ifndef CC_AST_NO_VERSION" >> ${CONFIGFILE}
	@echo "#include <asterisk/version.h>" >> ${CONFIGFILE}
	@echo "#endif" >> ${CONFIGFILE}
	@echo " * Found: version.h"
.else
	@echo " * Not found: version.h"
.endif

	@echo "" >> ${CONFIGFILE}
	@echo "#endif /* _CHAN_CAPI_CONFIG_H */" >> ${CONFIGFILE}
	@echo "" >> ${CONFIGFILE}

package:

	make clean cleandepend HAVE_MAN=YES

	tar -cvf temp.tar --exclude="*~" --exclude="*#" \
		--exclude=".svn" --exclude="*.orig" --exclude="*.rej" \
		Makefile c20msg.c c20msg.h chan_capi.c chan_capi.h \
		chan_capi20.h xlaw.h \
		capi.conf capi.conf.sample \
		extensions.conf.sample \
		README CHANGES INSTALL LICENSE

	rm -rf chan_capi-${VERSION}

	mkdir chan_capi-${VERSION}

	tar -xvf temp.tar -C chan_capi-${VERSION}

	rm -rf temp.tar

	tar -jcvf chan_capi-${VERSION}.tar.bz2 chan_capi-${VERSION}

.include <bsd.lib.mk>
