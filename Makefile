# -*- Makefile -*-

all: build

clean:
	rm -rf dist/ static/ yarn-error.log

clean-all: clean
	rm -rf node_modules/

build: node_modules
	yarn build
	hugo

release: clean
	git stash save before-gh-pages
	make build
	git checkout gh-pages
	cp -rf dist/* .
	rm -rf dist

node_modules:
	yarn install
