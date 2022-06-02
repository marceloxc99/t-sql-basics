/*
Script 3: Show me all title, original_title that are classified as video; answer must have the following format
*/

USE Lab20220526
GO

SELECT tr.title, tr.original_title, tr.video
FROM [raw].top_rated tr
WHERE tr.video = 'true' or tr.video like '%true%'

