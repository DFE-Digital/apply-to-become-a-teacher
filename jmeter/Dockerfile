FROM ruby:2.7.2-alpine3.12
ARG BUILD_DEPS="git gcc libc-dev make build-base libxml2-dev libxslt-dev"

WORKDIR /app

RUN apk -U upgrade && \
    apk add --update --no-cache $BUILD_DEPS tzdata libxml2 libxslt curl && \
    echo "Europe/London" > /etc/timezone && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime

RUN apk update && apk add openjdk11-jre-headless

ARG JMETER_PATH=/opt/apache-jmeter-5.4
COPY apache-jmeter-5.4.tgz ./
RUN cd /opt && \
    tar xzf /app/apache-jmeter-*.tgz && \
    ln -s ${JMETER_PATH}/bin/jmeter /usr/local/bin

COPY jmeter-prometheus-plugin-0.6.0.jar ./
RUN mv jmeter-prometheus-plugin-0.6.0.jar ${JMETER_PATH}/lib/ext

EXPOSE 9270

COPY Gemfile Gemfile.lock ./
RUN bundle install

RUN mkdir plans
COPY plans/ plans/

ENV JMETER_TARGET_BASEURL=
ENV JMETER_TARGET_PLAN=
COPY add_prometheus_xml.rb ./
COPY run.sh ./

CMD ash ./run.sh
