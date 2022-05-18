/*
 * File publications_202205131300 has a field named "Type"
 * A Book Type publication can be categorized as Fiction, Non-Fiction, Biography
 * "Type" values contain Content information; some of these Content are captured in Table dev.Content 
 * What is the frequency of an Content Name in publications_202205131300 data
 * A Content Name that don't appear in stage.Publications data must return a zero count 
*/

--USE PubCatalog
GO

DECLARE @expectedCount as INT
DECLARE @actualCount as INT

SET @expectedCount = 4 --3 Modified this since INTERSECT section does not have 3 rows
SET @actualCount = 152

SET @actualCount = (
    SELECT COUNT(1)
    FROM
    (
        SELECT [Name], Cnt
        FROM
        (
            SELECT devco.Name, COUNT(NewType) as Cnt
            FROM
            ( 
                select distinct trim(sp.Publication) as Publication, 
                        --trim([author]) as Author, 
                        trim(title) as Title, 
                        --trim(language) as Language, 
                        --trim(type) as type, 
                        Trim(dateEdition) as dateEdition, 
                        IIF(sp.TYPE LIKE '%'+devc.Name+'%', devc.Name, 'Non-Fiction') AS NewType
                from stage.Publications sp
                LEFT JOIN dev.Content devc
                ON sp.Type LIKE '%'+devc.Name+'%'
                where Publication is not null and Type != 'Fiction'
            ) new
            RIGHT JOIN dev.Content devco
            ON new.NewType LIKE devco.Name
            GROUP BY devco.Name
        ) actual
        INTERSECT
        (
            SELECT 'DEFAULT' as [Name], 0 as Cnt
            UNION SELECT 'Fiction',	     21
            UNION SELECT 'Non-Fiction',	128
            UNION SELECT 'Biography',	  3
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