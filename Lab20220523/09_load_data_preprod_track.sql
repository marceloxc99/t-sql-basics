/*
    Load data in [preprod].Track table
*/
USE LAB20220523

TRUNCATE TABLE [preprod].Track
GO

INSERT INTO [preprod].Track
(
    track_uri,
    track_name,
    duration_ms,
    artist_uri,
    album_uri
)
SELECT track_uri,
    track_name,
    duration_ms,
    artist_uri,
    album_uri
FROM [raw].Track
GROUP BY track_uri, track_name, duration_ms, artist_uri, album_uri
ORDER by track_uri

select *
from preprod.Track