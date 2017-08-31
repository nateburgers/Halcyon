# Makefile                                                       -*-GNU Make-*-

# =============================================================================
#                                 DEPENDENCIES
# =============================================================================

include make/hlm_add_cpp_library.mk

# =============================================================================
#                            CONFIGURATION OPTIONS
# =============================================================================
.DEFAULT_GOAL := all

CPP_COMPILER       = g++
CPP_COMPILER_FLAGS = -std=c++17 -pedantic -Wall -Werror -Wextra \
                     -Isrc

LINKER       = gcc
LINKER_FLAGS =

ARCHIVER = ar

SOURCE_DIR = src

BUILD_DIR   = build
BINARY_DIR  = $(BUILD_DIR)/bin
HEADER_DIR  = $(BUILD_DIR)/include
LIBRARY_DIR = $(BUILD_DIR)/lib
OBJECT_DIR  = $(BUILD_DIR)/obj

# =============================================================================
#                                    RULES
# =============================================================================

# Packages  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# 'hls' package
$(eval $(call HLM_ADD_CPP_LIBRARY,hls,,\
	                              hls_integer))

# 'hlcc' package
$(eval $(call HLM_ADD_CPP_LIBRARY,hlcc,hls,        \
	                              hlcc_instruction \
                                  hlcc_opcode))

# Programs  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.PHONY : all
all : hlcc hls

# System Macros - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.PHONY : clean
clean :
	@echo "Deleting build directory"
	@rm -r  $(BUILD_DIR)

