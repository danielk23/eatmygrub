CREATE DATABASE eatmygrub_library;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(600),
    first_name VARCHAR(400),
    last_name VARCHAR(400),
    email VARCHAR(600),
    password_digest VARCHAR(600)
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    date_event VARCHAR(600),
    location_event VARCHAR (600),
    nbr_guest INTEGER,
    food_category VARCHAR(600),
    menu_description VARCHAR(1000),
    price VARCHAR(400)
);


ALTER TABLE events ADD COLUMN time_event VARCHAR(400);

ALTER TABLE events ADD COLUMN image_url VARCHAR(1000);

ALTER TABLE events DROP COLUMN menu_description;

ALTER TABLE events ADD COLUMN menu_description TEXT;

ALTER TABLE events ADD COLUMN guest_id INTEGER;