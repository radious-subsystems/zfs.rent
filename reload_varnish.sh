#!/bin/bash -x

cp -fv default.vcl /etc/varnish/default.vcl
chown varnish      /etc/varnish/default.vcl
varnishreload
