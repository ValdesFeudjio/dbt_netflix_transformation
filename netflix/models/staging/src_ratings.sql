{{ config(
    materialized='table'
) }}

with raw_rating as (
    select *
    from MOVILENS.RAW.RAW_RATINGS
)

select
    userId as user_id,
    movieId as movie_id,
    rating,
    to_timestamp_ltz(timestamp) as timestamp
from raw_rating
