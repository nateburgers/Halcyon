# hlm_add_cpp_component.mk
ifndef INCLUDED_HLM_ADD_CPP_COMPONENT
INCLUDED_HLM_ADD_CPP_COMPONENT = 1

# HLM_ADD_CPP_COMPONENT - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#    $(1): The name of the component to compile into an object file

define HLM_ADD_CPP_COMPONENT

$(1)_HH := $(SOURCE_DIR)/$(2)/$(1).hh
$(1)_CC := $(SOURCE_DIR)/$(2)/$(1).cc

$(1)_HEADER := $(HEADER_DIR)/$(1).hh
$(1)_OBJECT := $(OBJECT_DIR)/$(1).o

$(1)_DEPENDENCY_HEADERS  := $(foreach PACKAGE,$(3),$$($(PACKAGE)_HEADERS))
$(1)_DEPENDENCY_OBJECTS  := $(foreach PACKAGE,$(3),$$($(PACKAGE)_OBJECTS))
$(1)_DEPENDENCY_ARCHIVES := $(foreach PACKAGE,$(3),$$($(PACKAGE)_ARCHIVES))

.PHONY: $(1)
$(1): $(1)-header \
      $(1)-object

.PHONY: $(1)-header
$(1)-header: $$($(1)_HEADER)

.PHONY: $(1)-object
$(1)-object: $$($(1)_OBJECT)

.PHONY: format-$(1)
format-$(1): format-$(1)-header \
             format-$(1)-source

.PHONY: format-$(1)-header
format-$(1)-header: $$($(1)_HH)
	@echo "      Formatting header: $(1).hh"
	@clang-format -i $$($(1)_HH)

.PHONY: format-$(1)-source
format-$(1)-source: $$($(1)_CC)
	@echo "      Formatting source: $(1).cc"
	@clang-format -i $$($(1)_CC)

$$($(1)_HEADER): $$($(1)_HH)
	@if [ ! -d "$(HEADER_DIR)" ] ; then mkdir -p $(HEADER_DIR) ; fi
	@echo "      Installing header: $(1).hh"
	@cp $$($(1)_HH) $$($(1)_HEADER)

$$($(1)_OBJECT): $$($(1)_HH)                 \
                 $$($(1)_CC)                 \
                 $$($(1)_DEPENDENCY_HEADERS)
	@if [ ! -d "$(OBJECT_DIR)" ] ; then mkdir -p $(OBJECT_DIR) ; fi
	@echo "              Compiling: $(1).cc"
	@$(CPP_COMPILER) $(CPP_COMPILER_FLAGS) \
	                 -I$(SOURCE_DIR)/$(2)  \
	                 -I$(HEADER_DIR)       \
	                 -c $$($(1)_CC)        \
	                 -o $$($(1)_OBJECT)

endef

endif
