/*
    Create database: Lab20220526
    create schema: raw
    create required [raw] tables
*/

USE master
GO

IF NOT EXISTS(SELECT * FROM sys.sysdatabases WHERE name='Lab20220526')
BEGIN
    CREATE DATABASE [Lab20220526];
END
GO

USE Lab20220526
GO

IF NOT EXISTs(SELECT * FROM sys.schemas WHERE name='raw')
BEGIN
    EXECUTE sp_executesql N'CREATE SCHEMA raw'
END

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('raw.genres') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE raw.genres
END
CREATE TABLE [raw].[genres] (
    id int,
    name varchar(100)
)

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('raw.top_rated') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE raw.top_rated
END
CREATE TABLE [raw].[top_rated] (
    id int,
    adult VARCHAR(10),
    backdrop_path VARCHAR(max),
    genre_ids NVARCHAR(MAX),
    original_language VARCHAR(max),
    original_title NVARCHAR(max),
    overview VARCHAR(max),
    popularity FLOAT,
    poster_path VARCHAR(max),
    release_date DATETIME,
    title nvarchar(max),
    video varchar(10),
    vote_average FLOAT,
    vote_count int,
    genre_id int
)