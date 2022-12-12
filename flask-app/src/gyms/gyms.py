from flask import Blueprint, request, jsonify, make_response
import json
import pandas as pd
from src import db

gyms = Blueprint('gyms', __name__)

# get all data about the gym
# attempted solution 1: using json_dumps (1)
@gyms.route('/gyms/<username>', methods=['GET'])
def get_gym_info_attempt1(username):
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
        json_data.append(json.dumps(dict(zip(column_headers, row))), indent=4, sort_keys=True, default=str)

    return jsonify(json_data)

# attempted solution 2: using pd dataframe & to_json
@gyms.route('/gyms2/<username>', methods=['GET'])
def get_gym_info_attempt2(username):
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

    # initialize empty df with appropriate column headers
    df_gym = pd.DataFrame(columns=column_headers)

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers.
    for row in theData:
        df_gym = df_gym.append(dict(zip(column_headers, row)), ignore_index=True)

    results = df_gym.to_json(orient='records')
    parsed = json.loads(results)

    return json.dumps(parsed, indent=4)


# attempted solution 3: using json_dumps & make_response (2)
@gyms.route('/gyms3/<username>', methods=['GET'])
def get_gym_info_attempt3(username):
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
@gyms.route('/newevent/<username>', methods=['POST'])
def create_event(username):

    # add details about session
    event_name = request.form['Event Name']
    description = request.form['Description']
    address = request.form['Street Address']
    city = request.form['City']
    state = request.form['State']
    zipCode = request.form['Zip Code']
    startTime = request.form['Start Time']
    endTime = request.form['End Time']
    supervisorTrainer = request.form['Trainer']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO event
            (eventID, description, name, streetAddress, city, state, zipCode, startTime, endTime, hostGym, supervisorTrainer)
        VALUES
            ((SELECT max(eventID) FROM event) + 1, "{desc}", "{name}", "{add}", "{city}", "{state}", "{zipCode}", "{startTime}", "{endTime}", "{host}", "{trainer}")
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

    return get_gym_info_attempt1(username)