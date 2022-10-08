#FROM golang AS builder

FROM golang

WORKDIR /root

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    lz4 \
    unzip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/sei-protocol/sei-chain.git; \
    cd sei-chain && git checkout 1.2.0beta; \
    make install; \
    cd .. && rm -rf sei-chain

#FROM ubuntu:20.04

#COPY --from=builder /root/go/bin/sei /usr/local

EXPOSE 26656 26657 6060 26658 26660 9090 9091

#ENTRYPOINT ["/bin/sh", "-c", "sei"]
CMD ["/bin/sh", "-c", "sei"]
