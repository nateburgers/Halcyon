# add_ocaml_group.mk
ifndef INCLUDED_ADD_OCAML_GROUP
INCLUDED_ADD_OCAML_GROUP = 1

.RECIPEPREFIX = ~

# READ_LIST -------------------------------------------------------------------
#
READ_LIST = $(strip $(shell cat $(1)))

# ADD_OCAML_MODULE ------------------------------------------------------------
#
define _ADD_OCAML_MODULE

$(HEADER_DIR)/$(3).cmi : $$($(2)_SOURCE_DIR)/$(3).mli
~ ocamlopt -I $(HEADER_DIR) -c -o $(HEADER_DIR)/$(3).cmi      \
                                  $$($(2)_SOURCE_DIR)/$(3).mli

$(OBJECT_DIR)/$(3).cmx : $$($(2)_SOURCE_DIR)/$(2).ml \
                         $$($(2)_HEADERS)            \
                         $$($(2)_DEPENDENCY_HEADERS)
~ ocamlopt -I $(HEADER_DIR) -c -o $(OBJECT_DIR)/$(3).cmx     \
                                  $$($(2)_SOURCE_DIR)/$(3).ml

endef

ADD_OCAML_MODULE = $(eval $(call _ADD_OCAML_MODULE,$(1),$(2),$(3)))

# ADD_OCAML_PACKAGE -----------------------------------------------------------
#
define _ADD_OCAML_PACKAGE

$(2)_SOURCE_DIR := src/$(1)/$(2)

$(2)_DEPENDENCIES := $(call READ_LIST,$$($(2)_SOURCE_DIR)/package/$(2).dep)
$(2)_MODULES      := $(call READ_LIST,$$($(2)_SOURCE_DIR)/package/$(2).mem)

$(2)_HEADERS := $$(foreach MODULE,$$($(2)_MODULES),                \
                                  $$($(2)_SOURCE_DIR)/$(MODULE).mli)
$(2)_SOURCES := $$(foreach MODULE,$$($(2)_MODULES),               \
                                  $$($(2)_SOURCE_DIR)/$(MODULE).ml)

$(2)_COMPILED_HEADERS := $$(foreach MODULE,$$($(2)_MODULES),           \
                                           $(HEADER_DIR)/$$(MODULE).cmi)
$(2)_COMPILED_SOURCES := $$(foreach MODULE,$$($(2)_MODULES),           \
                                           $(OBJECT_DIR)/$$(MODULE).cmx)

$(2)_ARCHIVE := $(LIBRARY_DIR)/$(2).cmxa

$$(foreach MODULE,$$($(2)_MEMBERS),                             \
                  $$(call ADD_OCAML_MODULE,$(1),$(2),$$(MODULE)))

endef

ADD_OCAML_PACKAGE = $(eval $(call _ADD_OCAML_PACKAGE,$(1),$(2)))

# ADD_OCAML_GROUP -------------------------------------------------------------
#
define _ADD_OCAML_GROUP

$(1)_DEPENDENCIES := $(call READ_LIST,src/$(1)/group/$(1).dep)
$(1)_PACKAGES     := $(call READ_LIST,src/$(1)/group/$(1).mem)

$(1)_ARCHIVE := $(LIBRARY_DIR)/$(1).cmxa

endef

ADD_OCAML_GROUP = $(eval $(call _ADD_OCAML_GROUP,$(1)))

endif

# -----------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2017 Nathan Burgers
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# -----------------------------------------------------------------------------
