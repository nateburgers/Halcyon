# Makefile                                                       -*-GNU Make-*-

# =============================================================================
#                            CONFIGURATION OPTIONS
# =============================================================================
.DEFAULT_GOAL := all

CPP_COMPILER       = g++
CPP_COMPILER_FLAGS = -std=c++17 -pedantic -Wall -Werror -Wextra \
                     -Isrc

LINKER       = gcc
LINKER_FLAGS =

ARCHIVER = ar

SOURCE_DIR = src

BUILD_DIR   = build
BINARY_DIR  = $(BUILD_DIR)/bin
HEADER_DIR  = $(BUILD_DIR)/include
LIBRARY_DIR = $(BUILD_DIR)/lib
OBJECT_DIR  = $(BUILD_DIR)/obj
STAMP_DIR   = $(BUILD_DIR)/stamp

# =============================================================================
#                                    MACROS
# =============================================================================

# ADD_CPP_COMPONENT - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#    $(1): The name of the component to compile into an object file

define ADD_CPP_COMPONENT

$(HEADER_DIR)/$(1).hh: $(SOURCE_DIR)/$(1).hh
	@mkdir -p $(HEADER_DIR)
	@echo "      Installing header: $(1).hh"
	@cp $(SOURCE_DIR)/$(1).hh $(HEADER_DIR)/$(1).hh

$(OBJECT_DIR)/$(1).o: $(SOURCE_DIR)/$(1).hh \
	                  $(SOURCE_DIR)/$(1).cc
	@mkdir -p $(OBJECT_DIR)
	@echo "              Compiling: $(1).cc"
	@$(CPP_COMPILER) $(CPP_COMPILER_FLAGS)    \
	                 -c $(SOURCE_DIR)/$(1).cc \
	                 -o $(OBJECT_DIR)/$(1).o

.PHONY: $(1)
$(1): $(HEADER_DIR)/$(1).hh \
      $(OBJECT_DIR)/$(1).o

endef

# ADD_CPP_COMPONENTS  - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
define ADD_CPP_COMPONENTS

$(eval $(foreach COMPONENT,$(1),$(call ADD_CPP_COMPONENT,$(COMPONENT))))

endef

# ADD_LIBRARY - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
define ADD_LIBRARY

$(eval $(call ADD_CPP_COMPONENTS,$(2)))

$(LIBRARY_DIR)/lib$(1).a: $(foreach DEPENDENCY,$(2),$(OBJECT_DIR)/$(DEPENDENCY).o)
	@mkdir -p $(LIBRARY_DIR)
	@echo "Creating static library: lib$(1).a"
	@$(ARCHIVER) cr $(LIBRARY_DIR)/lib$(1).a \
	                $(foreach DEPENDENCY,$(2),$(OBJECT_DIR)/$(DEPENDENCY).o)

.PHONY: $(1)
$(1): $(LIBRARY_DIR)/lib$(1).a $(2)

endef

# =============================================================================
#                                    RULES
# =============================================================================

# 'hls' package
$(eval $(call ADD_LIBRARY,hls,hls_integer))

# 'hlcc' package
$(eval $(call ADD_LIBRARY,hlcc,hlcc_instruction \
                               hlcc_opcode))

# Programs  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.PHONY : all
all : hlcc hls

# System Macros - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
.PHONY : clean
clean :
	@echo "Deleting build directory"
	@rm -r  $(BUILD_DIR)

