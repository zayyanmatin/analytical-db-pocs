SELECT timestamp,
       CASE
           WHEN SUM(concurrent_plays) = 0 THEN NULL
           ELSE
               SUM(average_bitrate * concurrent_plays) / SUM(concurrent_plays)
           END
           AS average_bitrate,
       proposition
FROM metrics
         JOIN
     filters
     ON
         metrics.filter_id = filters.id
WHERE timestamp >= '2024-02-01 00:00:00.000000'
  AND timestamp < '2024-02-05 00:00:00.000000'
GROUP BY timestamp,
         proposition;
