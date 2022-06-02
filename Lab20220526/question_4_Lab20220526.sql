/*
Script 4: Read title, original_title, genres data; answer must have the following format
*/

USE Lab20220526
GO

-- SELECT tr.title, tr.original_title, rg.name as genres
-- FROM [raw].top_rated tr
-- INNER JOIN [raw].genres rg
-- ON tr.genre_id = rg.id

-- select id, title, count(id) cnt_genres
-- from [raw].top_rated
-- GROUP by id, title
-- order by cnt_genres desc

SELECT  DISTINCT tr.title
        ,tr.original_title
        ,(SELECT STRING_AGG(newrg.name, ', ')
          FROM (
                SELECT tr.id as id, tr.genre_id as genre_id, rg.name as name
                FROM [raw].top_rated tr
                INNER JOIN [raw].genres rg
                ON tr.genre_id = rg.id
          ) newrg
          WHERE newrg.id = tr.id) as genres
FROM [raw].top_rated tr
ORDER BY tr.title