FROM ruby:2.2.2

RUN gem install mailcatcher --no-rdoc --no-ri

# smtp (25) and ip (1080) ports
EXPOSE 25 1080

CMD ["mailcatcher", "--smtp-ip=0.0.0.0", "--smtp-port=25", "--http-ip=0.0.0.0", "--http-port=1080", "-f"]
