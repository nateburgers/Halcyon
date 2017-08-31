# hlm_add_cpp_library.mk
ifndef INCLUDED_HLM_ADD_CPP_LIBRARY
INCLUDED_HLM_ADD_CPP_LIBRARY = 1

include make/hlm_add_cpp_component.mk
include make/hlm_add_cpp_components.mk

# HLM_ADD_CPP_LIBRARY - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
define HLM_ADD_CPP_LIBRARY

$(eval $(call HLM_ADD_CPP_COMPONENTS,$(3),$(1),$(2)))

$(LIBRARY_DIR)/lib$(1).a:                                                     \
	             $(foreach DEPENDENCY,$(2),$(LIBRARY_DIR)/lib$(DEPENDENCY).a) \
	             $(foreach DEPENDENCY,$(3),$(OBJECT_DIR)/$(DEPENDENCY).o)
	@mkdir -p $(LIBRARY_DIR)
	@echo "Creating static library: lib$(1).a"
	@$(ARCHIVER) cr $(LIBRARY_DIR)/lib$(1).a                                  \
	             $(foreach DEPENDENCY,$(2),$(LIBRARY_DIR)/lib$(DEPENDENCY).a) \
	             $(foreach DEPENDENCY,$(3),$(OBJECT_DIR)/$(DEPENDENCY).o)

.PHONY: $(1)
$(1): $(LIBRARY_DIR)/lib$(1).a $(3)

endef

endif
