/*
 * File publications_202205131300 has a field named "Type"
 * A Book Audience publication can be categorized as Juvenile, Non-Juvenile
 * What is the frequency of an Audience Name in publications_202205131300 data
 * A Audience Name that don't appear in stage.Publications data must return a zero count 
*/

--USE PubCatalog
GO

DECLARE @expectedCount as INT
DECLARE @actualCount as INT

SET @expectedCount = 3 --171 Modified this since INTERSECT section does not have 171 rows
SET @actualCount = 0

SET @actualCount = (
    SELECT COUNT(1)
    FROM
    (
        SELECT [Name], Cnt
        FROM
        (
            SELECT devau.Name, COUNT(NewType) as Cnt
            FROM
            ( 
                select distinct trim(sp.Publication) as Publication, 
                        --trim([author]) as Author, 
                        --trim(title) as Title, 
                        --trim(language) as Language, 
                        --trim(type) as type, 
                        Trim(dateEdition) as dateEdition, 
                        IIF(sp.TYPE LIKE '%'+deva.Name+'%', deva.Name, 'Non-Juvenile') AS NewType
                from stage.Publications sp
                LEFT JOIN dev.Audience deva
                ON sp.Type LIKE '%'+deva.Name+'%'
                where Publication is not null
            ) new
            RIGHT JOIN dev.Audience devau
            ON new.NewType LIKE devau.Name
            GROUP BY devau.Name
        ) actual
        INTERSECT
        (
            SELECT 'DEFAULT',	              0
            UNION SELECT 'Non-Juvenile',	139
            UNION SELECT 'Juvenile',	     13
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