CREATE OR REPLACE FUNCTION tsq_parse(config regconfig, search_query text)
RETURNS tsquery AS $$
    SELECT tsq_process_tokens(config, tsq_tokenize(search_query));
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION tsq_parse(config text, search_query text)
RETURNS tsquery AS $$
    SELECT tsq_parse(config::regconfig, search_query);
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION tsq_parse(search_query text) RETURNS tsquery AS $$
    SELECT tsq_parse(get_current_ts_config(), search_query);
$$ LANGUAGE SQL IMMUTABLE;

DROP TABLE IF EXISTS clubs;
CREATE TABLE clubs (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    website_url TEXT,
    facebook_url TEXT,
    instagram_url TEXT,
    twitter_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc'),
    search_vector TSVECTOR
);

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT NOT NULL,
    username TEXT NOT NULL UNIQUE,
    secret TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc')
);

DROP TABLE IF EXISTS memberships;
CREATE TABLE memberships (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users(id),
    club_id INT REFERENCES clubs(id),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (now() at time zone 'utc')
);
