#
# Make file for building docker image. Install GnuMake for Windows 
# to build under Windows.
#  
# By Huxi LI, 2017, Paris
#
# Make: 
#      $ make [-e GROUP=GroupName]  
#
# ___________________

NAME = huxili/angular6-i18n-demo

# 1. Help 
# See https://stackoverflow.com/questions/649246/is-it-possible-to-create-a-multi-line-string-variable-in-a-makefile
# 
define HELP_BODY
-------------------------
Example angular 6 APP with multi-language support. 

Usage: make target
	
Target
========

- help: This help message  
- build: Build huxili/angualar6 image
- start: Start application (detached, port: 8080)
- starti: Start applcation (interactive, port: 8080)
- sh: Open the container shell
- log: Show logs of the container
- rm: Remove the container

endef
export HELP_BODY

.PHONY: help deploy build status rm

help: 
	@echo "$$HELP_BODY"

build: build-image-with-cache
build-nocache: build-image-no-cache
start: run-test-image
starti: run-test-image-interactive
rm: remove-test-container
sh: run-container-shell
log: container-logs

build-image-no-cache:
	docker build --no-cache=true -t $(NAME) .
build-image-with-cache:
	docker build -t $(NAME) .
run-test-image: 
	docker rm -f angular6-i18n-demo 2>/dev/null || true 
	docker run -it -d --rm -p 80:80 --name angular6-i18n-demo "$(NAME)"
run-test-image-interactive: 
	docker rm -f angular6-i18n-demo 2>/dev/null || true 
	docker run -it --rm -p 80:80 --name angular6-i18n-demo "$(NAME)"
remove-test-container:
	docker rm -f angular6-i18n-demo
run-container-shell:
	docker exec -it angular6-i18n-demo /bin/sh
container-logs:
	docker logs angular6-i18n-demo
