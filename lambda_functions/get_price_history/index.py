import json
from sqlalchemy import create_engine
import pandas as pd
import os
def lambda_handler(event, context):

    engine = create_engine('postgresql://'+os.environ['DB_USER_NAME']+":"+os.environ['DB_PASSWORD']+'@'+os.environ['DB_HOST']+'/'+os.environ['DB_NAME'])
    try:
        product_id=json.loads(event['body'])["prod_id"]
        sql="SELECT * FROM prices where prod_id='"+product_id+"'"
    except:
        href_full=json.loads(event['body'])["href"]
        if href_full.find("www")>0:
            href=json.loads(event['body'])["href"].split("https://www.jumia.ma")[1]
            if href.find("?")>0:
                href=href.split("?")[0]
            
        else:
            href=json.loads(event['body'])["href"].split("https://jumia.ma")[1]
            if href.find("?")>0:
                href=href.split("?")[0]
        sql="SELECT * FROM prices where href='"+href+"'"

    df = pd.read_sql(sql,con=engine)
    df=df.sort_values(by='timestamp')
    df['timestamp'] = df['timestamp'].astype(str)
    return {
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Authorization,Content-Type',
            'Access-Control-Allow-Method': 'GET,POST,OPTIONS',
    },
        'statusCode': 200,
        'body': json.dumps(dict(zip(df.timestamp, df.price)))
            }
