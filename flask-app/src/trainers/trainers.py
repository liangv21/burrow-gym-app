from flask import Blueprint, request, jsonify, make_response
import json
from src import db

trainers = Blueprint('trainers', __name__)


@trainers.route('/gettrainers', methods=['GET'])
def get_trainers():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of members
    cursor.execute('SELECT firstName, lastName '
                   'FROM trainer t;')

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


@trainers.route('/gettrainerworkout/<username>', methods=['GET'])
def get_trainer_workout(username):
    cursor = db.get_db().cursor()
    query = '''
        SELECT wr.name, wc.exerciseName, wc.weight, wc.sets, wc.reps, wc.repTime
        FROM workoutContains wc JOIN workoutRoutine wr ON wc.workoutName = wr.name
                                JOIN trainerWorkoutCreated twc on twc.workoutName = wr.name
        WHERE twc.memberUsername = "{}"
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


# create a training session event
@trainers.route('/createtraining/<username>', methods=['POST'])
def create_training(username):
    # add details about session
    session_name = request.form['Name']
    day_of_session = request.form['Day']
    start_time = request.form['Start Time']
    end_time = request.form['End Time']
    cost = request.form['Cost']
    description = request.form['Description']
    street_address = request.form['Street Address']
    city = request.form['City']
    state = request.form['State']
    zipcode = request.form['Zip Code']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO trainingSession
            (sessionID, description, name, cost, streetAddress, city, state, zipCode, calendarDate, startTime, endTime, trainerUsername)
        VALUES
            ((SELECT max(sessionID) FROM trainingSession) + 1, "{desc}", "{name}", "{cost}", "{add}", "{city}", "{state}", "{zip}", "{day}", "{start}", "{end}", "{user}")
    '''.format(description, session_name, cost, street_address, city, state, zipcode,
               day_of_session, start_time, end_time, username)
    cursor.execute(query)
    cursor.connection.commit()

    return get_trainers()


# create a workout
@trainers.route('/createtrainerworkout/<username>', methods=['POST'])
def create_train_workout(username):
    # add name of workout
    workout_name = request.form['Workout Name']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO workoutRoutine (name)
        VALUES "{}";
        INSERT INTO trainer (workoutName, trainerUsername)
        VALUES "{}", "{}"
    '''.format(workout_name, workout_name, username)
    cursor.execute(query)
    cursor.connection.commit()

    return get_trainers()


@trainers.route('/addexercise/<workout_name>', methods=['POST'])
def add_exercise(workout_name):
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
        INSERT INTO workoutContains
        VALUES "{workout}", "{exercise}", "{weight}", "{sets}",
               "{reps}", "{repTime}", "{restTime}"
    '''.format(workout_name, exercise_name, weight, sets, reps, repTime, restTime)
    cursor.execute(query)
    cursor.connection.commit()

    return get_trainer_workout()
