# hlm_add_cpp_library.mk
ifndef INCLUDED_HLM_ADD_CPP_LIBRARY
INCLUDED_HLM_ADD_CPP_LIBRARY = 1

include make/hlm_add_cpp_components.mk

# HLM_ADD_DEPENDENCY_FREE_CPP_LIBRARY - - - - - - - - - - - - - - - - - - - - -
#
define HLM_ADD_DEPENDENCY_FREE_CPP_LIBRARY

$(eval $(call HLM_ADD_CPP_LIBRARY,$(1),,$(2)))

endef

# HLM_ADD_CPP_LIBRARY - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
define HLM_ADD_CPP_LIBRARY

$(eval $(call HLM_ADD_CPP_COMPONENTS,$(3),$(1),$(2)))

$(1)_SOURCE_HEADERS := $(foreach COMPONENT,$(3),$$($(COMPONENT)_HH))
$(1)_SOURCE_SOURCES := $(foreach COMPONENT,$(3),$$($(COMPONENT)_CC))

$(1)_HEADERS := $(foreach COMPONENT,$(3),$$($(COMPONENT)_HEADER))
$(1)_OBJECTS := $(foreach COMPONENT,$(3),$$($(COMPONENT)_OBJECT))
$(1)_ARCHIVE := $(LIBRARY_DIR)/lib$(1).a

$(1)_DEPENDENCY_HEADERS  := $(foreach PACKAGE,$(2),$$($(PACKAGE)_HEADERS))
$(1)_DEPENDENCY_OBJECTS  := $(foreach PACKAGE,$(2),$$($(PACKAGE)_OBJECTS))
$(1)_DEPENDENCY_ARCHIVES := $(foreach PACKAGE,$(2),$$($(PACKAGE)_ARCHIVE))

.PHONY: $(1)
$(1): $(1)-headers \
      $(1)-objects \
      $(1)-archive \

.PHONY: $(1)-headers
$(1)-headers: $$($(1)_HEADERS)

.PHONY: $(1)-objects
$(1)-objects: $$($(1)_OBJECTS)

.PHONY: $(1)-archive
$(1)-archive: $$($(1)_ARCHIVE)

.PHONY: format-$(1)
format-$(1): format-$(1)-headers \
             format-$(1)-sources

.PHONY: format-$(1)-headers
format-$(1)-headers: $(foreach COMPONENT,$(3),format-$(COMPONENT)-header)

.PHONY: format-$(1)-sources
format-$(1)-sources: $(foreach COMPONENT,$(3),format-$(COMPONENT)-source)

$$($(1)_ARCHIVE): $$($(1)_DEPENDENCY_OBJECTS) \
                  $$($(1)_OBJECTS)
	@if [ ! -d "$(LIBRARY_DIR)" ] ; then mkdir -p $(LIBRARY_DIR) ; fi
	@echo "Creating static library: lib$(1).a"
	@$(ARCHIVER) cr $$($(1)_ARCHIVE)            \
	                $$($(1)_DEPENDENCY_OBJECTS) \
	                $$($(1)_OBJECTS)

endef

endif
