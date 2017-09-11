# Makefile                                                       -*-GNU Make-*-

# =============================================================================
#                                 DEPENDENCIES
# =============================================================================

include make/hlm_add_cpp_library.mk

# =============================================================================
#                             CONFIGURATION OPTIONS
# =============================================================================

CPP_COMPILER       = g++-7
CPP_COMPILER_FLAGS = -std=c++17 -pedantic -Wall -Werror -Wextra

LINKER       = gcc
LINKER_FLAGS =

ARCHIVER = ar

SOURCE_DIR = src

BUILD_DIR   = build
BINARY_DIR  = $(BUILD_DIR)/bin
DOCS_DIR    = $(BUILD_DIR)/doc
HEADER_DIR  = $(BUILD_DIR)/include
LIBRARY_DIR = $(BUILD_DIR)/lib
OBJECT_DIR  = $(BUILD_DIR)/obj

# =============================================================================
#                                    RULES
# =============================================================================

# Packages  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# The following packages shall be listed in dependency order, where packages
# having the same dependency level shall be listed in alphanumeric order.
# Additionally, the dependencies and components of each package shall be listed
# in alphanumeric order within a package declaration.

# 'hls' package
$(eval $(call HLM_ADD_DEPENDENCY_FREE_CPP_LIBRARY,hls,          \
                                                  hls_allocator \
												  hls_boolean   \
												  hls_buffer    \
												  hls_false     \
                                                  hls_integer   \
												  hls_natural   \
												  hls_new       \
												  hls_size      \
												  hls_true      \
												  hls_typeutil  \
                                                  hls_union     \
												  hls_variant  ))

# 'hlcc' package
$(eval $(call HLM_ADD_CPP_LIBRARY,hlcc,            \
                                  hls,             \
                                  hlcc_instruction \
                                  hlcc_opcode     ))

# Documentation - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.PHONY: docs
docs: $(hlcc_SOURCE_HEADERS) \
      $(hls_SOURCE_HEADERS)
	@echo "Creating documentation"
	@mkdir -p $(DOCS_DIR)
	@doxygen >/dev/null

# Project - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.DEFAULT_GOAL := all
.PHONY: all
all: hlcc \
     hls

.PHONY: archives
archives: hlcc-archive \
          hls-archive

.PHONY: clean
clean:
	@echo "Removing build directory"
	@if [ -d "$(BUILD_DIR)" ] ; then rm -rf $(BUILD_DIR) ; fi

.PHONY: format
format: format-hlcc \
        format-hls

.PHONY: format-headers
format-headers: format-hlcc-headers \
                format-hls-headers

.PHONY: format-sources
format: format-hlcc-sources \
        format-hls-sources

.PHONY: headers
headers: hlcc-headers \
         hls-headers

.PHONY: objects
objects: hlcc-objects \
         hls-objects
