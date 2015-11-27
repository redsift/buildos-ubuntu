FROM quay.io/redsift/baseos
MAINTAINER Rahul Powar email: rahul@redsift.io version: 1.1.101

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y unzip openssl ca-certificates curl rsync gettext-base software-properties-common python-software-properties \
    	iputils-ping dnsutils build-essential libtool autoconf git mercurial vim emacs tcpdump zsh dialog man \
    	pkg-config manpages libpython-stdlib libpython2.7-minimal libpython2.7-stdlib mime-support python python-minimal python2.7 python2.7-minimal python-pip \
    	golang && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/zsh /bin/sh

RUN pip install awscli

# Versions
ENV AEROSPIKE_TOOLS=3.5.11 GLIDE=0.7.2 JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

# Aerospike tools NOTE: They made a packaging error here hence the hardcoded cd
RUN cd /tmp && \
	curl -L -s http://www.aerospike.com/download/tools/${AEROSPIKE_TOOLS}/artifact/ubuntu12 | tar xz && \
	cd aerospike-tools-3.5.12-ubuntu12.04 && \
	DEBIAN_FRONTEND=noninteractive dpkg -i aerospike-tools-*.deb && \
	cd /tmp && rm -Rf *

# Go ENV vars
RUN go env GOROOT
ENV GOPATH=/opt/gopath GO15VENDOREXPERIMENT=1

# Install godoc
RUN go get golang.org/x/tools/cmd/godoc 

# Install glide for Go dependency management
RUN cd /tmp && \
	curl -L https://github.com/Masterminds/glide/releases/download/$GLIDE/glide-$GLIDE-linux-amd64.tar.gz -o glide.tar.gz && \
	tar -xf glide.tar.gz && \
	cp /tmp/linux-amd64/glide /usr/local/bin

# Install go-bindata to package files inside binary
RUN go get -u github.com/jteeuwen/go-bindata && \
	cd $GOPATH/src && \
	go build github.com/jteeuwen/go-bindata/go-bindata && \
	mv go-bindata /opt/go/bin && \
	go-bindata -version

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
	apt-get install -y nodejs && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install JDK without things like fuse
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk maven && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# pkg-config is needed for go-nanomsg to find nanomsg
ENV PKG_CONFIG_PATH=/lib/pkgconfig

LABEL io.redsift.os=build

COPY root /

VOLUME [ "/artifacts" ]

CMD [ "/bin/zsh" ]