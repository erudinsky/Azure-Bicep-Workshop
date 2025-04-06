DROP DATABASE abw_db;
CREATE DATABASE abw_db;
\c abw_db;

DROP TABLE IF EXISTS books;

CREATE TABLE public.books (
    id serial PRIMARY KEY,
    title character varying(150) NOT NULL,
    author character varying(50) NOT NULL,
    pagesNum integer NOT NULL,
    read boolean NOT NULL,
    date_added date DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO books (title, author, pagesNum, read)
            VALUES ('The Phoenix Project','Gene Kim, Kevin Behr and George Spafford',431,True);

INSERT INTO books (title, author, pagesNum, read)
            VALUES ('Coders','Clive Thompson',436,False);

INSERT INTO books (title, author, pagesNum, read)
            VALUES ('Mindware: Tools for Smart Thinking','Richard E. Nisbett',336,False);
