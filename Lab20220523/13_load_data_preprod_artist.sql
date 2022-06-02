/*
    Load data in [preprod].Artist table
*/
USE LAB20220523

TRUNCATE TABLE [preprod].Artist
GO

INSERT INTO [preprod].Artist
(
    artist_name,
    artist_uri
)
SELECT artist_name, artist_uri
FROM (
    select distinct rt.artist_name, rt.artist_uri
    from [raw].Track rt
) new
ORDER by artist_uri

select *
from [preprod].Artist