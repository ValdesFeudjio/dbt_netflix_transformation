with raw_links as (
    select *
    from MOVILENS.RAW.RAW_LINKS
)

select
    movieId as movie_id,
    imdbId as imdb_id,
    tmdbId as tmdb_id
from raw_links
