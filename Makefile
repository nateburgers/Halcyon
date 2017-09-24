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
BINARY_DIR  = $(BUILD_DIR)/programs
DOCS_DIR    = $(BUILD_DIR)/documentation
HEADER_DIR  = $(BUILD_DIR)/include
LIBRARY_DIR = $(BUILD_DIR)/libraries
OBJECT_DIR  = $(BUILD_DIR)/objects

# =============================================================================
#                                    RULES
# =============================================================================

# HLM_ADD_OCAML_MODULE  - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
define HLM_ADD_OCAML_MODULE

$(2)_ML  := $(SOURCE_DIR)/$(1)/$(2).ml
$(2)_MLI := $(SOURCE_DIR)/$(1)/$(2).mli

$(2)_INTERFACE := $(INCLUDE_DIR)/$(2).cmi
$(2)_OBJECT    := $(OBJECT_DIR)/$(2).cmx

.PHONY: $(2)
$(2): $(2)-interface \
      $(2)-object

.PHONY: $(2)-interface
$(2)-interface: $$($(2)_INTERFACE)

.PHONY: $(2)-object
$(2)-object: $$($(2)_OBJECT)

$$($(2)_INTERFACE): $$($(2)_MLI)
	@if [ ! -d "$(INCLUDE_DIR)" ]; then mkdir -p $(INCLUDE_DIR); fi
	ocamlopt -c $$($(2)_MLI)        \
	         -opaque                \
	         -o $$($(2)_INTERFACE)

$$($(2)_OBJECT): $$($(2)_ML)        \
                 $$($(2)_MLI)       \
                 $$($(2)_INTERFACE)
	@if [ ! -d "$(OCAML_OBJECT_DIR)" ]; then mkdir -p $(OCAML_OBJECT_DIR); fi
	ocamlopt -I $(OCAML_INCLUDE_DIR) \
	         -I $(OCAML_OBJECT_DIR)  \
	         -c $$($(2)_ML)          \
	         -o $$($(2)_OBJECT)

endef

# HLM_ADD_OCAML_PACKAGE - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
define HLM_ADD_OCAML_PACKAGE

$(1)_MODULES    := $(foreach MODULE,$(2),$(SOURCE_DIR)/$(1)/$(MODULE).ml)
$(1)_INTERFACES := $(foreach MODULE,$(2),$(SOURCE_DIR)/$(1)/$(MODULE).mli)
$(1)_ARCHIVE    := $(LIBRARY_DIR)/$(1).cmxa

$(1)_OBJECTS    := $(foreach MODULE,$(2),$(OBJECT_DIR)/$(MODULE).cmx)

.PHONY: $(1)
$(1): $(1)-archive

.PHONY: $(1)-interfaces
$(1)-interfaces: $$($(1)_INTERFACES)

.PHONY: $(1)-objects
$(1)-objects: $$($(1)_OBJECTS)

.PHONY: $(1)-archive
$(1)-archive: $$($(1)_ARCHIVE)

$$($(1)_ARCHIVE): $$($(1)_MODULES)    \
                  $$($(1)_INTERFACES)
	@if [ ! -d "$(HEADER_DIR)" ]; then mkdir -p $(HEADER_DIR); fi
	@if [ ! -d "$(OBJECT_DIR)" ]; then mkdir -p $(OBJECT_DIR); fi
	@if [ ! -d "$(LIBRARY_DIR)" ]; then mkdir -p $(LIBRARY_DIR); fi
	ocamlopt $(foreach MODULE,$(2),                            \
	                       -c $(SOURCE_DIR)/$(1)/$(MODULE).mli)
	ocamlopt -I $(HEADER_DIR)                                   \
	         -c $(foreach MODULE,$(2),                          \
	                          -o $(OBJECT_DIR)/$(MODULE).cmx    \
	                             $(SOURCE_DIR)/$(1)/$(MODULE).ml)
	ocamlopt -a -o $$($(1)_ARCHIVE) $$($(1)_OBJECTS)

endef

# HLM_OCAML_PACKAGE - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

define HLM_OCAML_MODULE

$(HEADER_DIR)/$(2).cmi: src/$(1)/$(2).mli
	@if [ ! -d "$(HEADER_DIR)"  ]; then mkdir -p $(HEADER_DIR);  fi
	@if [ ! -d "$(OBJECT_DIR)"  ]; then mkdir -p $(OBJECT_DIR);  fi
	ocamlopt -I $(HEADER_DIR) -c -o $(HEADER_DIR)/$(2).cmi src/$(1)/$(2).mli

$(OBJECT_DIR)/$(2).cmx: src/$(1)/$(2).ml
	@if [ ! -d "$(HEADER_DIR)"  ]; then mkdir -p $(HEADER_DIR);  fi
	@if [ ! -d "$(OBJECT_DIR)"  ]; then mkdir -p $(OBJECT_DIR);  fi
	ocamlopt -I $(HEADER_DIR) -I $(OBJECT_DIR) -c -o $(OBJECT_DIR)/$(2).cmx src/$(1)/$(2).ml

endef

define HLM_OCAML_PACKAGE

$(1)_MEMBERS := $(strip $(shell cat src/$(1)/package/$(1).mem))

$(1)_ARCHIVE    := $(LIBRARY_DIR)/$(1).cmxa
$(1)_MODULES    := $$(foreach MODULE,$$($(1)_MEMBERS),src/$(1)/$$(MODULE).ml)
$(1)_INTERFACES := $$(foreach MODULE,$$($(1)_MEMBERS),src/$(1)/$$(MODULE).mli)

$(1)_COMPILED_INTERFACES := $$(foreach MODULE,$$($(1)_MEMBERS),$(HEADER_DIR)/$$(MODULE).cmi)
$(1)_COMPILED_MODULES    := $$(foreach MODULE,$$($(1)_MEMBERS),$(OBJECT_DIR)/$$(MODULE).cmx)

$$(eval $$(foreach MODULE,$$($(1)_MEMBERS),$$(call HLM_OCAML_MODULE,$(1),$$(MODULE))))

.PHONY : $(1)
$(1) : $(1)-archive

.PHONY : $(1)-archive
$(1)-archive : $$($(1)_ARCHIVE)

.PHONY : $$($(1)_ARCHIVE)
$$($(1)_ARCHIVE): $$($(1)_COMPILED_INTERFACES) $$($(1)_COMPILED_MODULES)
	@if [ ! -d "$(HEADER_DIR)"  ]; then mkdir -p $(HEADER_DIR);  fi
	@if [ ! -d "$(OBJECT_DIR)"  ]; then mkdir -p $(OBJECT_DIR);  fi
	@if [ ! -d "$(LIBRARY_DIR)" ]; then mkdir -p $(LIBRARY_DIR); fi

endef

# OCaml Packages  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# 'mlco' package
#$(eval $(call HLM_ADD_OCAML_MODULE,mlco,mlco_expression))
#$(eval $(call HLM_ADD_OCAML_MODULE,mlco,mlco_type))

#$(eval $(call HLM_ADD_OCAML_PACKAGE,mlco,mlco_expression \
#                                         mlco_type      ))

$(eval $(call HLM_OCAML_PACKAGE,mlco))

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
