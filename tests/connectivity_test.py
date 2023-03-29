# -*- coding: utf-8 -*-
from os import getenv
from sqlalchemy import create_engine
from sqlalchemy.exc import OperationalError
import sys


pg_host = sys.argv[1]
pg_db = sys.argv[2]
pg_password = sys.argv[3]

# Build the database URI
db_uri = 'postgresql://postgres:%s@%s/%s' % (pg_password, pg_host, pg_db)

# Create the database engine
engine = create_engine(db_uri)

# Try to connect to the database
try:
    with engine.connect() as conn:
        print "Connectivity test Passed Successfully ✅"
except OperationalError as e:
    print "Failed to connect ❌: %s" % e
