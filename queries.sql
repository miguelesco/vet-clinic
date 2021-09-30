/*Queries that provide answers to the questions from all projects.*/

/* Find all animals whose name ends in "mon". */

SELECT * FROM animals
WHERE name LIKE '%mon%';

/* List the name of all animals born between 2016 and 2019. */

SELECT name FROM animals
WHERE date_of_birth >= '2016-01-01' AND date_of_birth < '2019-01-01'

/*  List the name of all animals that are neutered and have less than 3 escape attempts. */

SELECT name FROM animals
WHERE neutered = TRUE AND escape_attempts < 3

/* List date of birth of all animals named either "Agumon" or "Pikachu". */

SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu')

/*  List name and escape attempts of animals that weigh more than 10.5kg */

SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5

/*  Find all animals that are neutered. */

SELECT * FROM animals
WHERE neutered

/*  Find all animals not named Gabumon. */

SELECT * FROM animals
WHERE name != 'Gabumon'

/*  Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) */

SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3 OR weight_kg = 10.4 AND weight_kg = 17.3;

-- DAY 2 --

/* Inside a transaction update the animals table by setting 
the species column to unspecified. Verify that change was 
made. Then roll back the change and verify that species 
columns went back to the state before tranasction. */

BEGIN;
	UPDATE animals
	SET species = 'unspecified';
	SELECT species from animals;
/* Then roll back the change */
ROLLBACK;

/* verify that species columns went back to 
the state before tranasction. */
SELECT species from animals;

BEGIN;
/* Update the animals table by setting the species column 
to digimon for all animals that have a name ending in mon. */

	UPDATE animals
	SET species = 'digimon'
	WHERE name LIKE '%mon';
/* Update the animals table by setting the species column 
to pokemon for all animals that don't have species already set. */

	UPDATE animals
	SET species = 'pokemon'
	WHERE species ISNULL;
COMMIT;

/* Verify that change was made and persists after commit. */
SELECT species FROM animals

/* Now, take a deep breath and... Inside a transaction delete all 
records in the animals table, then roll back the transaction. */
BEGIN;
	DELETE FROM animals;
ROLLBACK;

/* After the roll back verify if all records in the animals table still exist. 
After that you can start breath as usual ;) */
SELECT * FROM animals

BEGIN;
/* Delete all animals born after Jan 1st, 2022. */
	DELETE FROM animals
	WHERE date_of_birth >= '2022-01-01';
/* Create a savepoint for the transaction. */
	SAVEPOINT deleteBirthDay;

/* Update all animals' weight to be their weight multiplied by -1. */
	UPDATE animals
	SET weight_kg = weight_kg * -1;
	
/* Rollback to the savepoint */
	ROLLBACK TO deleteBirthDay;

/* Update all animals' weights that are negative to be their weight 
multiplied by -1. */
	UPDATE animals 
	SET weight_kg = weight_kg * -1
	WHERE SIGN(weight_kg) = -1; 
COMMIT;


/* How many animals are there? */
SELECT COUNT(*) FROM animals;

/* How many animals have never tried to escape? */
SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

/* What is the average weight of animals? */
SELECT AVG(weight_kg) FROM animals;

/* Who escapes the most, neutered or not neutered animals? */
SELECT neutered, COUNT(escape_attempts) FROM animals
GROUP BY neutered;

/* What is the minimum and maximum weight of each type of animal? */
SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals
GROUP BY species;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth >= '1990-01-01' AND date_of_birth <= '2000-01-01'
GROUP BY species;

-- DAY 3 -- 

/* What animals belong to Melody Pond? */
SELECT name FROM animals
INNER JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */
SELECT * FROM animals 
JOIN species ON animals.species_id = species.id AND species.name = 'Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT name, full_name FROM animals
RIGHT JOIN owners ON animals.owner_id = owners.id;

/* How many animals are there per species? */
SELECT species.name, COUNT(species.name) FROM animals 
JOIN species ON species_id = species.id 
GROUP BY species.name;

/* List all Digimon owned by Jennifer Orwell. */
SELECT * FROM animals 
JOIN species ON animals.species_id = species.id AND species.name = 'Digimon'
JOIN owners ON animals.owner_id = owners.id AND owners.full_name = 'Jennifer Orwell';

/* List all animals owned by Dean Winchester that haven't tried to escape. */
Select * FROM animals 
JOIN owners ON animals.owner_id = owners.id 
AND owners.full_name = 'Dean Winchester' 
AND animals.escape_attempts = 0;

/* Who owns the most animals? */
Select full_name, COUNT(owner_id) FROM animals
JOIN owners ON animals.owner_id = owners.id
GROUP BY full_name
ORDER BY COUNT(owner_id) DESC LIMIT 1;