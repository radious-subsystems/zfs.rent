CREATE TABLE reset_passwd (
  id UUID PRIMARY KEY DEFAULT public.gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP),
  expires_at TIMESTAMPTZ DEFAULT (CURRENT_TIMESTAMP + '30 minutes'),
  user_login_uid BIGINT NOT NULL REFERENCES user_login(uid)
);
