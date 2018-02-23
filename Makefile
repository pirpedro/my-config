prefix:=/usr/local

datarootdir:=$(prefix)/my-config

EXEC_FILES:=bin/my
EXT_FILES:=ext/functions.sh
EXT_FILES+=ext/template
EXT_FILES+=ext/bash-common/bin/sh-common
EXT_FILES+=ext/bash-common/bin/sh-extglob

OS:=$(shell uname)

ifeq ($(OS),Darwin)
recipes_folder:=packages-available-mac
else
recipes_folder:=packages-available-ubuntu
endif
recipes:=$(wildcard $(recipes_folder)/*.recipe)

all:
	@echo "usage: make install"
	@echo "       make uninstall"

install:
	install -d -m 0755 $(prefix)/bin
	install -m 0755 $(EXEC_FILES) $(prefix)/bin
	install -d -m 0744 $(datarootdir)
	install -d -m 0744 ext $(datarootdir)/ext
	install -m 0744 $(EXT_FILES) $(datarootdir)/ext
	cp -R ext/plugins $(datarootdir)/ext/plugins
	install -d -m 0744 $(datarootdir)/packages-available
	install -m 0744 $(recipes) $(datarootdir)/packages-available
	cp -R $(recipes_folder)/resource $(datarootdir)/packages-available/resource
	install -d -m 0744 $(datarootdir)/packages-enabled
	install -m 0744 .version $(datarootdir)/.version
ifeq ($(SUDO_USER),)
	@echo "Installation complete."
else
	chown -R $(SUDO_USER) $(datarootdir)
	@echo "Installation complete."
endif

uninstall:
	test -d $(prefix)/bin && \
	cd $(prefix)/bin && \
	rm -f $(EXEC_FILES)
	test -d $(datarootdir) && \
	rm -rf $(datarootdir)
