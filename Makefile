.DEFAULT_GOAL := show-help
THIS_FILE := $(lastword $(MAKEFILE_LIST))
ROOT_DIR:=$(shell dirname $(realpath $(THIS_FILE)))

.PHONY: show-help
# See <https://gist.github.com/klmr/575726c7e05d8780505a> for explanation.
## This help screen
show-help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)";echo;sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## //;td" -e"s/:.*//;G;s/\\n## /---/;s/\\n/ /g;p;}" ${MAKEFILE_LIST}|LC_ALL='C' sort -f|awk -F --- -v n=$$(tput cols) -v i=29 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"%s%*s%s ",a,-i,$$1,z;m=split($$2,w," ");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;printf"\n%*s ",-i," ";}printf"%s ",w[j];}printf"\n";}'

.PHONY: test
## Test it
test:
	RUST_BACKTRACE=1 cargo +nightly test

.PHONY: build
## Build a binary
build:
	cargo +nightly build

.PHONY: run
## Run the server
run:
	cargo +nightly run

.PHONY: lint
## Lint it
lint:
	cargo +nightly fmt --all -- --check
	cargo +nightly clippy --all-targets --all-features -- -D warnings -Dclippy::all -Dclippy::pedantic
	cargo +nightly check
	terraform fmt -check -recursive terraform
	shfmt -w -s -d ci/

.PHONY: fmt
## Format what can be formatted
fmt:
	cargo +nightly fmt --all
	cargo +nightly fix --allow-dirty
	terraform fmt -recursive terraform
	terragrunt hclfmt
	shfmt -w -s ci/

.PHONY: clean
## Clean the build directory
clean:
	cargo +nightly clean

.PHONY: infrastructure-setup
## Setup the infrastructure for the project
infrastructure-setup:
	terragrunt apply

.PHONY: infrastructure-destroy
## Setup the infrastructure for the project
infrastructure-destroy:
	terragrunt destroy


.PHONY: deploy
## Deploy and release the application
deploy:
	waypoint init
	waypoint up --app=web

.PHONY: deploy-test
## Deploy and release the test application
deploy-test:
	waypoint init
	waypoint up --app=test-web