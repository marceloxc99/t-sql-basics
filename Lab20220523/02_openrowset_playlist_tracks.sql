/* 
    Read json file; process each record with attributes defined by "playlist" 
    then Process each "playlist" tracks as json object
*/


-- cada "tracks" object es un JSON array

-- obtener los attribs de cada objeto entro del array

-- playlist.* Todos los atributos (columnas de) playlist
select  track.*, playlist.*
from OPENROWSET(BULK 'd:\Fundación\Database Branch\Database Basics on TSQL\db_sessions\day12\challenge_set.json', SINGLE_CLOB) as x -- data referencia al contenido del file
cross apply OPENJSON(BULKCOLUMN, '$.playlists') -- accedo a la data como este alias "BULKCOLUMN"
-- cada objeto (row/fila) dentro de playlist tiene esta forma
with(
    name varchar(200) '$.name',
    num_holdouts int '$.num_holdouts',
    pid int '$.pid',
    num_tracks int '$.num_tracks',
    tracks nvarchar(max) '$.tracks' as JSON,
    num_samples int '$.num_samples'
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
) track