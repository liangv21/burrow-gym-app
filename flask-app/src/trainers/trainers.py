from flask import Blueprint, request, jsonify, make_response
import json
from src import db


trainers = Blueprint('trainers', __name__)

# create a training session event
@trainers.route('/createtraining/<username>', methods=['POST'])
def create_workout(username):

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
    zipcode = request.form ['Zip Code']

    # add to database
    cursor = db.get_db().cursor()
    query = '''
        INSERT INTO trainingSession
            (sessionID, description, name, cost, streetAddress, city, state, zipCode, calendarDate, startTime, endTime, trainerUsername)
        VALUES
            ((SELECT max(sessionID) FROM trainingSession) + 1, {desc}, {name}, {cost}, {add}, {city}, {state}, {zip}, {day}, {start}, {end}, {user})
    '''.format(description, session_name, cost, street_address, city, state, zipcode,
               day_of_session, start_time, end_time, username)
    cursor.execute(query)
    cursor.connection.commit()