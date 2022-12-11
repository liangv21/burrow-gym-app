from flask import Blueprint, request, jsonify, make_response
import json
from src import db

gyms = Blueprint('gyms', __name__)

# get all data about the gym
@gyms.route('/gyms/<username>', methods=['GET'])
def get_gym_info(username):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of members
    cursor.execute('SELECT name, streetAddress, city, state, zipCode, profilePic, currentCapacity / capacity '
                   'FROM gym '
                   'WHERE username = "{}"; '
                   'SELECT * '
                   'FROM gymSchedule '
                   'WHERE gymUsername = "{}";'.format(username, username))

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
