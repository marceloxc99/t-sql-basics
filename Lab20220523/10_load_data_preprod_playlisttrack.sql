/*
    Load data in [preprod].PlaylistTrack table
*/
USE LAB20220523

TRUNCATE TABLE [preprod].PlaylistTrack
GO

INSERT INTO [preprod].PlaylistTrack
(
    pid,
    track_uri
)
SELECT pid, track_uri
FROM (
    select rp.pid, rt.track_uri
    from [raw].Playlist rp
    inner join [raw].Track rt
    on rt.pid = rp.pid
) new
ORDER by pid

select count(*)
from preprod.PlaylistTrack