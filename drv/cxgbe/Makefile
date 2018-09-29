#
# drv/cxgbe/Makefile
#

TOP=../..

include	../Makefile.common

CXGBE_OBJS	=	cxgbe.o

MODNAME		=	cxgbe
SRCS		=	cxgbe.c
HDRS		=	

LDFLAGS		+=	-dy -N drv/ip -Nmisc/mac

CFLAGS		+=	-I../t4nex/shared -I../t4nex \
			-DCONFIG_CHELSIO_T1_1G \
			-DCONFIG_SMP \
			-DRX_MAX_COUNT=256 \
			-DCONFIG_CHELSIO_T1_OFFLOAD \
			-DSUN_KSTATS \
			-DHOST_PAUSE \
			-DTX_CKSUM_FIX \
			-DTX_THREAD_RECLAIM

# DEBUG FLAGS, we aren't using them
# CFLAGS += -DCH_DEBUG -DPE_DBGOUT -DPE_DBGOUT_ENABLED=1

include ../Makefile.drv
