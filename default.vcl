vcl 4.0;

backend default {
    .host = "127.0.0.1";
    .port = "1101";
}

sub vcl_recv {
    # handle dumb typo Ryan made in an email
    if (req.url == "/pricing.") {
        set req.url = "/pricing/";
    }
    set req.http.x-url = req.url;
}

sub vcl_backend_response {
    # default ttl if not set
    if (!beresp.http.Cache-Control) {
        set beresp.ttl = 1s;
    }
}

sub vcl_deliver {
    if (req.http.X-Forwarded-Proto !~ "^(?i)https") {
        set resp.status = 301;
        if (!req.http.host) {
            set req.http.host = "zfs.rent";
        }
        set resp.http.Location = "https://" + req.http.host + req.http.x-url;
    }
}

sub vcl_synth {
    # tell the clients that basic auth is required (IFF error 401)
    if (resp.status == 401) {
        set resp.status = 401;
        set resp.http.WWW-Authenticate = "Basic";
        return(deliver);
    }
}
