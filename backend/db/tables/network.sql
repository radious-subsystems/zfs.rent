CREATE TABLE IF NOT EXISTS network (
  addr   CIDR PRIMARY KEY,
  gw     INET,

  active BOOLEAN,
  loc    TEXT
);
