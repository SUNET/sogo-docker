FROM httpd:bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  sogo \
  sogo-activesync \
  vim
RUN sed -i \
		-e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
		-e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_proxy_http.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_proxy_http2.so\)/\1/' \
		conf/httpd.conf
COPY ./httpd-sogo.conf conf/extra/httpd-sogo.conf
RUN echo 'Include conf/extra/httpd-sogo.conf' >> conf/httpd.conf
CMD [ "bash", "-c", "/etc/init.d/sogo start; httpd-foreground"]
EXPOSE 80/tcp 443/tcp
