/*
    Load "top_rated" files in [raw] table
    - Loading Strategy DROP TABLE IF EXIST/CREATE TABLE/ INSERT
*/


-- Copiar los files a un directorio que la instancia de SQL server pueda acceder: mi maquina
-- En el mundo real: File Share, "FTP", "S3", Cloud de Google, Azure storage..etc

USE Lab20220526
GO

TRUNCATE TABLE [raw].top_rated

-- Load "top_rated" fileS
declare @total_file_count INT = 499
declare @path VARCHAR(100) = 'd:\Fundación\Database Branch\Database Basics on TSQL\db_sessions\day14\data'
declare @prefix VARCHAR(50) = 'top_rated'
declare @timestamp VARCHAR(50) = '20220526'

-- Generar 499 nombres de archivo y guardarlos en un TABLE variable
declare @n INT = 1
declare @filenames TABLE (filepath VARCHAR(200))
WHILE @n <= @total_file_count
BEGIN
    INSERT INTO @filenames VALUES (
        CONCAT(
            @path,
            '/',
            @prefix,
            '_',
            @timestamp,
            '_',
            @n,
            '.json'
        )
    )
    SET @n = @n + 1
END

--select * from @filenames

-- Load data 
-- Leer la tabla que contiene los nombres de archivos con CURSOR
-- declaro CURSOR para leer los datos que resultan en este consulta `select * from @filenames`
declare @myfilepath VARCHAR(MAX)
declare @bulkcolumn VARCHAR(200) = '''$.results'''
declare @withalias VARCHAR(200) = 'top_rated'
declare @withcolumns VARCHAR(max) = 'id int ''$.id'', 
                                    adult VARCHAR(10) ''$.adult'', 
                                    backdrop_path varchar(max) ''$.backdrop_path'',
                                    genre_ids nvarchar(max) ''$.genre_ids'' as JSON,
                                    original_language varchar(max) ''$.original_language'',
                                    original_title NVARCHAR(max) ''$.original_title'',
                                    overview VARCHAR(max) ''$.overview'',
                                    popularity FLOAT ''$.popularity'',
                                    poster_path VARCHAR(max) ''$.poster_path'',
                                    release_date DATETIME ''$.release_date'',
                                    title nvarchar(max) ''$.title'',
                                    video varchar(10) ''$.video'',
                                    vote_average FLOAT ''$.vote_average'',
                                    vote_count int ''$.vote_count''
                                    '

declare f cursor for  select filepath from @filenames
    open f  -- abri el grifo (cursor) para que los datos comiencen a entran en el contexto de mi script 
    -- recibimos una gota de agua (un dato) o un valor que corresponde a filepath
    -- el dato leido a traves del curso lo guardamos en la vaariable @myfilepath
    fetch next from f into @myfilepath
    -- Mientras existan datos por leer
    while @@fetch_status <> - 1
    begin 
        print @myfilepath

        DECLARE @sql NVARCHAR(max) = CONCAT(
            N'SELECT ', @withalias, '.*, genres.*',
            N' FROM OPENROWSET(BULK ', '''', @myfilepath, '''', ', SINGLE_CLOB) as d',
            N' cross apply openjson(BULKCOLUMN, ', @bulkcolumn, ')',
            N' with',
            N' (', @withcolumns, N') ', @withalias,
            N' cross apply openjson(', @withalias, '.genre_ids, ''$'')',
            N' with',
            N' (genre_id int ''$'') genres'
        )

        print @sql

        insert into [raw].top_rated
        (
            id,
            adult,
            backdrop_path,
            genre_ids ,
            original_language,
            original_title,
            overview,
            popularity,
            poster_path,
            release_date,
            title,
            video,
            vote_average,
            vote_count,
            genre_id
        )
        EXECUTE sp_executesql @sql

        -- Yo continuo leyendo
        fetch next from f into @myfilepath
    END
    -- debemos cerrar el flujo
    close f 
    deallocate f


SELECT *
FROM [raw].top_rated