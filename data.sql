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

UPDATE animals SET owner_id = owners.id FROM owners WHERE name = 'Agumon' AND owners.full_name= 'Sam Smith' ;

UPDATE animals SET owner_id = owners.id FROM owners WHERE name IN ('Gabumon','Pikachu') AND owners.full_name= 'Jennifer Orwell';

UPDATE animals SET owner_id = owners.id FROM owners WHERE name IN ('Devimon','Plantmon') AND owners.full_name= 'Bob';

UPDATE animals SET owner_id = owners.id FROM owners WHERE name IN ('Charmander','Squirtle', 'Blossom') AND owners.full_name= 'Melody Pond';

UPDATE animals SET owner_id = owners.id FROM owners WHERE name IN ('Angemon','Boarmon') AND owners.full_name= 'Dean Winchester';

COMMIT;

--- DAY 4 ---

/* Insert the following data for vets */
INSERT INTO vets(name, age, date_of_graduation)
VALUES 
		('William Tatcher', 45, 'Apr 23, 2000'),
		('Maisy Smith', 26, 'Jan 17, 2019'),
		('Stephanie Mendez', 64, 'May 4, 1981'),
		('Jack Harkness', 38, 'June 8, 2008');
		
/* Insert the following data for specialties */
BEGIN;		
	INSERT INTO specializations(vet_id, species_id)
	SELECT vets.id, species.id FROM vets
	JOIN species ON species.name = 'Pokemon' AND vets.name = 'William Tatcher';

	INSERT INTO specializations(vet_id, species_id)
	SELECT vets.id, species.id FROM species
	JOIN vets ON vets.name = 'Stephanie Mendez';

	INSERT INTO specializations(vet_id, species_id)
	SELECT vets.id, species.id FROM vets
	JOIN species ON species.name = 'Digimon' AND vets.name = 'Jack Harkness';
COMMIT;

/* function to save data into visits */

CREATE OR REPLACE function save_visit_date(animal_name char(50), vet_name text ARRAY, vi_date date ARRAY) 
		returns void
		language plpgsql
	as $$
	declare 
		vi_date_length numeric(10, 0) := 0;
		vet_name_length numeric(10, 0) := 0;
	begin
		vi_date_length := array_length(vi_date, 1);
		vet_name_length := array_length(vet_name, 1);
				
		if(vi_date_length > 0 AND vet_name_length > 0) then
			for i in 1..vi_date_length loop
				INSERT INTO visits(animals_id, vet_id, visit_date)
				SELECT animals.id, vets.id, vi_date[i] FROM vets
				JOIN animals ON animals.name = animal_name AND vets.name = vet_name[i];
			end loop;
		end if;
	end;
	$$

/* Insert the following data for visits */
BEGIN;
	SELECT * FROM save_visit_date('Agumon', '{"William Tatcher", "Stephanie Mendez"}', '{"May 24, 2020", "Jul 22, 2020"}');
	SELECT * FROM save_visit_date('Gabumon', '{"Jack Harkness"}', '{"Feb 2, 2021"}');
	SELECT * FROM save_visit_date('Pikachu', '{"Maisy Smith", "Maisy Smith", "Maisy Smith"}', '{"Jan 5, 2020", "Mar 8, 2020", "May 14, 2020"}');
	SELECT * FROM save_visit_date('Devimon', '{"Stephanie Mendez"}', '{"May 4, 2021"}');
	SELECT * FROM save_visit_date('Charmander', '{"Jack Harkness"}', '{"Feb 24, 2021"}');
	SELECT * FROM save_visit_date('Plantmon', '{"Maisy Smith", "William Tatcher", "Maisy Smith"}', '{"Dec 21, 2019", "Aug 10, 2020", "Apr 7, 2021"}');
	SELECT * FROM save_visit_date('Squirtle', '{"Stephanie Mendez"}', '{"Sep 29, 2019"}');
	SELECT * FROM save_visit_date('Angemon', '{"Jack Harkness", "Jack Harkness"}', '{"Oct 3, 2020", "Nov 4, 2020"}');
	SELECT * FROM save_visit_date('Boarmon', '{"Maisy Smith", "Maisy Smith", "Maisy Smith", "Maisy Smith"}', 
								  '{"Jan 24, 2019", "May 15, 2019", "Feb 27, 2020", "Aug 3, 2020"}');
	SELECT * FROM save_visit_date('Blossom', '{"Stephanie Mendez", "William Tatcher"}', '{"May 24, 2020", "Jan 11, 2021"}');
	
	Select * FROM visits;
COMMIT;