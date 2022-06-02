/*
    Load data in [preprod].Album table
*/
USE LAB20220523

TRUNCATE TABLE [preprod].Album
GO

INSERT INTO [preprod].Album
(
    album_name,
    album_uri
)
SELECT album_name, album_uri
FROM (
    select distinct rt.album_name, rt.album_uri
    from [raw].Track rt
) new
ORDER by album_name

select *
from preprod.Album