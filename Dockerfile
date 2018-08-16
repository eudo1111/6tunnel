FROM alpine:latest

RUN apk add --no-cache bash 6tunnel

WORKDIR /
COPY ./entrypoint.sh .

CMD ["bash", "entrypoint.sh"]
