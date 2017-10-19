.PHONY: all build clean deploy setup test

.SUFFIXES:

all: setup build deploy

clean:
	rm -rf examples
	rm -rf tools

setup:
	bash setup.sh

build:
	bash build.sh

test_fceux:
	bash test_fceux.sh

deploy:
	bash deploy.sh
