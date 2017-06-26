#!/bin/sh

/bin/sh -c "envsubst '$ENVS'
< /etc/nginx/nginx.conf.template
> /etc/nginx/nginx.conf
&& nginx -g 'daemon off;'"
