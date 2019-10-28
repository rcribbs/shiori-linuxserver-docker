FROM golang:1.13-alpine as builder

RUN apk update && apk --no-cache add git build-base

WORKDIR /go/src

ENV SOURCE_REPO=rcribbs/shiori

ADD https://raw.githubusercontent.com/${SOURCE_REPO}/master/go.mod .
ADD https://raw.githubusercontent.com/${SOURCE_REPO}/master/go.sum .

RUN go mod download

RUN wget -qO- https://github.com/$SOURCE_REPO/archive/master.zip | \
    unzip -d /tmp/ -
RUN cp -R /tmp/shiori*/* .

RUN go build -o /go/bin/ .

# ========== END OF BUILDER ========== #

FROM lsiobase/alpine:latest

COPY --from=builder /go/bin/shiori /usr/local/bin/shiori

COPY root/ /

EXPOSE 8080

VOLUME /config
