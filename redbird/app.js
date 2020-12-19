#!/usr/bin/env node

const redbird = require("redbird");

const proxy = redbird({
    port: 80,
    letsencrypt: {
        path: __dirname + "/certs",
        port: 9999
    },
    ssl: {
        redirect: true,
        http2: false,
        port: 443
    }
});

const ssl = {
  ssl: {
      redirect: true,
      letsencrypt: {email: "ryan@radious.co", production: true}
  }
}

// port 6081 is the default varnish port on CentOS 8.2 systemd
proxy.register("vnc.zfs.rent",     "http://localhost:6080",      ssl);
proxy.register("zfs.rent",         "http://localhost:6081",      ssl);
proxy.register("radious.dev",      "http://localhost:6081",      ssl);
proxy.register("blog.notryan.com", "http://mir.radious.co:2020", ssl);
proxy.register("notryan.com",      "http://localhost:1102",      ssl);
