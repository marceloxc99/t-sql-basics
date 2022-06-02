/*
    what is the Artist name appearing most frequently in playlists
    Query [preprod] schema
*/

USE LAB20220523
GO

SELECT TOP 1 artist_name, newArtist.artist_uri, COUNT(newArtist.artist_uri) as cnt
FROM preprod.Artist
INNER JOIN ( 
    SELECT pta.artist_uri 
    FROM preprod.PlaylistTrack pp
    INNER JOIN preprod.TrackArtist pta
    ON pp.track_uri = pta.track_uri
) newArtist
ON newArtist.artist_uri = preprod.Artist.artist_uri
GROUP by artist_name, newArtist.artist_uri
ORDER by cnt desc

-- retornar todos los tracks del artist uri spotify:artist:3TVXtAsR1Inumwj472S9r4
select pid, artist_name, artist_uri, track_name, new.track_uri
from preprod.PlaylistTrack
inner join (
    select pa.artist_name, pa.artist_uri, pt.track_name, pt.track_uri
    from preprod.Track pt
    inner join preprod.Artist pa
    on pt.artist_uri = pa.artist_uri
    where pa.artist_uri = 'spotify:artist:3TVXtAsR1Inumwj472S9r4'
) new
on new.track_uri = preprod.PlaylistTrack.track_uri