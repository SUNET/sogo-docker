FROM httpd:bookworm

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  curl \
  gpg \
  vim
ARG REPO_URL=http://packages.sogo.nu/nightly/5/debian/
ARG GPG_FILE=/usr/share/keyrings/sogo-release-keyring.gpg
ARG GPG_URL=https://keys.openpgp.org/vks/v1/by-fingerprint/74FFC6D72B925A34B5D356BDF8A27B36A6E2EAE9
RUN curl -s ${GPG_URL} | gpg --dearmor > ${GPG_FILE}
RUN echo "Types: deb\nURIs: ${REPO_URL}\nSuites: bookworm\nSigned-By: ${GPG_FILE}\n" \
   > /etc/apt/sources.list.d/sogo.sources
RUN apt-get update && apt-get install -y \
  sogo \
  sogo-activesync
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
CMD [ "bash", "-c", "/etc/init.d/sogo start; httpd-foreground;"]
EXPOSE 80/tcp 443/tcp
