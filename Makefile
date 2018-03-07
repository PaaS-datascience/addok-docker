EDITOR=vim

export ADDOK_NODES := 2
export PORT := 7878

dummy		    := $(shell touch artifacts)
include ./artifacts


install-prerequisites:
ifeq ("$(wildcard /usr/bin/docker)","")
	@echo install docker-ce, still to be tested
	sudo apt-get update
	sudo apt-get install \
    	apt-transport-https \
    	ca-certificates \
    	curl \
    	software-properties-common

	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
	sudo add-apt-repository \
   		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   		$(lsb_release -cs) \
   		stable"
   	sudo apt-get update
		sudo apt-get install -y docker-ce
endif

network: 
	@docker network create latelier 2> /dev/null; true

download:
	wget https://adresse.data.gouv.fr/data/geocode/ban_odbl_addok-latest.zip
	mkdir -p addok-data
	unzip -d addok-data ban_odbl_addok-latest.zip

name: latelier

config:
	@cat docker-compose-nginx.yml > docker-compose.yml
	@i=$(ADDOK_NODES); while [ $${i} -gt 1 ]; do \
		i=`expr $$i - 1`; \
		cat docker-compose-addok-node.yml | grep -v version | sed "s/%N/$$i/g;" >> docker-compose.yml; \
	done;\
	true
up: network
	docker-compose up -d

restart:
	docker-compose down

