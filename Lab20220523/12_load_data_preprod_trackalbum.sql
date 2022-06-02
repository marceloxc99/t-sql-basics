/*
    Load data in [preprod].TrackAlbum table
*/
USE LAB20220523

TRUNCATE TABLE [preprod].TrackAlbum
GO

INSERT INTO [preprod].TrackAlbum
(
    album_uri,
    track_uri
)
SELECT album_uri, track_uri
FROM (
    select distinct rt.album_uri, rt.track_uri
    from raw.Track rt
) new
ORDER by album_uri

select *
from preprod.TrackAlbum