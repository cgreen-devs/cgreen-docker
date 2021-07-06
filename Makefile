# Makefile to build a docker image with Cgreen installed and a deb package created and extracted

all:
	docker build . -t cgreen:1.4.0
	docker create --name cgreen_1.4.0 cgreen:1.4.0
	docker cp cgreen_1.4.0:/home/cgreen-devs/cgreen_1.4.0_amd64.deb .
	docker rm cgreen_1.4.0
