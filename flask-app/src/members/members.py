from flask import Blueprint, request, jsonify, make_response
import json
from src import db

members = Blueprint('members', __name__)


@members.route('/info/<username>', methods=['GET'])
def get_info(username):
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of members
    cursor.execute('SELECT * '
                   'FROM member m '
                   'WHERE m.username = "{}";'.format(username))

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

# Get member's favorite exercises
@members.route('/memberinterests/<username>', methods=['GET'])
def get_fav_exercises(username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * '
                   'FROM memberGymInterests mgi JOIN exercises e ON e.name = mgi.exerciseName '
                   'WHERE mgi.memberUsername = "{}"'.format(username))

    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# Get all the members from the database in the same city (limit 6)
@members.route('/nearbymembers/<username>', methods=['GET'])
def get_members(username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT firstName, lastName, profilePic '
                   'FROM member m '
                   'WHERE (SELECT m.city '
                   '       FROM member m '
                   '       WHERE m.username = "{}") = m.city '
                   'LIMIT 6;'.format(username))

    column_headers = [x[0] for x in cursor.description]
    json_data = []

    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# Get all the gyms from the database in the same city (limit 4)
@members.route('/nearbygyms/<username>', methods=['GET'])
def get_gyms(username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT g.name, g.streetAddress, g.city, g.state, g.phoneNum, g.profilePic '
                   'FROM gym g JOIN member m '
                   'WHERE (SELECT m.city '
                   '       FROM member m '
                   '       WHERE m.username = "{}") = g.city '
                   'LIMIT 4;'.format(username))

    column_headers = [x[0] for x in cursor.description]
    json_data = []

    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# get their own workout
@members.route('/getmemberworkout/<username>', methods=['GET'])
def get_member_workout(username):
    cursor = db.get_db().cursor()
    query = '''
        SELECT wr.name, wc.exerciseName, wc.weight, wc.sets, wc.reps, wc.repTime
        FROM workoutContains wc JOIN workoutRoutine wr ON wc.workoutName = wr.name
                                JOIN memberWorkoutCreated mwc on mwc.workoutName = wr.name
        WHERE mwc.memberUsername = "{}" 
    '''.format(username)
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]

    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# create their own workout
@members.route('/createworkout/<username>', methods=['POST'])
def create_workout(username):
    workout_name = request.form['workoutName']

    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO workoutRoutine (name)
        VALUES ("{}");
        INSERT INTO memberWorkoutCreated (workoutName, memberUsername)
        VALUES ("{}", "{}")
    '''.format(workout_name, workout_name, username)
    cursor.execute(query)
    cursor.connection.commit()

    return get_member_workout()

@members.route('/addexercise/<username>/<workout_name>', methods=['POST'])
def add_exercise(username, workout_name):
    # add exercise
    exercise_name = request.form['Exercise Name']
    weight = request.form['Weight']
    sets = request.form['Sets']
    reps = request.form['Reps']
    repTime = request.form['Time']
    restTime = request.form['Rest Time']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO workoutContains (workoutName, exerciseName, weight, sets, reps, repTime, restTime)
        VALUES ("{workout}", "{exercise}", "{weight}", "{sets}",
               "{reps}", "{repTime}", "{restTime}")
    '''.format(workout_name, exercise_name, weight, sets, reps, repTime, restTime)
    cursor.execute(query)
    cursor.connection.commit()

    return get_member_workout(username)



# add an exercise interest
@members.route('/addinterest/<username>', methods=['POST'])
def add_interest(username):

    # add exercise
    exercise_name = request.form['Exercise']
    pr = request.form['PR']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO memberGymInterests (memberUsername, exerciseName, pr) 
        VALUES ("{}", "{}", "{}"); 
    '''.format(username, exercise_name, pr)
    cursor.execute(query)
    cursor.connection.commit()

    return get_fav_exercises
