# Makefile                                                       -*-GNU Make-*-

# =============================================================================
#                                 DEPENDENCIES
# =============================================================================

include make/hlm_add_cpp_library.mk

# =============================================================================
#                            CONFIGURATION OPTIONS
# =============================================================================

CPP_COMPILER       = g++-7
CPP_COMPILER_FLAGS = -std=c++17 -pedantic -Wall -Werror -Wextra

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

# TODO(nate): Refactory the library makefile targets so that different
#             attributes (headers, objects, archives) are built with
#             different targets (eg. hls-headers, hls-objects, etc...)

# 'hls' package
# Note that 'hls', being the lowest level library, has no dependencies.
$(eval $(call HLM_ADD_CPP_LIBRARY,hls,,         \
                                  hls_allocator \
                                  hls_integer   \
                                  hls_vector   ))

# 'hlcc' package
$(eval $(call HLM_ADD_CPP_LIBRARY,hlcc,            \
                                  hls,             \
                                  hlcc_instruction \
                                  hlcc_opcode     ))

# Programs  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.DEFAULT_GOAL := all
.PHONY : all
all : hlcc hls

# System Macros - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.PHONY : clean
clean :
	@echo "Deleting build directory"
	@rm -r  $(BUILD_DIR)

