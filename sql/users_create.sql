CREATE TABLE lcm_user (
    login VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    client_id VARCHAR(255),
    role VARCHAR(255),
    enabled BOOLEAN DEFAULT true,
    PRIMARY KEY (login)
)