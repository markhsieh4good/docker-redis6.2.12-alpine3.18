FROM redis:6.2.12-alpine3.18

RUN apk update 
RUN apk add --no-cache procps net-tools bash
RUN apk add --no-cache tzdata git
RUN rm -rf /var/cache/apk/*

## setting network
COPY utility_loopback.sh .
RUN chmod +x ./utility_loopback.sh
RUN ./utility_loopback.sh

COPY utility_namespace_dns.sh .
RUN chmod +x ./utility_namespace_dns.sh
RUN ./utility_namespace_dns.sh

RUN mkdir -p /etc/redis/conf.d && chown redis:redis /etc/redis && chown redis:redis /etc/redis/conf.d
ENV PATH="${PATH}:/usr/local/bin"
RUN ln -s /var/run /run

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
