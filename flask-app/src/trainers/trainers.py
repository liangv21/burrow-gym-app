from flask import Blueprint, request, jsonify, make_response
import json
from src import db


trainers = Blueprint('trainers', __name__)

# Get all the trainers from the database
@trainers.route('/trainers', methods=['GET'])
def get_trainers():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('select firstName, lastName from trainer')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers.
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# create a workout routine
@trainers.route('/createworkout', methods=['POST'])
def create_workout():
    workout_name = request.form['Name']

    # add first exercise
    exercise1 = request.form['Exercise 1']
    set1 = request.form['Sets for Exercise 1']
    rep1 = request.form['Reps for Exercise 1']
    rep_time1 = request.form['Rep Time for Exercise 1']
    rest_time1 = request.form['Rest Time for Exercise 1']

    query = '''
        INSERT INTO 
    '''