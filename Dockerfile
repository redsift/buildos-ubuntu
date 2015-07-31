FROM quay.io/redsift/baseos
MAINTAINER Rahul Powar email: rahul@redsift.io version: 1.1.101

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y openssl ca-certificates curl rsync gettext-base \
    	iputils-ping dnsutils build-essential libtool autoconf git mercurial vim emacs tcpdump zsh dialog man \
    	manpages libpython-stdlib libpython2.7-minimal libpython2.7-stdlib mime-support python python-minimal python2.7 python2.7-minimal python-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/zsh /bin/sh

RUN pip install awscli

# Versions
ENV AEROSPIKE_TOOLS=3.5.11 GO=1.4.2 GPM=1.3.2 GVP=0.2.0

# Aerospike tools NOTE: They made a packaging error here hence the hardcoded cd
RUN cd /tmp && \
	curl -L -s http://www.aerospike.com/download/tools/${AEROSPIKE_TOOLS}/artifact/ubuntu12 | tar xz && \
	cd aerospike-tools-3.5.12-ubuntu12.04 && \
	DEBIAN_FRONTEND=noninteractive dpkg -i aerospike-tools-*.deb && \
	cd /tmp && rm -Rf *

# Number of OS threads to use
ENV GOMAXPROCS=3  GOPATH=/opt/gopath PATH=/opt/go/bin:$PATH

# Install Go from source
# use make.bash as tests may not work in a docker build
RUN cd /opt && \
	git clone --branch go${GO} --depth 1 https://go.googlesource.com/go && \
	cd go/src && \
	./make.bash && \
	cd .. && rm -Rf .git && \
	mkdir /opt/gopath && \
	go get golang.org/x/tools/cmd/godoc

# GPM+GVP for dependency management
RUN cd /usr/local/bin && \
	curl -s -O https://raw.githubusercontent.com/pote/gpm/v${GPM}/bin/gpm && \
	chmod +x gpm && \
	curl -s -O https://raw.githubusercontent.com/pote/gvp/v${GVP}/bin/gvp && \
	chmod +x gvp

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash - && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
	apt-get install -y nodejs && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Version dump
RUN \
	echo "Go" `go version` && \
	echo "NodeJS" `node -v` && echo "NPM" `npm -v` 

COPY root /

VOLUME [ "/artifacts" ]

CMD [ "/bin/zsh" ]