# define_dir.mk                                                  -*-GNU Make-*-

ifndef INCLUDED_DEFINE_DIR
INCLUDED_DEFINE_DIR = 1

.RECIPEPREFIX = ~

# DEFINE_DIR  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
DEFINE_DIR = $(eval $(call _DEFINE_DIR,$(1),$(2)))

define _DEFINE_DIR

$(1)       := $(2)
$(1)_STAMP := $(2)/.stamp

$$($(1)_STAMP) :
~ @echo "Creating directory $(2)"
~ @mkdir -p $(2)
~ @touch $(2)/.stamp

endef

endif
