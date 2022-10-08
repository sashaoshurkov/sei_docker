FROM golang AS builder

RUN apt-get update; \
    apt-get install -y build-essential git; \
#    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/sei-protocol/sei-chain.git; \
    cd sei-chain; \
    git checkout 1.2.0beta; \
    make install; \
#    cd .. && rm -rf sei-chain

FROM ubuntu:20.04

COPY --from=builder /go/bin/seid /usr/bin

WORKDIR /root

EXPOSE 26656 26657 6060 26658 26660 9090 9091

CMD ["/bin/sh", "-c", "seid"]
