FROM alpine:3.14

RUN echo "Hello World" > index.html
RUN apk update
RUN apk add busybox-extras

CMD httpd -f -p 9090 -h .
