/*
    Load data in [raw].Track table
*/

USE LAB20220523

truncate table [raw].Track
GO

insert into [raw].Track
(
    pid,
    pos,
    track_name,
    track_uri,
    artist_name,
    artist_uri,
    album_name,
    album_uri,
    duration_ms
)
select playlist.pid, 
    track.pos, track.track_name,      
    track.track_uri, track.artist_name, 
    track.artist_uri, track.album_name, 
    track.album_uri, track.duration_ms
-- playlist.*, track.*
from OPENROWSET(BULK 'd:\Fundación\Database Branch\Database Basics on TSQL\db_sessions\day12\challenge_set.json', SINGLE_CLOB) as x -- data referencia al contenido del file
cross apply OPENJSON(BULKCOLUMN, '$.playlists') -- accedo a la data como este alias "BULKCOLUMN"
-- cada objeto (row/fila) dentro de playlist tiene esta forma
with(
    pid int '$.pid',
    tracks nvarchar(max) '$.tracks' as JSON
)  as playlist -- a cada objeto dentro de playlist lo referenciamos por "playlist"
-- where o.tracks is not null 
cross apply OPENJSON(playlist.tracks, '$')
with(
    -- este "attribute con este tipo de dato viene de este json property (attribute)"
    pos             int             '$.pos',
    artist_name     nvarchar(max)   '$.artist_name',
    track_uri       nvarchar(max)   '$.track_uri',
    artist_uri      nvarchar(max)   '$.artist_uri',
    track_name      nvarchar(max)   '$.track_name',
    album_uri       nvarchar(max)   '$.album_uri',
    duration_ms     int             '$.duration_ms',
    album_name      nvarchar(max)   '$.album_name'
) as track
-- where  pid = 1000002

select COUNT(1)
from [raw].[Track]