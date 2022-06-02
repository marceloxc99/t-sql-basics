/*
Script 2: Show the frequency of original_language values
*/

USE Lab20220526
GO

SELECT tr.original_language, COUNT(original_language) Count
FROM (
    SELECT distinct id, original_language
    FROM [raw].top_rated
) tr
GROUP BY tr.original_language
ORDER BY Count DESC