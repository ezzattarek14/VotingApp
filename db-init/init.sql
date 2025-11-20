-- create votes table
CREATE TABLE IF NOT EXISTS votes (
    id SERIAL PRIMARY KEY,
    vote CHAR(1) NOT NULL
);
