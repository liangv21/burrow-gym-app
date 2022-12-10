from flask import Blueprint, request, jsonify, make_response
import json
from src import db


members = Blueprint('members', __name__)

# Get all the members from the database in the same city (limit 6)
@members.route('/nearbymembers/<username>', methods=['GET'])
def get_members(username):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of members
    cursor.execute('SELECT firstName, lastName, profilePic '
                   'FROM member m'
                   'WHERE (SELECT m.city'
                   '       FROM member m'
                   '       WHERE m.username = {}) = m.city'
                   'LIMIT 6;'.format(username))

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

# Get all the gyms from the database in the same city (limit 4)
@members.route('/nearbygyms/<username>', methods=['GET'])
def get_gyms(username):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of gyms
    cursor.execute('SELECT g.name, g.streetAddress, g.city, g.state, g.phoneNum'
                   'FROM gym g JOIN member m'
                   'WHERE (SELECT m.city'
                   '       FROM member m'
                   '       WHERE m.username = {}) = m.city'
                   'LIMIT 4;'.format(username))

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

# get their own workout
@members.route('/getworkout/<username>', methods=['GET'])
def get_workout(username):
    cursor = db.get_db().cursor()
    query = '''
        SELECT wr.name, wc.exerciseName, wc.weight, wc.sets, wc.reps, wc.repTime
        FROM workoutContains wc JOIN workoutRoutine wr ON wc.workoutName = wr.name
                                JOIN memberWorkoutCreated mwc on mwc.workoutName = wr.name
        WHERE mwc.memberUsername = {} 
    '''.format(username)
    cursor.execute(query)
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

# edit or create their own workout
@members.route('/createworkout/<username>', methods=['PUT', 'POST'])
def create_workout():
    cursor = db.get_db().cursor()
    query = '''
        SELECT p.productCode, productName, sum(quantityOrdered) as totalOrders
        FROM products p JOIN orderdetails od on p.productCode = od.productCode
        GROUP BY p.productCode, productName
        ORDER BY totalOrders DESC
        LIMIT 5;
    '''
    cursor.execute(query)
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