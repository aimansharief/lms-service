FROM --platform=linux/x86_64 eclipse-temurin:11.0.20.1_1-jdk-focal
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y unzip curl \
    && adduser --uid 1001 --home /home/sunbird/ --disabled-login sunbird \
    && mkdir -p /home/sunbird \
    && chown -R sunbird:sunbird /home/sunbird \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
#ENV sunbird_learnerstate_actor_host 52.172.24.203
#ENV sunbird_learnerstate_actor_port 8088 
RUN chown -R sunbird:sunbird /home/sunbird
USER sunbird
COPY ./service/target/lms-service-1.0-SNAPSHOT-dist.zip /home/sunbird/lms/
RUN unzip /home/sunbird/lms/lms-service-1.0-SNAPSHOT-dist.zip -d /home/sunbird/lms/
COPY ./service/conf/logback.xml /home/sunbird/lms/lms-service-1.0-SNAPSHOT/conf/logback.xml
WORKDIR /home/sunbird/lms/
CMD java -XX:+PrintFlagsFinal $JAVA_OPTIONS \
  -Dplay.server.http.idleTimeout=180s \
  -Dlogback.configurationFile=/home/sunbird/lms/lms-service-1.0-SNAPSHOT/conf/logback.xml \
  -cp '/home/sunbird/lms/lms-service-1.0-SNAPSHOT/lib/*' \
  play.core.server.ProdServerStart /home/sunbird/lms/lms-service-1.0-SNAPSHOT
