from flask import Blueprint, request, jsonify, make_response
import json
from src import db

gyms = Blueprint('gyms', __name__)


# obtaining gym info
@gyms.route('/gyms/<username>', methods=['GET'])
def get_gym_info(username):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of members
    cursor.execute('''
        SELECT * FROM gym WHERE username = "{}";
    '''.format(username))

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

    response = make_response(json_data)

    return response


# obtaining gym info
@gyms.route('/gymschedule/<username>', methods=['GET'])
def get_gym_schedule(username):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of members
    cursor.execute('''
        SELECT * FROM gymSchedule WHERE gymUsername = "{}";
    '''.format(username))

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

    response = make_response(json.dumps(json_data, default=str))

    return response


# get all gym events
@gyms.route('/gymevents/<username>', methods=['GET'])
def get_gym_events(username):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of members
    cursor.execute('SELECT * '
                   'FROM event '
                   'WHERE hostGym = "{}";'.format(username))

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


# create a new gym event
@gyms.route('/newevent/<username>', methods=['POST', 'GET'])
def create_event(username):

    # add details about session
    event_name = request.form['name']
    description = request.form['description']
    address = request.form['address']
    city = request.form['city']
    state = request.form['state']
    zipCode = request.form['zip']
    startTime = request.form['startTime']
    endTime = request.form['endTime']

    for letter in ['T', 'Z']:
        startTime = startTime.replace(letter, ' ')
        endTime = endTime.replace(letter, ' ')

    supervisorTrainer = request.form['trainer']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO event
            (description, name, streetAddress, city, state, zipCode, startTime, endTime, hostGym, supervisorTrainer)
        VALUES
            ("{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}")
    '''.format(description, event_name, address, city, state, zipCode, startTime, endTime, username, supervisorTrainer)
    cursor.execute(query)
    cursor.connection.commit()

    return get_gym_events(username)

@gyms.route('/updatecapacity/<username>', methods=['PUT'])
def update_capacity(username):

    # add details about session
    current_capacity = request.form['Current Capacity']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        UPDATE gym SET capacity = "{}" WHERE username = "{}"; 
    '''.format(current_capacity, username)
    cursor.execute(query)
    cursor.connection.commit()

    return get_gym_info(username)