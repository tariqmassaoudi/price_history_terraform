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


#drop old prod_ranking


sql = 'DROP TABLE IF EXISTS prod_ranking;'
result = engine.execute(sql)

#recreate new prod_ranking
sql="create table prod_ranking as( select REPLACE(prd.category_main, '&', '' ) as category_main,prd.reviewcount, prd.href, prd.name,prd.img_url , calcl.* from (select prod_id ,max(stars) as stars_max,avg(price) as avg_price ,max(price) as max_price ,min(price) as min_price,(array_agg(price ORDER BY timestamp DESC))[1] AS latest_price ,((avg(price) - (array_agg(price ORDER BY timestamp DESC))[1])/avg(price)) *100 as dist_from_average  from prices group by prod_id) as calcl inner join products as prd on calcl.prod_id=prd.id where dist_from_average>10 and stars_max <> -1 order by category_main desc ,prd.reviewcount desc ,  dist_from_average desc);"
result = engine.execute(sql)

print("prod ranking updated successfully ✅" )
