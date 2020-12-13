#!/usr/bin/ruby

require "#{__dir__}/pg"
require "#{__dir__}/syslog"

require "sendgrid-ruby"
include SendGrid

SENDGRID_FROM_ADDR="zfs@radious.co"
SENDGRID_API_KEY="REDACTED"

def send_email(
    to:"no-recipient@radious.co",
    subj:"no subject",
    body:"no body"
)
    context = {:to => to, :subj => subj, :body => body}
    Syslog::debug("send_email() called", context)

    # contruct email
    from    = Email.new(email: SENDGRID_FROM_ADDR)
    to      = Email.new(email: to)
    content = Content.new(type: "text/plain", value: body)
    mail    = Mail.new(from, subj, to, content)
    Syslog::debug("email constructed")

    # post email to sendgrid
    sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
    Syslog::debug("pre-send")
    response = sg.client.mail._("send").post(request_body: mail.to_json)
    context = {
        body:        response.body,
        headers:     response.headers,
        status_code: response.status_code
    }
    Syslog::debug("post-send", context)
end
