# analytical-db-pocs

Analysis  on potential real-time OLAP DB alternatives
## Context

### Use Case :bulb:
The use case is to provide real time analytics to clients of our data. Whilst a traditional relational store such as Postgres fulfills most of our requirements, response times can be sub-optimal. 

A brief look at [Clickbench](https://benchmark.clickhouse.com/) can show how much Postgres falls behind in performance for highly analytical queries.


In addition to better analytical performance, we would look to choose databases that would also support:

- Upserts (For historical backfill of data)
- Normalization (not a must, but would help data storage be efficient)
- Horizontal Scalability
- High Availability
- Backup & Recovery
- Support

### So Why Real Time OLAP?
 A new age of databases are out there geared towards real time analytics and this project serves to provide a benchmark and report on those, namely Starrocks, Clickhouse and Pinot. These databases leverage a Massive Parallel Processing architecture, whereby compute can be split across many nodes and communicate with each other to speed up query and execution times. Another feature is they use columnar stores instead of rows. This way only columns that are queried will be processed as opposed to entire records. This largely favours analytical workloads, where an entire row is not usually required, meaning there is less to process and better performance.

 ## Database Overviews
 > [!NOTE]
 > [Overviews of each database and on how we POC'd can be found here](./docs)

### Data Generation :gear:
Data ranging from ```2024/02/01 00:00``` to ```2024/03/01 00:00``` is generated in each DB to mock the content within our minute and hourly tables.

Table are generated the same way across the databases with sizes:
```
metrics - 12,960,000  rows

hourly_metrics - 216, 000 rows

linear_events - 14,034,599   rows

hourly_metrics - 326,000 rows
```



## Benchmark Results :chart_with_upwards_trend:

[Here are the list of queries used to benchmark performance](./queries)


| Database Type 	| Deployment Details                                         	| Approach 	| Approach Specifics                                                                       	| Upserts 	| Joins 	| Q1.0 (metrics, 3 days) 	| Q1.1 (metrics, 5 days) 	| Q1.2 (hourly_metrics, 25 days) 	| Q2.0 (linear_events, 3 days) 	| Q2.1 (linear_events, 5 days) 	| Q2.2 (hourly_linear_events, 25 days) 	| Q3.0 (metrics, 3 days) 	| Q3.1 (metrics, 5 days) 	| Q3.2 (hourly_metrics, 25 days) 	|
|---------------	|------------------------------------------------------------	|----------	|------------------------------------------------------------------------------------------	|---------	|-------	|------------------------	|------------------------	|--------------------------------	|------------------------------	|------------------------------	|--------------------------------------	|------------------------	|------------------------	|--------------------------------	|
| Postgres      	| CloudSQL, 16vCPU, 52Gi Mem, 1.5 Ti SSD                     	| 1        	| Generated data; Schema                                                          	|    ✅    	|   ✅   	| 3200ms                 	| 6758ms                 	| 670ms                          	| 4660ms                       	| 2600ms                       	| 905ms                                	| 3420ms                 	| 8270ms                 	| 760ms                          	|
| Starrocks     	| K8's Operator:1 BE Node: 4vCPU, 16Gi Mem, 200Gi SSD        	| 1        	| Generated data; Schema; Using Colocation groups for joins with one backend node 	|    ✅    	|   ✅   	| 175ms                  	| 264ms                  	| 77ms                           	| 240ms                        	| 330ms                        	| 135ms                                	| 174ms                  	| 312ms                  	| 95ms                           	|
| Pinot         	| K8's Helm Chart: 1 Server Node: 4vCPU, 16Gi Mem, 200Gi SSD 	| 1        	| Generated data; Schema; Denormalised                                            	|    ⁉️    	|   ⁉️   	| 80ms                   	| 115ms                  	| 35ms                           	|                          	|                              	|                                      	| 110ms                  	| 195ms                  	| 37ms                           	|
| Clickhouse    	|                                                            	|          	|                                                                                          	|    ⁉️    	|   ⁉️   	|                        	|                        	|                                	|                              	|                              	|                                      	|                        	|                        	|                                	|
