/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
	id INT PRIMARY KEY NOT NULL,
	name text NOT NULL,
	date_of_birth DATE NOT NULL,
	escape_attemps INT,
	neutered BOOLEAN,
	weight_kg DECIMAL
);

/* Add a column species of type string to your animals table. */

ALTER TABLE animals
ADD COLUMN species char(500);