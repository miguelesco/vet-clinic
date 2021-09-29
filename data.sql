/* Populate database with sample data. */

INSERT INTO ANIMALS (id, name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
	(1, 'Agumon', 'Feb 3, 2020', 0, TRUE, 10.23),
	(2, 'Gabumon', 'Nov 15, 2018', 2, TRUE, 8),
	(3, 'Pikachu', 'Jan 7, 2021', 1, FALSE, 15.04),
	(4, 'Devimon', 'May 12, 2017', 5, TRUE, 11),
	(5, 'Charmander', 'Feb 8, 2020', 0, FALSE, -11),
	(6, 'Plantmon', 'Nov 15, 2022', 2, TRUE, -5.7),
	(7, 'Squirtle', 'Apr 2, 1993', 3, FALSE, -12.13),
	(8, 'Angemon', 'Jun 12, 2005', 1, TRUE, -45),
	(9, 'Boarmon', 'Jun 7, 2005', 7, TRUE, 20.4),
	(10, 'Blossom', 'Oct 13, 1998', 3, TRUE, 17);

/* Insert the following data into the owners table */
INSERT INTO owners (full_name, age)
VALUES 
		('Sam Smith', 34),
		('Jennifer Orwell', 19),
		('Bob', 45),
		('Melody Pond', 77),
		('Dean Winchester', 14),
		('Jodie Whittaker', 38);

/* Insert the following data into the species table */
INSERT INTO species (name)
VALUES 
		('Pokemon'),
		('Digimon');

/* Modify your inserted animals so it includes the species_id value: */
UPDATE animals SET species_id = CASE WHEN name LIKE '%mon' THEN 2 ELSE 1 END;

/* Modify your inserted animals to include owner information (owner_id) */
BEGIN;
UPDATE animals SET owner_id = CASE 
	WHEN name IN ('Agumon') THEN 1
	WHEN name IN ('Gabumon', 'Pikachu') THEN 2
	WHEN name IN ('Devimon', 'Plantmon') THEN 3
	WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN 4
	WHEN name IN ('Angemon', 'Boarmon') THEN 5
END;

COMMIT;