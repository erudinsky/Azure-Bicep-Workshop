import os
from pickle import TRUE
import psycopg2

conn = psycopg2.connect(host=os.environ['POSTGRES_HOST'],
                        port=os.environ['POSTGRES_PORT'],
                        database=os.environ['POSTGRES_NAME'],
                        user=os.environ['POSTGRES_USER'],
                        password=os.environ['POSTGRES_PASSWORD'],
                        sslmode=os.environ['POSTGRES_SSLMODE'])

cur = conn.cursor()

cur.execute('DROP TABLE IF EXISTS books;')
cur.execute('CREATE TABLE books (id serial PRIMARY KEY,'
                                 'title varchar (150) NOT NULL,'
                                 'author varchar (50) NOT NULL,'
                                 'pages_num integer NOT NULL,'
                                 'read bool NOT NULL,'
                                 'date_added date DEFAULT CURRENT_TIMESTAMP);'
                                 )

cur.execute('INSERT INTO books (title, author, pages_num, read)'
            'VALUES (%s, %s, %s, %s)',
            ('The Phoenix Projecy',
             'Gene Kim, Kevin Behr and George Spafford',
             431,
             True)
            )


cur.execute('INSERT INTO books (title, author, pages_num, read)'
            'VALUES (%s, %s, %s, %s)',
            ('Coders',
             'Clive Thompson',
             436,
             False)
            )

conn.commit()

cur.close()
conn.close()