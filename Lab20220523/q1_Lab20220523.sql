/*
    show what is the most common playlist's name; order results by cnt in descendent order
    query [preprod] schema
*/

USE LAB20220523
GO

SELECT 
    CASE 
    WHEN [name] is NULL or [name] = '' THEN 'DEFAULT'
    else [name]
    END as [name], COUNT(1) cnt
FROM [preprod].Playlist
GROUP BY [name]
ORDER BY cnt desc
