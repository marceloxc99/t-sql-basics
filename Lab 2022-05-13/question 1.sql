/*
 * File publications_202205131300 has a field named "Type"
 * "Type" values contain Publication format info; some of these formats are captured in Table dev.Format 
 * What is the frequency of a Format in publications_202205131300 data
 * A Format that don't appear in stage.Publications data must return a zero count 
*/

--USE PubCatalog
GO

DECLARE @expectedCount as INT
DECLARE @actualCount as INT

SET @expectedCount = 15
SET @actualCount = 0

SET @actualCount = (
    SELECT COUNT(1)
    FROM
    (
        SELECT [Name], Cnt
        FROM
        (
            SELECT  df.Name,
                    COUNT(sp.Type) AS Cnt
            FROM dev.Format df
            LEFT JOIN stage.publications sp
            ON sp.Type LIKE '%'+df.Name+'%'
            GROUP BY df.Name
        ) actual
        INTERSECT
        (
            SELECT 			'Book',						152
			UNION SELECT	'Video',					10
			UNION SELECT	'Audiobook',				8
			UNION SELECT	'Music',					5
			UNION SELECT	'Journal, magazine',		1
			UNION SELECT	'Map',						0
			UNION SELECT	'Archival Material',		0
			UNION SELECT	'Article',					0
			UNION SELECT	'DEFAULT',					0
			UNION SELECT	'Encyclopedia article',		0
			UNION SELECT	'Game',						0
			UNION SELECT	'Interactive multimedia',	0
			UNION SELECT	'Musical score',			0
			UNION SELECT	'Newspaper',				0
			UNION SELECT	'Sound recording',			0
        )
    ) result
)

IF @actualCount = @expectedCount
BEGIN
    PRINT CONCAT('@actualCount=', @actualCount, ' matches @expectedCount=', @expectedCount)
END
ELSE
BEGIN      
    RAISERROR (N'@actualCount=%d does not martch @expectedCount=%d', -- Message text.  
            16, -- Severity,  Exception Message
            1, -- State,  
            @actualCount, -- First argument.  
            @expectedCount -- Second argument
        );
END 