/*
    what are the top 40 Album name appearing most frequently in playlists
    Query [preprod] schema
*/

USE LAB20220523
GO

SELECT TOP 40 album_name, newAlbum.album_uri, COUNT(newAlbum.album_uri) as cnt
FROM preprod.Album
INNER JOIN ( --join to get album_name and count frequency :)
    SELECT pta.album_uri --this query select all ocurrencies of albums per playlists
    FROM preprod.PlaylistTrack pp
    INNER JOIN preprod.TrackAlbum pta
    ON pp.track_uri = pta.track_uri
) newAlbum
ON newAlbum.album_uri = preprod.Album.album_uri
GROUP by album_name, newAlbum.album_uri
ORDER by cnt desc