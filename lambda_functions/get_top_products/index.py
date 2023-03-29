import json
from sqlalchemy import create_engine
import pandas as pd
import os
def lambda_handler(event, context):
    engine = create_engine('postgresql://'+os.environ['DB_USER_NAME']+":"+os.environ['DB_PASSWORD']+'@'+os.environ['DB_HOST']+'/'+os.environ['DB_NAME'])
    category=json.loads(event['body'])["category"]
    # category="Sporting Goods"
    sql="SELECT * FROM prod_ranking where category_main='"+category+"'"
    df=pd.read_sql(sql,con=engine)
    df=df.drop_duplicates(subset=['name'])
    df=df.dropna(subset=['reviewcount'])
    df=df.set_index('name')
    return {
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Authorization,Content-Type',
            'Access-Control-Allow-Method': 'GET,POST,OPTIONS',
    },
        'statusCode': 200,
        'body': json.dumps(df.to_dict(orient='index'))
            }

