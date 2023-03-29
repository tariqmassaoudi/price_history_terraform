import json
from sqlalchemy import create_engine
import pandas as pd
import os
def lambda_handler(event, context):
    engine = create_engine('postgresql://'+os.environ['DB_USER_NAME']+":"+os.environ['DB_PASSWORD']+'@'+os.environ['DB_HOST']+'/'+os.environ['DB_NAME'])
    df = pd.read_sql("select * from kpi",con=engine)
    df.set_index('metric_name',inplace=True)
    df_dict=df.to_dict(orient='index')
    # TODO implement
    return {
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Authorization,Content-Type',
            'Access-Control-Allow-Method': 'GET,POST,OPTIONS',
    },
        'statusCode': 200,
        'body': json.dumps(df_dict)
    }
