/*
    Load data in [raw].Playlist table
*/
USE LAB20220523

truncate table [raw].Playlist
GO

insert into [raw].Playlist
(
    pid,
    name,
    num_holdouts,
    num_samples,
    num_tracks
)
select playlist.pid, playlist.name, playlist.num_holdouts, playlist.num_samples, playlist.num_tracks
from OPENROWSET(BULK 'd:\Fundación\Database Branch\Database Basics on TSQL\db_sessions\day12\challenge_set.json', SINGLE_CLOB) as x -- data referencia al contenido del file
cross apply OPENJSON(BULKCOLUMN, '$.playlists') -- accedo a la data como este alias "BULKCOLUMN"
-- cada objeto (row/fila) dentro de playlist tiene esta forma
with(
    name nvarchar(200) '$.name',
    num_holdouts int '$.num_holdouts',
    pid int '$.pid',
    num_tracks int '$.num_tracks',
    -- tracks nvarchar(max) '$.tracks' as JSON,
    num_samples int '$.num_samples'
)  as playlist -- a cada objeto dentro de playlist lo referenciamos por "playlist"

select count(1)
from [raw].Playlist