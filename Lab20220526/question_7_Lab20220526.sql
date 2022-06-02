/*
Script 7: how many movies fall in each genre, present data ordered by count in descendent order
*/

USE Lab20220526
GO

SELECT rg.name as Genre, count(tr.genre_id) as [Count]
from [raw].top_rated tr
RIGHT JOIN [raw].genres rg
ON tr.genre_id = rg.id
GROUP BY tr.genre_id, rg.name
ORDER BY [Count] DESC
