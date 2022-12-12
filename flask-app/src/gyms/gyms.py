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
        SELECT *, currentCapacity / capacity AS percentCapacity 
        FROM gym g JOIN gymSchedule gs ON g.username = gs.gymUsername
        WHERE g.username = "{}";
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
    # eventPic = request.form['eventPic']
    startTime = request.form['startTime']
    endTime = request.form['endTime']
    supervisorTrainer = request.form['trainer']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO event
            (eventID, description, name, streetAddress, city, state, zipCode, startTime, endTime, hostGym, supervisorTrainer)
        VALUES
            ((SELECT max(eventID) + 1 FROM event), "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}")
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