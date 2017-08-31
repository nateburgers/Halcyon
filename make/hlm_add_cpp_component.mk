# hlm_add_cpp_component.mk
ifndef INCLUDED_HLM_ADD_CPP_COMPONENT
INCLUDED_HLM_ADD_CPP_COMPONENT = 1

# HLM_ADD_CPP_COMPONENT - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#    $(1): The name of the component to compile into an object file

define HLM_ADD_CPP_COMPONENT

$(HEADER_DIR)/$(1).hh: $(SOURCE_DIR)/$(2)/$(1).hh
	@mkdir -p $(HEADER_DIR)
	@echo "      Installing header: $(1).hh"
	@cp $(SOURCE_DIR)/$(2)/$(1).hh $(HEADER_DIR)/$(1).hh

$(OBJECT_DIR)/$(1).o: $(SOURCE_DIR)/$(2)/$(1).hh \
	                  $(SOURCE_DIR)/$(2)/$(1).cc
	@mkdir -p $(OBJECT_DIR)
	@echo "              Compiling: $(1).cc"
	@$(CPP_COMPILER) $(CPP_COMPILER_FLAGS)            \
	                 $(foreach LIB,$(3),-Isrc/$(LIB)) \
	                 -Isrc/$(2)                       \
	                 -c $(SOURCE_DIR)/$(2)/$(1).cc    \
	                 -o $(OBJECT_DIR)/$(1).o

.PHONY: $(1)
$(1): $(HEADER_DIR)/$(1).hh \
      $(OBJECT_DIR)/$(1).o

endef

endif
