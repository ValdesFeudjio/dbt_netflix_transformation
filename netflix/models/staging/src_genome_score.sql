with raw_genome_scrores as (
    select *
    from MOVILENS.RAW.RAW_GENOME_SCORES
)

select
    movieId as movie_id,
    tagId as tag_id,
    relevance
from raw_genome_scrores


