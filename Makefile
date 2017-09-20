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

OCAML_INCLUDE_DIR = $(BUILD_DIR)/ocaml_include
OCAML_OBJECT_DIR  = $(BUILD_DIR)/ocaml_obj
OCAML_LIBRARY_DIR = $(BUILD_DIR)/ocaml_lib

# =============================================================================
#                                    RULES
# =============================================================================

define HLM_ADD_OCAML_MODULE

$(2)_ML  := $(SOURCE_DIR)/$(1)/$(2).ml
$(2)_MLI := $(SOURCE_DIR)/$(1)/$(2).mli

$(2)_INTERFACE := $(OCAML_INCLUDE_DIR)/$(2).cmi
$(2)_OBJECT    := $(OCAML_OBJECT_DIR)/$(2).cmx

$(2)_DEPENDENCY_INTERFACES := $(foreach MODULE,$(3),$$($(MODULE)_INTERFACE))
$(2)_DEPENDENCY_OBJECTS    := $(foreach MODULE,$(3),$$($(MODULE)_OBJECT))

.PHONY: $(2)
$(2): $(2)-interface \
      $(2)-object

.PHONY: $(2)-interface
$(2)-interface: $$($(2)_INTERFACE)

.PHONY: $(2)-object
$(2)-object: $$($(2)_OBJECT)

$$($(2)_INTERFACE): $$($(2)_MLI)                   \
                    $$($(2)_DEPENDENCY_INTERFACES) \
					$$($(2)_DEPENDENCY_OBJECTS)
	@if [ ! -d "$(OCAML_INCLUDE_DIR)" ]; then mkdir -p $(OCAML_INCLUDE_DIR); fi
	ocamlopt -I $(OCAML_INCLUDE_DIR) \
	         -c $$($(2)_MLI)         \
	         -o $$($(2)_INTERFACE)

$$($(2)_OBJECT): $$($(2)_ML)                 \
                 $$($(2)_MLI)                \
                 $$($(2)_INTERFACE)          \
                 $$($(2)_DEPENDENCY_OBJECTS)
	@if [ ! -d "$(OCAML_OBJECT_DIR)" ]; then mkdir -p $(OCAML_OBJECT_DIR); fi
	ocamlopt -I $(OCAML_INCLUDE_DIR)        \
	         -I $(OCAML_OBJECT_DIR)         \
	         -c $$($(2)_ML)                 \
	         -o $$($(2)_OBJECT)

endef

define HLM_ADD_OCAML_PACKAGE


$(1)_INTERFACES := $(foreach MODULE,$(2),$$($(MODULE)_INTERFACE))
$(1)_OBJECTS    := $(foreach MODULE,$(2),$$($(MODULE)_OBJECT))
$(1)_ARCHIVE    := $(OCAML_LIBRARY_DIR)/$(1).cmxa

.PHONY: $(1)
$(1): $(1)-interfaces \
      $(1)-objects    \
      $(1)-archive

.PHONY: $(1)-interfaces
$(1)-interfaces: $$($(1)_INTERFACES)

.PHONY: $(1)-objects
$(1)-objects: $$($(1)_OBJECTS)

.PHONY: $(1)-archive
$(1)-archive: $$($(1)_ARCHIVE)

$$($(1)_ARCHIVE): $$($(1)_OBJECTS)
	@if [ ! -d "$(OCAML_LIBRARY_DIR)" ]; then mkdir -p $(OCAML_LIBRARY_DIR); fi
	ocamlopt -a -o $$($(1)_ARCHIVE) $$($(1)_OBJECTS)

endef

# OCaml Packages  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$(eval $(call HLM_ADD_OCAML_MODULE,mlco,mlco_type,))
$(eval $(call HLM_ADD_OCAML_MODULE,mlco,mlco_expression,mlco_type))

$(eval $(call HLM_ADD_OCAML_PACKAGE,mlco,mlco_expression \
										 mlco_type      ))

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
