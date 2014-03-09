default: help

help:
	@echo make install - Install the scripts to $(HOME)/bin
	@echo make clean - Remove the scripts

clean:
	rm -f "$(HOME)/bin/git-state"
	rm -f "$(HOME)/bin/git-ps1.sh"

install:
	@PWD=`pwd`
	ln -s "$(PWD)/bin/git-state" "$(HOME)/bin/git-state"
	ln -s "$(PWD)/git-ps1.sh" "$(HOME)/bin/git-ps1.sh"

.PHONY: clean install

