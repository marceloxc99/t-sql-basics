/*
    Load data in [preprod].Playlist table
*/
USE LAB20220523

TRUNCATE TABLE [preprod].Playlist
GO

INSERT INTO [preprod].Playlist
(
    pid,
    name,
    num_tracks
)
SELECT  rp.pid, 
        CASE
            WHEN rp.name is NULL THEN 'DEFAULT'
            ELSE rp.name
            END as name,
        rp.num_tracks
FROM [raw].[Playlist] rp
ORDER BY rp.pid

select *
from preprod.Playlist