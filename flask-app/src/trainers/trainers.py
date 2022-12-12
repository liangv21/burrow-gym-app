from flask import Blueprint, request, jsonify, make_response
import json
from src import db

trainers = Blueprint('trainers', __name__)


# get all data from one of the trainers
@trainers.route('/info/<username>', methods=['GET'])
def get_trainer_info():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * '
                   'FROM trainer t '
                   'WHERE username = "{}"; '.format(username))
    column_headers = [x[0] for x in cursor.description]
    json_data = []

    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# Get all the gyms from the database in the same city (limit 4)
@trainers.route('/nearbygyms/<username>', methods=['GET'])
def get_trainer_gyms(username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT g.name, g.streetAddress, g.city, g.state, g.phoneNum, g.profilePic '
                   'FROM gym g JOIN trainer t '
                   'WHERE (SELECT t.city '
                   '       FROM trainer t '
                   '       WHERE t.username = "{}") = g.city '
                   'LIMIT 4;'.format(username))

    column_headers = [x[0] for x in cursor.description]
    json_data = []

    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# Get trainers' favorite exercises
@trainers.route('/trainerinterests/<username>', methods=['GET'])
def get_trainer_interests(username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * '
                   'FROM trainerGymInterests tgi JOIN exercises e ON e.name = tgi.exerciseName '
                   'WHERE tgi.memberUsername = "{}"'.format(username))

    column_headers = [x[0] for x in cursor.description]
    json_data = []

    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# get all trainer-associated workouts
@trainers.route('/getworkout/<username>', methods=['GET'])
def get_trainer_workout(username):
    cursor = db.get_db().cursor()
    query = '''
        SELECT wr.name, wc.exerciseName, wc.weight, wc.sets, wc.reps, wc.repTime
        FROM workoutContains wc JOIN workoutRoutine wr ON wc.workoutName = wr.name
                                JOIN trainerWorkoutCreated twc on twc.workoutName = wr.name
        WHERE twc.memberUsername = "{}"
    '''.format(username)
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []

    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# create a training session event
@trainers.route('/createtraining/<username>', methods=['POST'])
def create_training(username):

    # add details about session
    session_name = request.form['Name']
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
            (sessionID, description, name, cost, streetAddress, city, state, zipCode, startTime, endTime, trainerUsername)
        VALUES
            ((SELECT max(sessionID) FROM trainingSession) + 1, "{desc}", "{name}", "{cost}", "{add}", "{city}", "{state}", "{zip}", "{start}", "{end}", "{user}")
    '''.format(description, session_name, cost, street_address, city, state, zipcode,
               start_time, end_time, username)
    cursor.execute(query)
    cursor.connection.commit()

    return get_trainer_workout()


# create a workout
@trainers.route('/createtrainerworkout/<username>', methods=['POST'])
def create_train_workout(username):

    # add name of workout
    workout_name = request.form['Workout Name']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO workoutRoutine (name)
        VALUES ("{}");
        INSERT INTO trainerWorkoutCreated (workoutName, trainerUsername)
        VALUES ("{}", "{}")
    '''.format(workout_name, workout_name, username)
    cursor.execute(query)
    cursor.connection.commit()

    return get_trainer_workout()

# add an exercise
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
        INSERT INTO workoutContains (workoutName, exerciseName, weight, sets, reps, repTime, restTime)
        VALUES ("{workout}", "{exercise}", "{weight}", "{sets}",
               "{reps}", "{repTime}", "{restTime}")
    '''.format(workout_name, exercise_name, weight, sets, reps, repTime, restTime)
    cursor.execute(query)
    cursor.connection.commit()

    return get_trainer_workout()


# add an exercise interest
@trainers.route('/addinterest/<username>', methods=['POST'])
def add_interest(username):

    # add exercise
    exercise_name = request.form['Exercise']
    pr = request.form['PR']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO trainerGymInterests (trainerUsername, interest, pr)
        VALUES ("{}", "{}", "{}"); 
    '''.format(username, exercise_name, pr)
    cursor.execute(query)
    cursor.connection.commit()

    return get_trainer_interests
