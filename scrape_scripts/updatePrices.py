# -*- coding: utf-8 -*-
import pandas as pd
import uuid
from sqlalchemy import create_engine
import numpy as np
from datetime import datetime

from os import getenv
import sys
pg_password=getenv("PGPASSWORD")
pg_host=getenv("PGHOST")
pg_db=getenv("PGDB")

if pg_db==None or pg_host==None or pg_password==None:
    pg_host = sys.argv[1]
    pg_db = sys.argv[2]
    pg_password = sys.argv[3]
def clean_discount(s):
    if str(s)!='False':
        try:
            return int(str(s).split("%")[0])
        except:
            return 0
    return 0
def clean_price(s):
    try:
        return float(str(s).replace(',','').split(" ")[0])
    except:
        return -1

def clean_stars(s):
    if str(s)!='nan':
        try:
            return float(str(s).split(" ")[0])
        except:
            return -1
    return -1



def update_price(data):
    engine = create_engine('postgresql://postgres:'+pg_password+'@'+pg_host+'/'+pg_db)
    prices=data[['discount','href','id','price','stars','timestamp']]
    prices=prices.drop_duplicates(subset=['id'])
    print(prices.shape)
    prices.timestamp=pd.to_datetime(prices.timestamp)
    prices.discount=prices.discount.apply(lambda s : clean_discount(s))
    prices.price=prices.price.apply(lambda s :  clean_price(s))
    prices.stars=prices.stars.apply(lambda s : clean_stars(s))
    prices.rename(columns={"id": "prod_id"},inplace=True)
    prices['id']=[uuid.uuid4() for i in range(prices.shape[0])]
    prices=prices[(prices['price']!=-1) & (prices['timestamp'].notna()) & (prices['price']!=-0)]
        #split datafram into chunks of 10000
    list_data = np.array_split(prices, 50)
    for chunk in list_data:
        chunk.to_sql('prices', engine,if_exists='append',index=False,method='multi')

data=pd.read_csv('/home/ec2-user/scrape_scripts/data/jumia_data'+str(datetime.today().strftime('%Y-%m-%d'))+'d.csv',error_bad_lines=False)
if 'href' in data:
    update_price(data)
else:
    data['href']=np.NaN
    update_price(data)



print("prices table updated successfully ✅")









# #delete no longer tracked products


