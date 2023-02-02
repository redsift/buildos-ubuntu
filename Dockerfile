FROM quay.io/redsift/baseos

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y unzip openssl ca-certificates curl rsync gettext-base software-properties-common wget \
    	iputils-ping dnsutils build-essential libtool autoconf git mercurial vim emacs tcpdump zsh dialog man \
    	manpages libpython-stdlib libpython2.7-minimal libpython2.7-stdlib mime-support python python-minimal python2.7 python2.7-minimal python-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/zsh /bin/sh

RUN pip install awscli

# Versions
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

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
