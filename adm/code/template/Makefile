SHELL = /bin/bash
#-------------------------------------------------------------------------------
MERGE = ada-merge
#-------------------------------------------------------------------------------
TARGETS = $(sort $(patsubst %.adt,%,$(wildcard *.adt)))
#-------------------------------------------------------------------------------
all:
	@for file in $(TARGETS); do make .$${file}; done;
#-------------------------------------------------------------------------------
.%: %.adt cadabra/*.ad include/*.ad
	@ echo "merge-ada $* ..."
	@ $(MERGE) -i $*.adt -o $*.adb
	@ mv -f $*.adb ../src/.
	@ touch $@
#-------------------------------------------------------------------------------
rm-dot:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf .$${file}; \
	  done
	@ rm -rf .[a-z]*.lb
	@ rm -rf .merged.tex .tmp.txt
#-------------------------------------------------------------------------------
pristine:
	@ rm -rf make.log
	@ for file in $(TARGETS); do rm -f .$${file}; done
	@ for file in $(TARGETS); do rm -f  $${file}.adb; done
