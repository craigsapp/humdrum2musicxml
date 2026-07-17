##
## Programmer:    Craig Stuart Sapp <craig@ccrma.stanford.edu>
## Creation Date: Wed 07 Jul 2021 12:44:31 PM PDT
## Last Modified: Wed 07 Jul 2021 12:44:34 PM PDT
## Filename:      ...humdrum2musicxml/cgi-bin/Makefile
##
## Description: This Makefile automates cgi-bin script installing
##

.PHONEY: help all

CGIBIN = /var/www/cgi-bin

###########################################################################
#                                                                         #
#                                                                         #

help:
	@echo all: install all programs into the cgi-bin directory

all:
	cp humdrum2musicxml.pl  $(CGIBIN)/humdrum2musicxml
	chmod 0755   $(CGIBIN)/humdrum2musicxml
	
	# 3. Add the permanent SELinux context rule for this file destination
	sudo semanage fcontext -a -t httpd_sys_script_exec_t "$(CGIBIN)/humdrum2musicxml"
	
	# 4. Force the filesystem to instantly apply the newly defined context
	sudo restorecon -v $(CGIBIN)/humdrum2musicxml
#                                                                         #
#                                                                         #
###########################################################################




