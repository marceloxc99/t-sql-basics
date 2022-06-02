/*
Script 1: What is the frequency of each title?
*/

--note: frequency of each movie comes from genre_id column. There is a diffrent row for each genre where movie belongs to

USE Lab20220526
GO

SELECT top_rated.id, top_rated.title, count(title) Count
FROM [raw].top_rated
GROUP BY title, id
ORDER BY Count DESC