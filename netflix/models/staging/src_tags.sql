with raw_tags as (
    select *
    from MOVILENS.RAW.raw_tags
)

select
    userId as user_id,
    movieId as movie_id,
    tag,
    to_timestamp_ltz(timestamp) as tag_timestamp
from raw_tags


