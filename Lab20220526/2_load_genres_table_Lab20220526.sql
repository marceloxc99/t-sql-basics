/*
    Load "genres" file in [raw] table
    - Loading Strategy DROP TABLE IF EXIST/CREATE TABLE/ INSERT
*/


-- Copiar los files a un directorio que la instancia de SQL server pueda acceder: mi maquina
-- En el mundo real: File Share, "FTP", "S3", Cloud de Google, Azure storage..etc

-- Load "genres" file in [raw]
-- USE constrainst like NOT NULL, UNIQUE  ONLY if you want the LOAD TO FAIL if certain columns violate constraints
-- [raw] do not add FK

-- ejecutar query con sp_executesql (NVARCHAR/NTEXT para el query string)

USE Lab20220526
GO

TRUNCATE TABLE [raw].genres

declare @filename VARCHAR(200) = '''d:\Fundación\Database Branch\Database Basics on TSQL\db_sessions\day14\data\genres.json'''
declare @bulkcolumn VARCHAR(200) = '''$.genres'''
declare @withcolumns VARCHAR(200) = 'id int ''$.id'', name varchar(100) ''$.name'''

print 'starting...'
DECLARE @sql NVARCHAR(max) = CONCAT(
    N'SELECT genre.*',
    N' FROM OPENROWSET(BULK ', @filename, ', SINGLE_CLOB) as d',
    N' cross apply openjson(BULKCOLUMN, ', @bulkcolumn, ')',
    N' with',
    N' (', @withcolumns, N') genre',
    N' order by genre.id'
)
print @sql

INSERT INTO [raw].genres
(
    id,
    name
)
EXECUTE sp_executesql @sql

select *
from [raw].genres