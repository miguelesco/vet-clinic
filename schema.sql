/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(50),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL(10, 2),
  PRIMARY KEY(id)
);

/* Add a column species of type string to your animals table. */
ALTER TABLE animals
ADD COLUMN species char(500);

/* Create Table Owners */
CREATE TABLE owners(
	id INT GENERATED ALWAYS AS IDENTITY,
	full_name char(250),
	age INT,
	PRIMARY KEY(id)
);

/* Create Table Species */
CREATE TABLE species(
	id INT GENERATED ALWAYS AS IDENTITY,
	name char(250),
	PRIMARY KEY(id)
);

BEGIN;
	/* Remove column species */
	ALTER TABLE animals
	DROP COLUMN species;
	
	/* Add column species_id and owner_id */
	ALTER TABLE animals 
	ADD species_id INT;
	
	ALTER TABLE animals 
	ADD owner_id INT;
	
	/* Add the foreign key to species_id and owner_id */
	ALTER TABLE animals ADD CONSTRAINT owners_fk
	FOREIGN KEY(owner_id) REFERENCES owners(id);
	
	ALTER TABLE animals ADD CONSTRAINT species_fk
	FOREIGN KEY(species_id) REFERENCES species(id);
	
	SELECT * FROM animals
	ORDER BY id ASC
COMMIT;

/* Make sure that id is set as autoincremented PRIMARY KEY */
BEGIN;
	INSERT INTO animals(name, date_of_birth)
		VALUES ('test', 'Nov 05, 2020');
	SELECT * FROM animals
	ORDER BY id ASC
ROLLBACK;

-- DAY 3 ---

/* Create a table named vets with the following columns */
CREATE TABLE vets(
	id INT GENERATED ALWAYS AS IDENTITY,
	name char(50),
	age INT,
	date_of_graduation DATE,
	PRIMARY KEY(id)
);

/* Create table specializations */
CREATE TABLE specializations(
	vet_id INT,
	species_id INT,
	FOREIGN KEY(vet_id) REFERENCES vets(id),
	FOREIGN KEY(species_id) REFERENCES species(id)
);

/* Create table Visits */
CREATE TABLE visits(
	animals_id INT,
	visit_date DATE,
	vet_id INT,
	FOREIGN KEY(vet_id) REFERENCES vets(id),
	FOREIGN KEY(animals_id) REFERENCES animals(id)
);