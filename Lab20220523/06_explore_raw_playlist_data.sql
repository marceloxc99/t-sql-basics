/*
    Explore [raw].Playlist data
*/

-- Get all name values
SELECT name
from [raw].Playlist

-- get distinct name values
SELECT distinct name
from [raw].Playlist

-- cual es la frecuencia de cada valor de "name"
-- parece que name deberia ser un nvarchar!!!
SELECT name, pid, count(1) as cnt
from [raw].Playlist
-- where name = 'spanish playlist'
group by name, pid
order by cnt desc

-- leading/trailing spaces (no limpiar porque suponemos que los datos fueron creados de esta forma por el user del sistema origen)
SELECT name, count(1) as cnt
from [raw].Playlist
where name like ' % '
group by name
order by cnt desc

select *
from [raw].Playlist
where pid = 1000019

-- consulta para llenar playlist en preprod
select  rp.pid, 
        rp.name,
        CASE
            WHEN rp.name is null then 'DEFAULT'
            else rp.name
            END as name,
        rp.num_tracks
from [raw].[Playlist] rp
--where name is null
order by rp.pid
--COLLATE latin1_general_100_ci_as

-- consulta para llenar tracks en preprod
select track_uri, --COUNT(track_uri) as cnt,
    track_name,
    duration_ms,
    artist_uri,
    album_uri
from [raw].Track
GROUP BY track_uri, track_name, duration_ms, artist_uri, album_uri
ORDER by track_uri
--where album_uri = ''
--66,243

-- consulta para llenar playlist track en preprod
select *
from preprod.PlaylistTrack