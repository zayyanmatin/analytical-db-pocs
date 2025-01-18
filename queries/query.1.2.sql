SELECT timestamp,
             territory,
             MAX(concurrent_plays) AS cp
      FROM hourly_metrics mrd
               JOIN filters ON
          mrd.filter_id = filters.id
         WHERE  timestamp > '2024-02-01 00:00:00.000000'
         AND  timestamp < '2024-02-25 00:00:00.000000'
      GROUP BY timestamp,
               territory

-- Postgres 627ms 
-- Starrocka 80ms 