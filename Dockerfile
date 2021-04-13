From debian
MAINTAINER Massimo Musumeci <massmux@denali.uk>

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive


RUN    apt-get update
RUN    apt-get install -y \
        autoconf \
        build-essential \
        bc \
        curl \
        git \
        wget \
        jq \
        libssl-dev \
        libtool \
        net-tools \
        openssl \
        python-pip \
        pkg-config \
        procps \
        sed \
        vim \
        xxd

RUN pip install base58

# install core
RUN 	cd /root && wget https://bitcoincore.org/bin/bitcoin-core-0.21.0/bitcoin-0.21.0-x86_64-linux-gnu.tar.gz && \
	tar xzvf bitcoin-0.21.0-x86_64-linux-gnu.tar.gz && \
	mv /root/bitcoin-0.21.0/bin/* /usr/bin/ && \
	chmod +x /usr/bin/bitcoin-cli && \
	chmod +x /usr/bin/bitcoind

	
# install btcdeb
RUN    	cd /opt && \
    	wget https://github.com/bitcoin-core/btcdeb/archive/0.3.20.tar.gz && \
	tar -xzf 0.3.20.tar.gz && \
    	cd btcdeb-0.3.20 && \
	chmod +x ./autogen.sh && \
    	./autogen.sh && \
	chmod +x  ./configure && \
    	./configure && \
    	make && \
    	make install

ADD ./utility /opt/wald/utility
ADD ./run.sh /root/run.sh

# libbitcoin explorer
# https://github.com/libbitcoin/libbitcoin-explorer/wiki
RUN cd /opt/wald/utility && \
    wget https://github.com/libbitcoin/libbitcoin-explorer/releases/download/v3.2.0/bx-linux-x64-qrcode && \
    mv bx-linux-x64-qrcode bx && \
    chmod +x bx

RUN chmod +x /root/run.sh

# bizantino utility
RUN 	rm -Rf /usr/local/sbin && \
	ln -s /opt/wald/utility /usr/local/sbin


EXPOSE 18443 18444
