/*
    show the top ten of most common playlist's name; this later can be top 12, top 100
    Query [preprod] schema
*/

USE Lab20220523
GO

declare @top_number INT
set @top_number = 10
declare @SQLText nvarchar(max)
declare @expression1 nvarchar(max)
set @expression1 = N'%' --to look for specific playlist's name
--mostrar el top 10, 20, etc de track name que comienza por la letra A (esto podria ser R, S, T)
set @SQLText = CONCAT(N'select top ', @top_number, ' name, count(1) cnt from preprod.Playlist where name like @expression group by name order by cnt desc')
execute sp_executesql @SQLText, N'@expression NVARCHAR(max)', @expression=@expression1
go