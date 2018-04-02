# Makefile                                                       -*-GNU Make-*-

# =============================================================================
#                                 DEPENDENCIES
# =============================================================================

include make/define_dir.mk
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

$(call DEFINE_DIR,BUILD_DIR,build)
$(call DEFINE_DIR,PROGRAM_DIR,$(BUILD_DIR)/programs)
$(call DEFINE_DIR,DOCUMENTATION_DIR,$(BUILD_DIR)/documentation)
$(call DEFINE_DIR,INCLUDE_DIR,$(BUILD_DIR)/include)
$(call DEFINE_DIR,LIBRARY_DIR,$(BUILD_DIR)/libraries)
$(call DEFINE_DIR,OBJECT_DIR,$(BUILD_DIR)/objects)

# =============================================================================
#                                    RULES
# =============================================================================

.RECIPEPREFIX = ~

# DEFINE_OCAML_MODULE - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DEFINE_OCAML_MODULE = $(eval $(call _DEFINE_OCAML_MODULE,$(1),$(2)))

define _DEFINE_OCAML_MODULE

$(INCLUDE_DIR)/$(2).cmi: src/$(1)/$(2).mli    \
                         $(INCLUDE_DIR_STAMP) \
                         $(OBJECT_DIR_STAMP)
~ ocamlopt -I $(INCLUDE_DIR) -c -o $(INCLUDE_DIR)/$(2).cmi src/$(1)/$(2).mli

$(OBJECT_DIR)/$(2).cmx: src/$(1)/$(2).ml
~ ocamlopt -I $(INCLUDE_DIR)            \
           -I $(OBJECT_DIR)             \
           -c -o $(OBJECT_DIR)/$(2).cmx \
           src/$(1)/$(2).ml

endef

# DEFINE_OCAML_PACKAGE  - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DEFINE_OCAML_PACKAGE = $(eval $(call _DEFINE_OCAML_PACKAGE,$(1)))

define _DEFINE_OCAML_PACKAGE

$(1)_MEMBERS := $(strip $(shell cat src/$(1)/package/$(1).mem))

$(1)_ARCHIVE    := $(LIBRARY_DIR)/$(1).cmxa
$(1)_MODULES    := $$(foreach MODULE,$$($(1)_MEMBERS),src/$(1)/$$(MODULE).ml)
$(1)_INTERFACES := $$(foreach MODULE,$$($(1)_MEMBERS),src/$(1)/$$(MODULE).mli)

$(1)_COMPILED_INTERFACES := $$(foreach MODULE,$$($(1)_MEMBERS),\
                                              $(INCLUDE_DIR)/$$(MODULE).cmi)
$(1)_COMPILED_MODULES    := $$(foreach MODULE,$$($(1)_MEMBERS),\
                                              $(OBJECT_DIR)/$$(MODULE).cmx)

$$(foreach MODULE,$$($(1)_MEMBERS),\
                  $$(call DEFINE_OCAML_MODULE,$(1),$$(MODULE)))

.PHONY : $(1)
$(1) : $(1)-archive

.PHONY : $(1)-archive
$(1)-archive : $$($(1)_ARCHIVE)

.PHONY : $$($(1)_ARCHIVE)
$$($(1)_ARCHIVE): $$($(1)_COMPILED_INTERFACES) \
                  $$($(1)_COMPILED_MODULES)    \
                  $(INCLUDE_DIR_STAMP)         \
                  $(OBJECT_DIR_STAMP)          \
                  $(LIBRARY_DIR_STAMP)

endef

# OCaml Packages  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# 'mlco' package
$(call DEFINE_OCAML_PACKAGE,mlco)
$(call DEFINE_OCAML_PACKAGE,mls)

# Packages  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# The following packages shall be listed in dependency order, where packages
# having the same dependency level shall be listed in alphanumeric order.
# Additionally, the dependencies and components of each package shall be listed
# in alphanumeric order within a package declaration.

# 'hls' package
#$(eval $(call HLM_ADD_DEPENDENCY_FREE_CPP_LIBRARY,hls,          \
#                                                  hls_allocator \
#                                                  hls_boolean   \
#                                                  hls_buffer    \
#                                                  hls_false     \
#                                                  hls_integer   \
#                                                  hls_natural   \
#                                                  hls_new       \
#                                                  hls_size      \
#                                                  hls_true      \
#                                                  hls_typeutil  \
#                                                  hls_union     \
#                                                  hls_variant  ))
#
## 'hlcc' package
#$(eval $(call HLM_ADD_CPP_LIBRARY,hlcc,            \
#                                  hls,             \
#                                  hlcc_instruction \
#                                  hlcc_opcode     ))
#
# Documentation - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.PHONY: docs
docs: $(hlcc_SOURCE_HEADERS) \
      $(hls_SOURCE_HEADERS)
~ @echo "Creating documentation"
~ @mkdir -p $(DOCS_DIR)
~ @doxygen >/dev/null

# Project - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.DEFAULT_GOAL := all
.PHONY: all
all:
~ ${CPP_COMPILER} ${CPP_COMPILER_FLAGS} src/hlcc/hlcc.cc -o hlcc
~ ./hlcc

.PHONY: archives
archives: hlcc-archive \
          hls-archive

.PHONY: clean
clean:
~ @echo "Removing build directory"
~ @if [ -d "$(BUILD_DIR)" ] ; then rm -rf $(BUILD_DIR) ; fi

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
