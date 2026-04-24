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

CREATE INDEX idx_person_film_person
ON content.person_film_work (person_id);

CREATE INDEX idx_person_film_work
ON content.person_film_work (film_work_id);

CREATE TABLE content.genre_film_work (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    genre_id UUID REFERENCES content.genre(id),
    film_work_id UUID REFERENCES content.film_work(id),
    created TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


CREATE INDEX idx_genre_id
ON content.genre_film_work(genre_id);
CREATE INDEX idx_genre_film_work_id
ON content.genre_film_work(film_work_id);

INSERT INTO content.genre (name, description)
VALUES 
('Action', 'Películas de acción'),
('Drama', 'Películas dramáticas'),
('Comedy', 'Películas de comedia');

INSERT INTO content.person (full_name)
VALUES 
('Leonardo DiCaprio'),
('Christopher Nolan'),
('Robert Downey Jr.');

INSERT INTO content.film_work (title, description, rating, type)
VALUES
('Inception', 'Sueños dentro de sueños', 9.0, 'movie'),
('Iron Man', 'Origen de Iron Man', 8.5, 'movie');

INSERT INTO content.person_film_work (person_id, film_work_id, role)
SELECT p.id, f.id, 'actor'
FROM content.person p, content.film_work f
WHERE p.full_name = 'Leonardo DiCaprio'
AND f.title = 'Inception';  

INSERT INTO content.genre_film_work (genre_id, film_work_id)
SELECT g.id, f.id
FROM content.genre g, content.film_work f
WHERE g.name = 'Action'
AND f.title = 'Inception';