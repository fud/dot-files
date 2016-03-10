SHELL = /bin/bash
EMACS = emacs
ARGS = -Q -nw --batch

all: test

test:   clean
	@echo "Building test version of emacs.d in $(PWD)/.emacs.d/"
	@env HOME=$(PWD) $(EMACS) $(ARGS) -l build.el

clean:
	@rm -rf $(PWD)/.emacs.d/

emacsd:
	@echo "Building ~/.emacs.d"
	@$(EMACS) $(ARGS) -l build.el

realclean:
	@rm -rf $(HOME)/.emacs.d/
