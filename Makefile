.PHONY: build start

build:
	@time docker build -t wsgo .

start:
	@mkdir -p ~/go/src
	@mkdir -p ~/go/bin
	@mkdir -p ~/go/pkg
	@docker run \
		-ti \
		-v ~/go:/home/unkiwii/go \
		-v ~/dotfiles:/home/unkiwii/dotfiles \
		-v ~/Downloads:/home/unkiwii/downloads \
		-h docker \
		wsgo
