CREATE TABLE lcm_project (
  id         INTEGER NOT NULL,
  name       VARCHAR(255),
  identifier VARCHAR(255),
  founded    INTEGER,
  hq         VARCHAR(255),
  enabled    BOOLEAN DEFAULT TRUE,
  segment    VARCHAR(255),
  PRIMARY KEY (id)
)
