FROM quay.io/redsift/baseos
MAINTAINER Rahul Powar email: rahul@redsift.io version: 1.1.101

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y unzip openssl ca-certificates curl rsync gettext-base software-properties-common python-software-properties \
    	iputils-ping dnsutils build-essential libtool autoconf git mercurial vim emacs tcpdump zsh dialog man \
    	manpages libpython-stdlib libpython2.7-minimal libpython2.7-stdlib mime-support python python-minimal python2.7 python2.7-minimal python-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/zsh /bin/sh

RUN pip install awscli

# Versions
ENV GO_VERSION=1.9.2 GLIDE=v0.13.0 JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

# Go ENV vars
ENV GOPATH=/opt/gopath PATH="${GOPATH}/bin:/usr/local/go/bin:$PATH"

RUN set -eux; \
    url="https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"; \
    wget -O go.tgz "$url"; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz;

RUN go env GOROOT && go version

RUN mkdir /opt/gopath

# Install godoc
RUN go get golang.org/x/tools/cmd/godoc

# Install glide for Go dependency management
RUN cd /tmp && \
	curl -L https://github.com/Masterminds/glide/releases/download/$GLIDE/glide-$GLIDE-linux-amd64.tar.gz -o glide.tar.gz && \
	tar -xf glide.tar.gz && \
	cp /tmp/linux-amd64/glide /usr/local/bin

# Install dep
RUN go get -u github.com/golang/dep/cmd/dep

# Install go-bindata to package files inside binary
RUN go get -u github.com/jteeuwen/go-bindata && \
	cd $GOPATH/src && \
	go build github.com/jteeuwen/go-bindata/go-bindata && \
	mv go-bindata $GOROOT/bin && \
	go-bindata -version

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
	apt-get install -y nodejs && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install JDK without things like fuse
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk maven && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install X11 dev
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y libx11-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

LABEL io.redsift.os=build

COPY root /

VOLUME [ "/artifacts" ]

CMD [ "/bin/zsh" ]