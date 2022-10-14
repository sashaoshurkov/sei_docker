FROM golang:1.18 AS builder

RUN apt-get update; \
    apt-get install -y build-essential git

RUN git clone https://github.com/sei-protocol/sei-chain.git; \
    cd sei-chain; \
    git checkout 1.2.2beta; \
    make install; \
    make clean

FROM ubuntu:20.04

WORKDIR /root

COPY --from=builder /usr/local/go/bin/go /usr/local/go/bin/go
COPY --from=builder /go /go

RUN echo "export PATH=/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /root/.bashrc; \
    echo "export GOPATH=/go" >> /root/.bashrc

EXPOSE 26656 26657 6060 26658 26660 9090 9091

CMD ["/usr/bin/seid", "start", "--pruning=nothing", "--rpc.laddr=tcp://0.0.0.0:26657"]