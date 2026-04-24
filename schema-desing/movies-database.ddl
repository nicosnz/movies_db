CREATE SCHEMA content;
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE content.genre (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(100) NOT NULL,
    created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE content.person (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE content.film_work (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(100) NOT NULL,
    creation_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    rating DECIMAL(10,2) NOT NULL,
    type VARCHAR(100) NOT NULL,
    created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE content.person_film_work (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID REFERENCES content.person(id),
    film_work_id UUID REFERENCES content.film_work(id),
    role VARCHAR(100) NOT NULL,
    created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE content.genre_film_work (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    genre_id UUID REFERENCES content.genre(id),
    film_work_id UUID REFERENCES content.film_work(id),
    created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO content.genre (name, description)
SELECT 
    'Genre ' || i,
    'Descripción del género ' || i
FROM generate_series(1, 100) AS i;

INSERT INTO content.person (full_name)
SELECT 
    'Person ' || i
FROM generate_series(1, 100) AS i;

INSERT INTO content.film_work (title, description, rating, type)
SELECT 
    'Movie ' || i,
    'Descripción de la película ' || i,
    ROUND((RANDOM() * 10)::numeric, 2),
    CASE 
        WHEN i % 2 = 0 THEN 'movie'
        ELSE 'series'
    END
FROM generate_series(1, 100) AS i;

INSERT INTO content.person_film_work (person_id, film_work_id, role)
SELECT 
    p.id,
    f.id,
    CASE 
        WHEN RANDOM() > 0.5 THEN 'actor'
        ELSE 'director'
    END
FROM content.person p
JOIN content.film_work f ON TRUE
LIMIT 100;

INSERT INTO content.genre_film_work (genre_id, film_work_id)
SELECT 
    g.id,
    f.id
FROM content.genre g
JOIN content.film_work f ON TRUE
LIMIT 100;