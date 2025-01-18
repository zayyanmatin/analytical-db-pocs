SELECT DATE_TRUNC('hour',
                  timestamp) AS hour,
       territory,
       MAX(cp)               AS cp
FROM (SELECT timestamp,
             territory,
             SUM(concurrent_plays) AS cp
      FROM metrics mrd
               JOIN filters ON
          mrd.filter_id = filters.id
         WHERE  timestamp > '2024-02-01 00:00:00.000000'
         AND  timestamp < '2024-02-03 00:00:00.000000'
      GROUP BY timestamp,
               territory) a
GROUP BY hour,
         territory

-- Postgres 3200ms 
-- Starrocka 175ms 
-- Pinot 110ms (Denormalised Query)