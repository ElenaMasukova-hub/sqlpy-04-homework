DROP TABLE IF EXISTS collection_track CASCADE;
DROP TABLE IF EXISTS genre_artist CASCADE;
DROP TABLE IF EXISTS artist_album CASCADE;
DROP TABLE IF EXISTS tracks CASCADE;
DROP TABLE IF EXISTS collections CASCADE;
DROP TABLE IF EXISTS albums CASCADE;
DROP TABLE IF EXISTS artists CASCADE;
DROP TABLE IF EXISTS genres CASCADE;

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL
);
CREATE TABLE artists (
    artist_id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL
);
CREATE TABLE albums (
    album_id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, release_year INTEGER
);
CREATE TABLE tracks (
    track_id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, duration INTEGER, album_id INTEGER REFERENCES albums(album_id)
);
CREATE TABLE collections (
    collection_id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, release_year INTEGER
);
CREATE TABLE genre_artist (
    genre_id INTEGER REFERENCES genres(genre_id),
    artist_id INTEGER REFERENCES artists(artist_id),
    PRIMARY KEY (genre_id, artist_id)
);
CREATE TABLE artist_album (
    artist_id INTEGER REFERENCES artists(artist_id),
    album_id INTEGER REFERENCES albums(album_id),
    PRIMARY KEY (artist_id, album_id)
);
CREATE TABLE collection_track (
    collection_id INTEGER REFERENCES collections(collection_id),
    track_id INTEGER REFERENCES tracks(track_id),
    PRIMARY KEY (collection_id, track_id)
);

INSERT INTO genres (name) VALUES 
('поп'), ('поп-рок'), ('соул'), ('рэп'), ('джаз');

INSERT INTO artists (name) VALUES 
('Hilary Duff'), ('Akon'), ('Simple Plan'), ('Vance Joy'), ('Nina Simone');

INSERT INTO genre_artist (genre_id, artist_id) VALUES 
(1,1), -- Hilary Duff - поп
(4,2), -- Akon - рэп
(2,3), -- Simple Plan - поп-рок
(1,4), -- Vance Joy - поп
(3,5), -- Nina Simone - соул
(5,5); -- Nina Simone - джаз

INSERT INTO albums (name, release_year) VALUES 
('Metamorphosis', 2003),
('Konvicted', 2006), 
('No Pads, No Helmets...Just Balls', 2002),
('Dream Your Life Away', 2014);

INSERT INTO artist_album (artist_id, album_id) VALUES 
(1,1), (2,2), (3,3), (4,4);

INSERT INTO tracks (name, duration, album_id) VALUES 
('So Yesterday', 237, 1), ('Come Clean', 214, 1),
('Don''t Matter', 244, 2), ('Lonely', 228, 2),
('I''d Do Anything', 183, 3), ('Welcome to My Life', 218, 3),
('Riptide', 204, 4), ('Mess Is Mine', 223, 4),
('Feeling Good', 168, NULL);

INSERT INTO collections (name, release_year) VALUES 
('Поп 2000-х', 2010), ('Радио Хиты', 2015), 
('Лучшее Поп-Рок', 2020), ('Классика Соула', 2005);

INSERT INTO collection_track (collection_id, track_id) VALUES 
(1,1), (1,3), (2,2), (2,7), (3,5), (3,6), (4,9);


INSERT INTO albums (name, release_year) VALUES ('Nation of Two', 2019);
INSERT INTO artist_album (artist_id, album_id) VALUES (4,5); -- Vance Joy
INSERT INTO albums (name, release_year) VALUES ('Harder Than It Looks', 2020);
INSERT INTO artist_album (artist_id, album_id) VALUES (3,6); -- Simple Plan
INSERT INTO tracks (name, duration, album_id) VALUES 
('Saturday Sun', 239, 5), ('Iconic', 195, 6);


SELECT '1. Длиннейший трек:' as check, name, duration FROM tracks ORDER BY duration DESC LIMIT 1;
SELECT '2. ≥3:30:' as check, name, duration FROM tracks WHERE duration >= 210;
SELECT '3. 2018-2020:' as check, name FROM collections WHERE release_year BETWEEN 2018 AND 2020;
SELECT '4. 1 слово:' as check, name FROM artists WHERE name NOT LIKE '% %';
SELECT '5. my:' as check, name FROM tracks WHERE name ILIKE '%my%';


SELECT '1. Жанры:' as check, g.name, COUNT(ga.artist_id) as count 
FROM genres g JOIN genre_artist ga ON g.genre_id = ga.genre_id 
GROUP BY g.genre_id, g.name;


SELECT '2. 2019-20:' as check, COUNT(*) as count 
FROM tracks t JOIN albums a ON t.album_id = a.album_id 
WHERE a.release_year BETWEEN 2019 AND 2020;


SELECT '3. Альбомы:' as check, a.name, ROUND(AVG(t.duration), 1) as round 
FROM albums a JOIN tracks t ON a.album_id = t.album_id 
GROUP BY a.album_id, a.name;


SELECT '4. Без 2020:' as check, DISTINCT a.name 
FROM artists a 
LEFT JOIN artist_album aa ON a.artist_id = aa.artist_id 
LEFT JOIN albums al ON aa.album_id = al.album_id AND al.release_year = 2020 
WHERE al.album_id IS NULL;


SELECT '5. Simple Plan:' as check, DISTINCT c.name 
FROM collections c 
JOIN collection_track ct ON c.collection_id = ct.collection_id 
JOIN tracks t ON ct.track_id = t.track_id 
JOIN albums al ON t.album_id = al.album_id 
JOIN artist_album aa ON al.album_id = aa.album_id 
JOIN artists a ON aa.artist_id = a.artist_id 
WHERE a.name = 'Simple Plan';