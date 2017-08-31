# hlm_add_cpp_components.mk
ifndef INCLUDED_HLM_ADD_CPP_COMPONENTS
INCLUDED_HLM_ADD_CPP_COMPONENTS = 1

include make/hlm_add_cpp_component.mk

# HLM_ADD_CPP_COMPONENTS  - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

define HLM_ADD_CPP_COMPONENTS

$(eval $(foreach COMPONENT,$(1),$(call HLM_ADD_CPP_COMPONENT,$(COMPONENT),$(2),$(3))))

endef

endif
