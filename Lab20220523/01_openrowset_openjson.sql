/* 
    Read json file; and process each record with attributes defined by "o" 
    OPENROWSET https://docs.microsoft.com/en-us/sql/t-sql/functions/openrowset-transact-sql?view=sql-server-ver15
    SINGLE_CLOB https://docs.microsoft.com/en-us/sql/t-sql/functions/openrowset-transact-sql?view=sql-server-ver15
    OPENJSON    https://docs.microsoft.com/en-us/sql/t-sql/functions/openjson-transact-sql?view=sql-server-ver15
*/

select o.*
-- '/tmp/challenge_set.json' un path accessible por la instancia
from OPENROWSET(BULK 'd:\Fundación\Database Branch\Database Basics on TSQL\db_sessions\day12\challenge_set.json', SINGLE_CLOB) as x -- data referencia al contenido del file
cross apply OPENJSON(BULKCOLUMN, '$.playlists') -- accedo a la data como este alias "BULKCOLUMN"
-- cada objeto dentro de playlist tiene esta forma
with(
    name varchar(200) '$.name',
    num_holdouts int '$.num_holdouts',
    pid int '$.pid',
    num_tracks int '$.num_tracks',
    tracks nvarchar(max) '$.tracks' as JSON,
    num_samples int '$.num_samples'
)  as o -- a cada objeto dentro de playlist lo referenciamos por "o"
where o.tracks is not null 