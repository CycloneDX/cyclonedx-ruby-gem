FROM ruby:3.1-buster

ARG VERSION=1.1.0

RUN gem install cyclonedx-ruby -v ${VERSION} --no-document
ENTRYPOINT ["cyclonedx-ruby"]
