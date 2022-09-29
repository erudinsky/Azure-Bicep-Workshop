from cmath import log
from urllib import response
from flask import Flask, render_template, request, url_for, redirect, jsonify, request
from flask_cors import CORS
import psycopg2
import os

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify('I am fine!')

# enable CORS
CORS(app, resources={r'/*': {'origins': '*'}})

def get_db_connection():
    conn = psycopg2.connect(host=os.environ['POSTGRES_HOST'],
                            database=os.environ['POSTGRES_NAME'],
                            port=os.environ['POSTGRES_PORT'],
                            user=os.environ['POSTGRES_USER'],
                            password=os.environ['POSTGRES_PASSWORD'],
                            sslmode=os.environ['POSTGRES_SSLMODE'])
    return conn

@app.route('/books', methods=['GET', 'POST'])
def books():
    response_object = {'status': 'success'}
    if request.method == 'POST':
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('INSERT INTO books (title, author, pages_num, read)'
                    'VALUES (%s, %s, %s, %s)',
                    (request.get_json().get('title'), request.get_json().get('author'), request.get_json().get('pages_num'), request.get_json().get('read')))
        conn.commit()
        cur.close()
        conn.close()
        response_object['message'] = 'The new book has been added.'
    if request.method == 'GET':
        response_object = {'status': 'success'}
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT * FROM books;')
        books = cur.fetchall()
        cur.close()
        conn.close()
        response_object['message'] = 'All book has been found.'
        response_object['books'] = books
    return jsonify(response_object)

@app.route('/books/<book_id>', methods=['PUT', 'DELETE'])
def single_book(book_id):
    response_object = {'status': 'success'}
    if request.method == 'PUT':
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('UPDATE books SET title = %s, author = %s, pages_num = %s, read = %s WHERE id=%s',
                    (request.form.get('title'), request.form.get('author'), request.form.get('pages_num'), request.form.get('read'), book_id))
        conn.commit()
        cur.close()
        conn.close()
        response_object['message'] = 'The book has been updated.'
    if request.method == 'DELETE':
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('DELETE FROM books WHERE id = %s', (book_id,))
        conn.commit()
        cur.close()
        conn.close()
        response_object['message'] = 'The book has been deleted.'
    return jsonify(response_object)

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')