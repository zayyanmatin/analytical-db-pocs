SELECT event_uid, group_uid, proposition, territory, concurrent_plays
FROM (SELECT event_uid,
             group_uid,
             proposition,
             territory,
             concurrent_plays,
             ROW_NUMBER() OVER (ORDER BY concurrent_plays DESC ) AS seqnum
      FROM (SELECT event_uid, group_uid, MAX(concurrent_plays) AS concurrent_plays, proposition, territory
            FROM linear_events
                     JOIN top_level_filters ON linear_events.filter_id = top_level_filters.id
            WHERE timestamp >= '2024-02-01 00:00:00.000000'
              AND timestamp < '2024-02-05 00:00:00.000000'
            GROUP BY event_uid, group_uid, proposition, territory
            ORDER BY concurrent_plays DESC) a) b
WHERE b.seqnum <= 10
ORDER BY concurrent_plays DESC
LIMIT 50 OFFSET 0;