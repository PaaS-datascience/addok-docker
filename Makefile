EDITOR=vim

export ADDOK_NODES := 2
export PORT := 7878
export WORKERS := 8

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
        zip \
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

config:
	@cat docker-compose-nginx.yml > docker-compose.yml
	@echo "upstream addok { " > nginx.conf
	@i=$(ADDOK_NODES); while [ $${i} -gt 0 ]; do \
		i=`expr $$i - 1`; \
		cat docker-compose-addok-node.yml | egrep -v '(version|services)' | sed "s/%N/$$i/g;" >> docker-compose.yml; \
                echo "  server addok$${i}:${PORT};" >> nginx.conf;\
	done;\
	true
	@echo "}" >> nginx.conf
	@cat nginx.template >> nginx.conf

up: network config
	docker-compose up -d

down:
	docker-compose down

log:
	docker-compose logs -f
