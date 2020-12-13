#!/usr/bin/env ruby

require "#{__dir__}/pg"
require "#{__dir__}/email"
require "#{__dir__}/syslog"
require "#{__dir__}/user_login"

uuid     = ARGV[0]
password = ARGV[1]

begin
    Syslog::debug("php_set_password_via_uuid", {uuid:uuid})

    # get uid/email info
    res = pg_exec(%{
        SELECT uid, email
        FROM reset_passwd
        LEFT JOIN user_login
            ON user_login_uid = user_login.uid
        WHERE
            (id = $1) AND
            (CURRENT_TIMESTAMP < expires_at)
    }, [uuid])
    Syslog::debug("php_set_pass pg results", {uuid:uuid, res:res})

    # bork if there is no reset_passwd entry
    if (res.length == 0) then
        raise "no matching reset_link OR link is expired"
    end

    # call password reset routine
    email = res[0]["email"]
    uid   = res[0]["uid"]

    set_password(email: email, password: password)
    puts "success: password reset for #{email}"

    # mark reset row as expired
    Syslog::verbose("marking reset link as expired", {uuid:uuid})
    res = pg_exec(%{
        UPDATE reset_passwd
            SET expires_at = CURRENT_TIMESTAMP
        WHERE (id = $1)
        RETURNING *;
    }, [uuid])
    Syslog::debug("set reset link to expired; pg results", {uuid:uuid, res:res})
rescue Exception => err
    Syslog::error("php_set_pass exception", {uuid:uuid, err:err})
    puts "error: unable to set password for #{email}: #{err}"
end
