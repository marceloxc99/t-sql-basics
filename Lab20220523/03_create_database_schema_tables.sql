/*
    Create database, schema, tables
    Make this script error safe
*/

USE master
GO

IF NOT EXISTS(SELECT * FROM sys.sysdatabases WHERE name='Lab20220523')
BEGIN
    CREATE DATABASE [Lab20220523];
END

USE Lab20220523
GO

IF NOT EXISTs(SELECT * FROM sys.schemas WHERE name='raw')
BEGIN
    EXECUTE sp_executesql N'CREATE SCHEMA raw'
END

IF NOT EXISTs(SELECT * FROM sys.schemas WHERE name='preprod')
BEGIN
    EXECUTE sp_executesql N'CREATE SCHEMA preprod'
END

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('raw.Playlist') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE raw.Playlist
END
CREATE TABLE [raw].[Playlist] (
    pid int, -- bigint???
    name nvarchar(max),
    num_holdouts int, 
    num_samples int, 
    num_tracks int
)

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('raw.Track') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE raw.Track
END
CREATE TABLE [raw].[Track] (
    pid int,
    pos int,
    track_name varchar(max),
    track_uri varchar(max),
    artist_name  varchar(max),
    artist_uri  varchar(max),
    album_name   varchar(max),
    album_uri   varchar(max),
    duration_ms int
)
-- PREPROD tables

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('preprod.Playlist') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE preprod.Playlist
END
CREATE TABLE [preprod].[Playlist] (
    pid int NOT NULL PRIMARY KEY,
    name nvarchar(max) NOT NULL,
    num_tracks int
)

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('preprod.Track') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE preprod.Track
END
CREATE TABLE [preprod].[Track] (
    track_id int IDENTITY PRIMARY KEY,
    track_uri varchar(max)  NOT NULL,
    track_name varchar(max) NOT NULL,
    duration_ms int,
    artist_uri varchar(max),
    album_uri varchar(max)
    
)

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('preprod.PlaylistTrack') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE preprod.PlaylistTrack
END
CREATE TABLE [preprod].[PlaylistTrack](
    --id int IDENTITY PRIMARY KEY,
    pid int NOT NULL,
    track_uri varchar(max) NOT NULL,
    CONSTRAINT FK_pid FOREIGN KEY (pid) REFERENCES [preprod].[Playlist] (pid)
    --,CONSTRAINT FK_track_uri FOREIGN KEY (track_uri) REFERENCES [preprod].[Track] (track_uri)
    ON DELETE CASCADE
)


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('preprod.Album') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE preprod.Album
END
CREATE TABLE [preprod].[Album] (
    album_name  varchar(max),
    album_uri   varchar(max)
)

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('preprod.TrackAlbum') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE preprod.TrackAlbum
END
CREATE TABLE [preprod].[TrackAlbum] (
    album_uri   varchar(max),
    track_uri   VARCHAR(max)
)

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('preprod.Artist') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE preprod.Artist
END
CREATE TABLE [preprod].[Artist] (
    artist_name  varchar(max),
    artist_uri   varchar(max)
)

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('preprod.TrackArtist') AND sysstat & 0xf = 3)
BEGIN
    DROP TABLE preprod.TrackArtist
END
CREATE TABLE [preprod].[TrackArtist] (
    artist_uri   varchar(max),
    track_uri   VARCHAR(max)
)