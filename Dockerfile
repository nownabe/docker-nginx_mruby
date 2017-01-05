FROM alpine:3.5
MAINTAINER nownabe

ENV NGINX_CONFIG_OPT_ENV \
  --http-log-path=/var/log/nginx/access.log \
  --error-log-path=/var/log/nginx/error.log \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_stub_status_module

RUN apk add --no-cache --update openssl-dev pcre-dev \
  && apk add --no-cache --virtual build-deps build-base ruby-dev ruby-rake tar wget bison perl git \
  && git clone https://github.com/matsumotory/ngx_mruby.git \
  && cd ngx_mruby \
  && sh build.sh \
  && make install \
  && cd \
  && apk del build-deps \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && mkdir -p /etc/nginx/conf.d \
  && rm -rf ngx_mruby /var/cache/apk/*

ADD nginx.conf /etc/nginx/nginx.conf

CMD /usr/local/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
