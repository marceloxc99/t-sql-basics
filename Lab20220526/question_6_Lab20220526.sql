/*
Script 6: Count how many titles fall in the following buckets
            1 release_date between 1900 and 1950
            2 release_date between 1951 and 1970
            3 release_date between 1971 and 1980
            4 release_date between 1981 and 2000
            5 release_date between 2001 and 2010
            6 release_date between 2011 and current year
*/

USE Lab20220526
GO

-- SELECT distinct tr.title
-- from [raw].top_rated tr
-- where tr.release_date BETWEEN '2001' and '20101231'

-- SELECT count(distinct tr.title) as Count
-- from [raw].top_rated tr
-- where tr.release_date BETWEEN '2001' and '20101231'

SELECT t.range as [bin], count(distinct id) as [Count]
FROM (
  SELECT id
        ,CASE  
            WHEN release_date between '19000101' and '19501231' then '1900 <= release_date <=1950'
            WHEN release_date between '19510101' and '19701231' then '1951 <= release_date <=1970'
            WHEN release_date between '19710101' and '19801231' then '1971 <= release_date <=1980'
            WHEN release_date between '19810101' and '20001231' then '1981 <= release_date <=2000'
            WHEN release_date between '20010101' and '20101231' then '2001 <= release_date <=2010'
            ELSE '2011 <= release_date <=2022' 
        END as range
  FROM [raw].top_rated) t
GROUP BY t.range
ORDER BY bin