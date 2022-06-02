/*
Script 5: Find all occurrences of records which title is equal to original_title; answer must have the following format
*/

USE Lab20220526
GO

SELECT distinct tr.title, tr.original_title,
        CASE
            WHEN tr.title like tr.original_title COLLATE Latin1_General_CS_AS 
            THEN 1
            ELSE 0
        END as title_equals_original_title
FROM [raw].top_rated tr
WHERE tr.title like tr.original_title 
ORDER BY title_equals_original_title