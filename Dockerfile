FROM ubuntu AS download
RUN apt-get update && \
    apt-get -y install curl gnupg && \
    apt-get clean
RUN curl https://downloads.apache.org/kafka/KEYS | gpg --import
RUN curl https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz -o kafka.tgz \
      -: https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz.asc -o kafka.tgz.asc
RUN gpg --verify kafka.tgz.asc kafka.tgz
RUN tar -x --strip-components 1 -C /usr/local -f kafka.tgz

FROM ubuntu
RUN apt-get update && \
    apt-get -y install --no-install-recommends default-jdk-headless && \
    apt-get clean
COPY --from=download /usr/local /usr/local
COPY config/server.properties config/zookeeper.properties /usr/local/config/
COPY bin/entrypoint.sh /usr/local/bin/

RUN adduser --system --group --home /nonexistent --no-create-home kafka && \
    mkdir -p /var/lib/kafka /var/log/kafka && \
    chown kafka:kafka /var/lib/kafka /var/log/kafka && \
    chmod 0700 /var/lib/kafka /var/log/kafka

USER kafka:kafka
VOLUME /var/lib/kafka /var/log/kafka
ENTRYPOINT /usr/local/bin/entrypoint.sh
EXPOSE 9092
