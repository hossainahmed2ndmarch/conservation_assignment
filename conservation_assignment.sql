-- Table: rangers
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

-- Table: species
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) DEFAULT 'Unknown'
);

-- Table: sightings
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species (species_id) ON DELETE CASCADE,
    ranger_id INT REFERENCES rangers (ranger_id) ON DELETE CASCADE,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(150) NOT NULL,
    notes TEXT
);

-- Rangers working in various regions
INSERT INTO
    rangers (name, region)
VALUES (
        'Meera Haque',
        'Sundarbans West'
    ),
    (
        'Tariq Islam',
        'Chittagong Hill Tracts'
    ),
    (
        'Nusrat Rahman',
        'Lawachara Forest, Sylhet'
    );

INSERT INTO
    rangers (name, region)
VALUES (
        'Shahidul Alam',
        'Rema-Kalenga Wildlife Sanctuary'
    ),
    (
        'Farzana Akter',
        'Teknaf Wildlife Sanctuary'
    ),
    (
        'Mizanur Rahman',
        'Tanguar Haor, Sunamganj'
    );

-- Wildlife species
INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Asian Elephant',
        'Elephas maximus',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Hoolock Gibbon',
        'Hoolock hoolock',
        '1867-01-01',
        'Vulnerable'
    ),
    (
        'Fishing Cat',
        'Prionailurus viverrinus',
        '1833-01-01',
        'Vulnerable'
    );

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Clouded Leopard',
        'Neofelis nebulosa',
        '1821-01-01',
        'Vulnerable'
    ),
    (
        'Saltwater Crocodile',
        'Crocodylus porosus',
        '1801-01-01',
        'Least Concern'
    ),
    (
        'Oriental Pied Hornbill',
        'Anthracoceros albirostris',
        '1786-01-01',
        'Near Threatened'
    ),
    (
        'Indian Pangolin',
        'Manis crassicaudata',
        '1822-01-01',
        'Endangered'
    );

-- Wildlife sightings locations
INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Kochikhali Zone, Sundarbans',
        '2024-06-01 06:30:00',
        'Fresh paw prints and scratch marks found'
    ),
    (
        2,
        2,
        'Naikhongchhari Range, Bandarban',
        '2024-06-03 17:10:00',
        'Herd movement recorded near salt lick'
    ),
    (
        3,
        3,
        'Lawachara National Park',
        '2024-06-04 08:45:00',
        'Gibbon pair observed vocalizing'
    ),
    (
        4,
        1,
        'Dhangmari, Sundarbans',
        '2024-06-05 19:15:00',
        'Spotted near a stream at dusk'
    );

INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        5,
        2,
        'Rowangchhari Forest, Bandarban',
        '2024-06-06 05:50:00',
        'Heard call near hill stream'
    ),
    (
        6,
        1,
        'Kotka, Sundarbans East',
        '2024-06-07 13:25:00',
        'Crocodile basking on riverbank'
    ),
    (
        7,
        4,
        'Rema-Kalenga Forest Edge',
        '2024-06-08 07:15:00',
        'Hornbill nesting activity observed'
    ),
    (
        8,
        6,
        'Tanguar Haor Wetland',
        '2024-06-09 18:40:00',
        'Burrow site found near water body'
    );

-- Problem 1
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains')

-- Problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Problem 3
SELECT * FROM sightings WHERE location ILIKE '%Sundarbans%';

-- Problem 4
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
    LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY
    r.name;

-- Problem 5
SELECT common_name
FROM species
WHERE
    species_id NOT IN (
        SELECT DISTINCT
            species_id
        FROM sightings
    );

-- Problem 6
SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings s
    JOIN species sp ON s.species_id = sp.species_id
    JOIN rangers r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Problem 7
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01';

-- Problem 8
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 17  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- Problem 9
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );

SELECT current_database();