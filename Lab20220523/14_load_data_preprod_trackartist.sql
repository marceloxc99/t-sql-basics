/*
    Load data in [preprod].TrackArtist table
*/
USE LAB20220523

TRUNCATE TABLE [preprod].TrackArtist
GO

INSERT INTO [preprod].TrackArtist
(
    artist_uri,
    track_uri
)
SELECT artist_uri, track_uri
FROM (
    select distinct rt.artist_uri, rt.track_uri
    from raw.Track rt
) new
ORDER by artist_uri

select *
from [preprod].TrackArtist
