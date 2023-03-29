# -*- coding: utf-8 -*-
import pandas as pd
import uuid
from sqlalchemy import create_engine
import numpy as np
from datetime import datetime
from os import getenv
import sys
pg_host=getenv("PGHOST")
pg_db=getenv("PGDB")
pg_password=getenv("PGPASSWORD")


if pg_db==None or pg_host==None or pg_password==None:
    pg_host = sys.argv[1]
    pg_db = sys.argv[2]
    pg_password = sys.argv[3]



def clean_review(s):
    try:
        return str(s).split("(")[1].split(")")[0]
    except:
        return np.NaN
#update products table
data=pd.read_csv('/home/ec2-user/scrape_scripts/data/jumia_data'+str(datetime.today().strftime('%Y-%m-%d'))+'d.csv',error_bad_lines=False)

products=data.drop(['price','discount'],axis=1).drop_duplicates('id')
products.reviewcount=products.reviewcount.apply(lambda s: clean_review(s))
products['category_main']=products['category'].apply(lambda s: str(s).split('/')[0])
products['reviewcount']=pd.to_numeric(products['reviewcount'], errors='coerce')


engine = create_engine('postgresql://postgres:'+pg_password+'@'+pg_host+'/'+pg_db)
#drop old products table
sql = 'DROP TABLE IF EXISTS products;'
result = engine.execute(sql)
list_data = np.array_split(products, 50)
for chunk in list_data:
    chunk.to_sql('products', engine,if_exists='append',index=False)
    
print('products table updated successfully ✅')