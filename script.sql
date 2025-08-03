
-- ce criipt SQL est utilisé pour configurer l'environnement Snowflake pour le projet dbt Netflix.

USE ROLE ACCOUNTADMIN;

-- Step 2: Create the `transform` role and assign it to ACCOUNTADMIN
CREATE ROLE IF NOT EXISTS TRANSFORM;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;

-- Step 3: Create a default warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;

-- Step 4: Create the `dbt` user and assign to the transform role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE=TRANSFORM
  DEFAULT_NAMESPACE='MOVIELENS.RAW'
  COMMENT='DBT user used for data transformation';
  
ALTER USER dbt SET TYPE = LEGACY_SERVICE;
GRANT ROLE TRANSFORM TO USER dbt;

create database if not exists movilens;
create schema if not exists raw;
create schema if not exists DEV;


-- creation de l'integration AWS en utilisant un stage
create stage dbt_netflix
url='s3://netflix-dbt-project-dwh'
credentials=(AWS_KEY_ID='my_id', AWS_SECRET_KEY='my_secret'); -- aller configurer les credentials AWS


drop file format raw_movies_format;

CREATE OR REPLACE FILE FORMAT raw_movies_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  TRIM_SPACE = TRUE
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
  ENCODING = 'UTF8';


    

/*creation des tables et chargement des données dans la les shema raw*/

-- cas de la table movies

create or replace table raw_movies(
    movieId integer,
    title string,
    genres string

);


COPY INTO raw_movies
FROM @DBT_NETFLIX/movies.csv
FILE_FORMAT = (FORMAT_NAME = 'raw_movies_format');


select * from raw_movies;


-- cas de la table rating



create or replace table raw_ratings(
    userId integer,
    movieId integer,
    rating float,
    timestamp bigint
);


COPY INTO raw_ratings
FROM @DBT_NETFLIX/ratings.csv
FILE_FORMAT = (FORMAT_NAME = 'raw_movies_format');

select * 
from raw_ratings
limit 100; 

-- cas de la table des tags

create or replace table raw_tags(
    userId integer,
    movieId integer,
    tag string,
    timestamp bigint
);

COPY INTO raw_tags
FROM @DBT_NETFLIX/tags.csv
FILE_FORMAT = (FORMAT_NAME = 'raw_movies_format');

select * from raw_tags;


 -- Chargement de la table raw_links
CREATE OR REPLACE TABLE raw_links (
  movieId INTEGER,
  imdbId INTEGER,
  tmdbId INTEGER
);

COPY INTO raw_links
FROM @DBT_NETFLIX/links.csv
FILE_FORMAT = (FORMAT_NAME = 'raw_movies_format');

select *
from raw_links;



-- Load raw_genome_scores


CREATE OR REPLACE TABLE raw_genome_scores (
  movieId INTEGER,
  tagId INTEGER,
  relevance FLOAT
);

COPY INTO raw_genome_scores
FROM @DBT_NETFLIX/genome-scores.csv
FILE_FORMAT = (FORMAT_NAME = 'raw_movies_format');


-- Load raw_genome_tags
CREATE OR REPLACE TABLE raw_genome_tags (
  tagId INTEGER,
  tag STRING
);


COPY INTO raw_genome_tags
FROM @DBT_NETFLIX/genome-tags.csv
FILE_FORMAT = (FORMAT_NAME = 'raw_movies_format');

select *
from raw_genome_tags
limit 100;


select *
from raw_genome_tags;




