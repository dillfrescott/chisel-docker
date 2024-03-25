FROM ubuntu as ubuntu1

RUN apt update && apt upgrade -y

RUN apt install -y git golang

WORKDIR /root

RUN git clone https://github.com/jpillora/chisel

WORKDIR /root/chisel

RUN go build

RUN chmod +x chisel

FROM gcr.io/distroless/static-debian12

COPY --from=ubuntu1 /root/chisel/chisel /

ARG CHISEL_PASSWORD

ENV CHISEL_PASSWORD=${CHISEL_PASSWORD}

ENTRYPOINT ["/chisel server --port 1234 --proxy http://0.0.0.0 --reverse --auth chisel:${CHISEL_PASSWORD}"]