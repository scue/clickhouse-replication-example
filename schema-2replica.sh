#!/bin/bash

set -ex
docker-compose exec -T ch-client /usr/bin/clickhouse-client --host ch-server-1 -mn < schema-2replica.sql
docker-compose exec -T ch-client /usr/bin/clickhouse-client --host ch-server-2 -mn < schema-2replica.sql
docker-compose exec -T ch-client /usr/bin/clickhouse-client --host ch-server-3 -mn < schema-2replica.sql

# 从 ch-server-1 导入
xz -v -c -d < ~/Downloads/ontime.csv.xz | docker-compose exec -T ch-client clickhouse-client --host ch-server-1 --query="INSERT INTO test.ontime FORMAT CSV"
# 从 ch-server-3 查询, 可一边导入一边查询
docker-compose exec ch-client /usr/bin/clickhouse-client --host ch-server-3 --query="select count(*) from test.ontime;"
