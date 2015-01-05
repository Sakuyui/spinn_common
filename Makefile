# If SPINN_DIRS is not defined, this is an error!
ifndef SPINN_DIRS
    $(error SPINN_DIRS is not set.  Please define SPINN_DIRS (possibly by running "source setup" in the spinnaker tools folder))
endif

SPINN_COMMON_BUILD = build
include $(SPINN_DIRS)/Makefile.common

# General tool setup
CAT = cat
LS  = ls -l
MKDIR = mkdir -p
CP  = cp

# Libraries
ifneq ($(GNU), 1)
    LIBS = $(SPINN_LIB_DIR)/libspin1_api.a
else
    LIBS = $(SPINN_LIB_DIR)/spin1_api.a
endif

# Include our own include directory
CFLAGS += -I include

# Objects
OBJS = bit_field.o normal.o random.o stdfix-exp.o
BUILD_OBJS = $(OBJS:%.o=$(SPINN_COMMON_BUILD)/%.o)

# Headers
HEADERS = arm_acle_gcc.h arm_acle.h arm.h bit_field.h cmsis.h core_v5te.h debug.h log.h normal.h pair.h polynomial.h random.h sincos.h spin-print.h static-assert.h stdfix-exp.h stdfix-full-iso.h utils.h
INSTALL_HEADERS = $(HEADERS:%.h=$(SPINN_INC_DIR)/%.h)

# Build rules (default)
$(SPINN_COMMON_BUILD)/libspinn_common.a: $(BUILD_OBJS) 
	$(RM) $@
	$(AR) $@ $(BUILD_OBJS)

$(SPINN_COMMON_BUILD)/%.o: src/%.c $(SPINN_COMMON_BUILD)
	$(CC) $(CFLAGS) -o $@ $<

$(SPINN_COMMON_BUILD):
	$(MKDIR) $@

# Installing rules
install: $(SPINN_LIB_DIR)/libspinn_common.a $(INSTALL_HEADERS)

$(SPINN_LIB_DIR)/libspinn_common.a: $(SPINN_COMMON_BUILD)/libspinn_common.a
	$(CP) $< $@

$(SPINN_INC_DIR)/%.h: include/%.h
	$(CP) $< $@

clean:
	$(RM) $(SPINN_COMMON_BUILD)/libspinn_common.a $(BUILD_OBJS)
