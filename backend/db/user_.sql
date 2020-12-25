CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE user_ (
  uid        BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START 1000),
  email      CITEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  api_key    UUID DEFAULT gen_random_uuid()
);
