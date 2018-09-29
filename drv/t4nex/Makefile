#
# drv/t4nex/Makefile
#

TOP=../..

include	../Makefile.common

CXGBE_FW_OBJS	=	t4_fw.o t4_cfg.o t5_cfg.o t5_fw.o t6_cfg.o t6_fw.o
CXGBE_COM_OBJS	=	t4_hw.o
CXGBE_SHR_OBJS	=	shared.o
CXGBE_NEX_OBJS	=	t4_nexus.o t4_sge.o t4_mac.o t4_ioctl.o t4_l2t.o osdep.o

T4NEX_OBJS	=	$(CXGBE_FW_OBJS) \
			$(CXGBE_COM_OBJS) \
			$(CXGBE_SHR_OBJS) \
			$(CXGBE_NEX_OBJS)

# Override the object list
OBJS		=	$(T4NEX_OBJS:%.o=$(TOP)/obj.$(ISA)/%.o)

MODNAME		=	t4nex
SRCS		=	$(CXGBE_NEX_OBJS:%.o=%.c) \
			$(CXGBE_COM_OBJS:%.o=common/%.c) \
			$(CXGBE_SHR_OBJS:%.o=shared/%.c) \
			$(CXGBE_FW_OBJS:%.o=firmware/%.c)

HDRS		=
		
LDFLAGS		+=	-dy -Nmisc/mac -Nmisc/gld -N drv/ip

CFLAGS		+=	-Icommon -Ishared -Ifirmware -I. \
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
