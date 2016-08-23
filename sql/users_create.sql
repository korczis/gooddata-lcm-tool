-- auto-generated definition
CREATE TABLE lcm_users (
    project_id VARCHAR(255) NOT NULL,
    login VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    role VARCHAR(255),
    enabled BOOLEAN DEFAULT true,
    PRIMARY KEY (project_id)
)