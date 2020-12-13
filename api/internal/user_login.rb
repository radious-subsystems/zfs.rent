require "#{__dir__}/pg"
require "#{__dir__}/email"
require "#{__dir__}/syslog"

def set_password(email:, password:)
    begin
        Syslog::debug("setting password", {email:email})
        res = pg_exec(%{
            INSERT INTO user_login (email, passwd)
                VALUES ($1, public.crypt($2, public.gen_salt('bf')))
                ON CONFLICT (email) DO UPDATE
                    SET passwd = EXCLUDED.passwd
                RETURNING uid, email;
        }, [email, password])
        Syslog::debug("set_password pg results", {email:email, res:res})
    rescue Exception => err
        Syslog::error("set_password exception", {err:err, email:email})
    end
end

# account exists and password is valid --> uid
# account DNE *OR* password is invalid --> nil
def chk_password(email:, password:)
    begin
        Syslog::debug("checking password", {email:email})
        res = pg_exec(%{
            SELECT uid FROM user_login
            WHERE email  = $1 AND
                  passwd = public.crypt($2, passwd);
        }, [email, password])
        Syslog::debug("pg results", {email:email, res:res})
        uid = (res.length == 0) ? nil : res[0]["uid"];
        Syslog::verbose("password check results", {email:email, uid:uid})
        return uid
    rescue Exception => err
        Syslog::error("chk_password exception", {err:err, email:email})
    end
end

# success -> returns {success:true}
# error   -> returns {error:'message'}
def rst_password(email:)
    begin
        Syslog::debug("password reset request for", {email: email})

        # generate link in postgres
        res = pg_exec(%{
            INSERT INTO reset_passwd (user_login_uid, expires_at)
            SELECT
                uid,
                (CURRENT_TIMESTAMP + '48 hour')
            FROM user_login WHERE email = $1
            RETURNING *;
        }, [email])
        Syslog::debug("pg results", {email:email, res:res})

        if (res.length == 0) then
            Syslog::verbose("email not in system...", {email:email, res:res})
            return {error: 'email_not_in_system'}
        end

        # send email to user
        link = "https://zfs.rent/manage/reset?uuid=#{res[0]["id"]}"
        body = "This link expires in 48 hours.\n\n#{link}"
        send_email(to: email, subj: "zfs.rent // password reset", body: body)
        return {success: true}
    rescue Exception => err
        Syslog::error("rst_password exception", {err:err, email:email})
        return {error: 'internal_exception'}
    end
end

#set_password(email: "ryan@rmj.us", password: "hello123")
#chk_password(email: "ryan@rmj.us", password: "hello123")
#chk_password(email: "ryan@rmj.us", password: "hello456")
#rst_password(email: "dne@rmj.us")
#rst_password(email: "ryan@rmj.us")
