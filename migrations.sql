CREATE DATABASE restfulbands;

\c restfulbands

CREATE TABLE bands (id SERIAL PRIMARY KEY, name VARCHAR(255), genre VARCHAR(255));
CREATE TABLE musicians (id SERIAL PRIMARY KEY, name VARCHAR(255), instrument VARCHAR(255), favorite_drug VARCHAR(255), band_id integer);