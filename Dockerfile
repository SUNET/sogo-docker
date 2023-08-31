FROM httpd:bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  sogo \
  sogo-activesync \
  vim
CMD [ "bash", "-c", "/etc/init.d/sogo start; httpd-foreground"]
EXPOSE 80/tcp 443/tcp
