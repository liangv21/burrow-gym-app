# burrow-gym-app project

# Introduction
A platform for connecting gym-goers, professional trainers, and gym fascilities alike!
Includes features such as:
1. Seeing nearby members
2. Creating and saving your own workouts
3. Sharing workouts and saving others to your own page
4. Gym fascility analytics, such as capacity and upcoming hosted events
5. Creating training sessions and gym events


# db
Includes the .sql file for instantiating the database in Docker

# flask-app
Includes the API routes needed to query the database

## src
Source code folder containing route folders

### gyms
For routes specifically for gym fascilities

### members
For routes specifically for gym-goers / members

### trainers
For routes specifically for professional trainers

### __init__
Initializes the folders and their API routes

### requirements.txt
Docker requirements for building

# Starting the Project
1. Open the terminal in the top-level folder, burrow-gym-app
2. Execute `docker compose build` then `docker compose up`
3. Open terminal where ngrok.exe is stored, execute `ngrok http 8001`
4. Open the Burrow AppSmith project