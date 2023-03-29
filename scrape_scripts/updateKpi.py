# -*- coding: utf-8 -*-
import pandas as pd
from sqlalchemy import create_engine
from os import getenv
import sys
pg_password=getenv("PGPASSWORD")
pg_host=getenv("PGHOST")
pg_db=getenv("PGDB")

if pg_db==None or pg_host==None or pg_password==None:
    pg_host = sys.argv[1]
    pg_db = sys.argv[2]
    pg_password = sys.argv[3]
engine = create_engine('postgresql://postgres:'+pg_password+'@'+pg_host+'/'+pg_db)



sql = 'DROP TABLE IF EXISTS kpi;'
result = engine.execute(sql)
#recreate new prod_ranking
sql="create table kpi as (select count(*) as metric_value, 'prod_number' as metric_name from products union select sum(is_equal) as metric_value, 'change_week' as metric_name from (SELECT  (CASE WHEN avg(price) = (array_agg(price ORDER BY timestamp DESC))[1] THEN 0 ELSE 1 END) AS is_equal ,prod_id FROM prices WHERE timestamp::date between SYMMETRIC NOW()::date and  (now() - INTERVAL '7 DAYS')::date group by prod_id) as week_prices union select sum(is_equal) as metric_value, 'change_month' as metric_bame from (SELECT  (CASE WHEN avg(price) = (array_agg(price ORDER BY timestamp DESC))[1] THEN 0 ELSE 1 END) AS is_equal ,prod_id FROM prices WHERE timestamp::date between SYMMETRIC NOW()::date and  (now() - INTERVAL '1 MONTH')::date group by prod_id) as month_prices);"
result = engine.execute(sql)

print("Kpi table updated successfully ✅")
