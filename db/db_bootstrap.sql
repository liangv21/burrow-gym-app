# create new database for the app
CREATE DATABASE burrowGymApp;

# set burrowGymApp as current database
USE burrowGymApp;

# create new administrative position with username/password
CREATE USER 'jyaleen'
    IDENTIFIED BY 'webapp_password';

# allows created user to perform all operations on db
GRANT ALL PRIVILEGES ON burrowGymApp.* TO 'jyaleen';

FLUSH PRIVILEGES;

# double checking: are we in the correct database?
USE burrowGymApp;

# create all tables
CREATE TABLE member (
    username CHAR(25) PRIMARY KEY NOT NULL UNIQUE,
    password TINYTEXT NOT NULL,
    email CHAR(200) UNIQUE NOT NULL,
    phoneNum BIGINT UNSIGNED UNIQUE NOT NULL,
    firstName TINYTEXT NOT NULL,
    lastName TINYTEXT NOT NULL,
    middleInitial TINYTEXT,
    age TINYINT UNSIGNED NOT NULL,
    userBio NVARCHAR(500),
    profilePic NVARCHAR(2000),
    city CHAR(50) NOT NULL,
    state CHAR(50)
);

CREATE TABLE trainer (
    username CHAR(25) PRIMARY KEY NOT NULL UNIQUE,
    password TINYTEXT NOT NULL,
    email CHAR(200) UNIQUE NOT NULL,
    phoneNum BIGINT UNSIGNED UNIQUE NOT NULL,
    firstName TINYTEXT NOT NULL,
    lastName TINYTEXT NOT NULL,
    middleInitial TINYTEXT,
    age TINYINT UNSIGNED NOT NULL,
    userBio NVARCHAR(500),
    profilePic NVARCHAR(2000),
    city CHAR(50) NOT NULL,
    state CHAR(50)
);

CREATE TABLE gym (
    username CHAR(25) PRIMARY KEY NOT NULL UNIQUE,
    password TINYTEXT NOT NULL,
    email CHAR(200) UNIQUE NOT NULL,
    phoneNum BIGINT UNSIGNED NOT NULL,
    name TINYTEXT NOT NULL,
    streetAddress CHAR(200) UNIQUE NOT NULL,
    city CHAR(50) NOT NULL,
    state CHAR(50),
    zipCode BIGINT UNSIGNED,
    profilePic NVARCHAR(2000),
    capacity INT NOT NULL,
    currentCapacity INT NOT NULL
);

CREATE TABLE event (
    eventID INT NOT NULL UNIQUE AUTO_INCREMENT,
    description NVARCHAR(500),
    name TINYTEXT NOT NULL,
    streetAddress CHAR(200) NOT NULL,
    city CHAR(50) NOT NULL,
    state CHAR(50),
    zipCode BIGINT UNSIGNED,
    startTime DATETIME NOT NULL,
    endTime DATETIME NOT NULL,
    hostGym CHAR(25) NOT NULL,
    supervisorTrainer CHAR(25),
    PRIMARY KEY (eventID, hostGym),
    CONSTRAINT fk_1
        FOREIGN KEY (hostGym) REFERENCES gym (username),
    CONSTRAINT fk_2
        FOREIGN KEY (supervisorTrainer) REFERENCES trainer (username)
);

CREATE TABLE trainingSession (
    sessionID INT NOT NULL UNIQUE AUTO_INCREMENT,
    description NVARCHAR(500),
    name CHAR(200) NOT NULL,
    cost TINYINT UNSIGNED NOT NULL,
    streetAddress CHAR(200) NOT NULL,
    city CHAR(50) NOT NULL,
    state CHAR(50),
    zipCode BIGINT UNSIGNED,
    profilePic NVARCHAR(2000),
    startTime DATETIME NOT NULL,
    endTime DATETIME NOT NULL,
    trainerUsername CHAR(25),
    PRIMARY KEY (sessionID, trainerUsername),
    CONSTRAINT fk_3
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username)
);

CREATE TABLE exercises (
    name CHAR(50) PRIMARY KEY NOT NULL UNIQUE,
    description NVARCHAR(500),
    safety NVARCHAR(500) NOT NULL,
    visual NVARCHAR(2000),
    isTimed BOOL,
    exerciseType CHAR(50)
);

CREATE TABLE memberSocialMedia (
    memberUsername CHAR(25) NOT NULL,
    accountType CHAR(50),
    handle CHAR(50),
    PRIMARY KEY (memberUsername, accountType),
    CONSTRAINT fk_5
        FOREIGN KEY (memberUsername) REFERENCES member (username)
);

CREATE TABLE availabilities (
    memberUsername CHAR(25) NOT NULL,
    dayOfWeek CHAR(10) NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    PRIMARY KEY (memberUsername, dayOfWeek, startTime, endTime),
    CONSTRAINT fk_6
        FOREIGN KEY (memberUsername) REFERENCES member (username)
);

CREATE TABLE attendsEvent (
    eventID INT NOT NULL,
    memberUsername CHAR(25) NOT NULL,
    PRIMARY KEY (eventID, memberUsername),
    CONSTRAINT fk_7
        FOREIGN KEY (eventID) REFERENCES event (eventID),
    CONSTRAINT fk_8
        FOREIGN KEY (memberUsername) REFERENCES member (username)
);

CREATE TABLE workoutRoutine (
    name CHAR(50) PRIMARY KEY NOT NULL
);

CREATE TABLE trainerWorkoutCreated (
    workoutName CHAR(50) NOT NULL,
    trainerUsername CHAR(25),
    PRIMARY KEY (workoutName, trainerUsername),
    CONSTRAINT fk_9
        FOREIGN KEY (workoutName) REFERENCES workoutRoutine (name),
    CONSTRAINT fk_trn
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username)
);

CREATE TABLE memberWorkoutCreated (
    workoutName CHAR(50) NOT NULL,
    memberUsername CHAR(25),
    PRIMARY KEY (workoutName, memberUsername),
    CONSTRAINT fk_27
        FOREIGN KEY (workoutName) REFERENCES workoutRoutine (name),
    CONSTRAINT fk_mem
        FOREIGN KEY (memberUsername) REFERENCES member (username)
);

CREATE TABLE workoutDone (
    workoutName CHAR(50) NOT NULL,
    memberUsername CHAR(25) NOT NULL,
    date DATE NOT NULL,
    location CHAR(50),
    PRIMARY KEY (workoutName, memberUsername),
    CONSTRAINT fk_10
        FOREIGN KEY (workoutName) REFERENCES workoutRoutine (name),
    CONSTRAINT fk_11
        FOREIGN KEY (memberUsername) REFERENCES member (username)
);

CREATE TABLE attendsTraining (
    sessionID INT NOT NULL,
    memberUsername CHAR(25) NOT NULL,
    PRIMARY KEY (sessionID, memberUsername),
    CONSTRAINT fk_12
        FOREIGN KEY (sessionID) REFERENCES trainingSession (sessionID),
    CONSTRAINT fk_13
        FOREIGN KEY (memberUsername) REFERENCES member (username)
);

CREATE TABLE trainerGymInterests (
    trainerUsername CHAR(25) NOT NULL,
    interest CHAR(50),
    pr INT UNSIGNED,
    PRIMARY KEY (trainerUsername, interest),
    CONSTRAINT fk_14
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username),
    CONSTRAINT fk_exercise2
        FOREIGN KEY (interest) REFERENCES exercises (name)
);

CREATE TABLE trainerSocialMedia (
    trainerUsername CHAR(25) NOT NULL,
    accountType CHAR(50),
    handle CHAR(50),
    PRIMARY KEY (trainerUsername, accountType),
    CONSTRAINT fk_15
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username)
);

CREATE TABLE employedBy (
    gymUsername CHAR(25) NOT NULL,
    trainerUsername CHAR(25) NOT NULL,
    PRIMARY KEY (gymUsername, trainerUsername),
    CONSTRAINT fk_16
        FOREIGN KEY (gymUsername) REFERENCES gym (username),
    CONSTRAINT fk_17
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username)
);

CREATE TABLE featuredIn (
    eventID INT NOT NULL,
    exerciseName CHAR(50) NOT NULL,
    PRIMARY KEY (eventID, exerciseName),
    CONSTRAINT fk_18
        FOREIGN KEY (eventID) REFERENCES event (eventID),
    CONSTRAINT fk_19
        FOREIGN KEY (exerciseName) REFERENCES exercises (name)
);

CREATE TABLE gymSchedule (
    gymUsername CHAR(25) NOT NULL,
    dayOfWeek CHAR(10) NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    PRIMARY KEY (gymUsername, dayOfWeek, startTime, endTime),
    CONSTRAINT fk_20
        FOREIGN KEY (gymUsername) REFERENCES gym (username)
);

CREATE TABLE gymAmenities (
    gymUsername CHAR(25) NOT NULL,
    facility CHAR(255) NOT NULL,
    PRIMARY KEY (gymUsername, facility),
    CONSTRAINT fk_21
        FOREIGN KEY (gymUsername) REFERENCES gym (username)
);

CREATE TABLE memberGymInterests (
    memberUsername CHAR(25) NOT NULL,
    exerciseName CHAR(50) NOT NULL,
    pr INT UNSIGNED,
    PRIMARY KEY (memberUsername, exerciseName),
    CONSTRAINT fk_22
        FOREIGN KEY (memberUsername) REFERENCES member (username),
    CONSTRAINT fk_23
        FOREIGN KEY (exerciseName) REFERENCES exercises (name)
);

CREATE TABLE workoutContains (
    workoutName CHAR(50) NOT NULL,
    exerciseName CHAR(50) NOT NULL,
    weight TINYINT,
    sets TINYINT UNSIGNED,
    reps TINYINT UNSIGNED,
    repTime TINYINT UNSIGNED,
    restTime TINYINT UNSIGNED,
    PRIMARY KEY (workoutName, exerciseName),
    CONSTRAINT fk_24
        FOREIGN KEY (workoutName) REFERENCES workoutRoutine (name),
    CONSTRAINT fk_25
        FOREIGN KEY (exerciseName) REFERENCES exercises (name)
);

# insert table data
INSERT INTO member
    (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state)
VALUES
    ('jyaleen_member', 'member_password', 'jyaleen@gymmember.com', 1234567890, 'Jyaleen', 'Member', null, '25', 'Hi there! My name is Jyaleen and I am a 25-year-old fitness enthusiast. I have been going to the gym and have seen great progress in my overall health and wellbeing. I love pushing myself to reach new fitness goals. In my free time, I enjoy hiking. I am excited to continue my fitness journey and inspire others along the way.', 'https://lh3.googleusercontent.com/pw/AL9nZEXr_-topVwCID22-xyGaJFVpTiD6ot5ZcHeTVQ-boB50uXDruw4MhCwF9LVZtli8Dh2QB-g1XK_qYHSdN0gLW29HondU2cLE5V7uRhOe9oIgjkPBFhyktBkPY6lmddzGIIcX2-ksPRiiColB7aJPejR=w505-h943-no?authuser=0', 'Boston', 'MA'),
    ('bingusbongus', 'bingus123', 'bingus@gmail.com', 1987654321, 'Bingus', 'Bongus', null, '65', 'Hello! My name is Bingus and I love the gym.', 'https://i1.sndcdn.com/avatars-nfmrTVtUp0fzqzu9-EwxkWw-t500x500.jpg', 'Boston', 'MA'),
    ('frenchman', 'bonjour', 'charles@france.net', 9817238492, 'Charles', 'de Gaulle', null, '51', 'Bonjour, I am Charles and I love working out with my friends to prepare for both World Wars.', 'https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTgwMTU3NzQwNTMyOTAxMjA4/gettyimages-515356660-copy.jpg', 'Boston', 'MA'),
    ('greenogre', 'i<3fiona', 'shrek@theswamp.org', 3145682846, 'Shrek', 'Shrek', null, '20', 'On days where I am not in the gym, you can find me in my comfy little swamp.', 'https://i.insider.com/5c5dd439dde867479d106cc2?width=1000&format=jpeg&auto=webp', 'Boston', 'MA'),
    ('biden', 'formervicepresident', 'biden@whitehouse.gov', 9119119111, 'Joe', 'Biden', null, '80', 'Stressed out from running the government? Just work out instead.', 'https://www.history.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc2MzAyNDY4NjM0NzgwODQ1/joe-biden-gettyimages-1267438366.jpg', 'Boston', 'MA'),
    ('fontenot', 'i<3cs3200', 'mark@databasedesign.com', 4123847192, 'Mark', 'Fontenot', null, '2', 'Tired of NEU kids but this is okay i guess', 'https://www.smu.edu/-/media/Images/News/Experts/Mark-Fontenot.jpg', 'Boston', 'MA'),
    ('aaaaaaa', 'famousperson', 'arnold@arnold.net', 5348261947, 'Arnold', 'Schwarzenegger', null, '73', 'This is a bio.', 'https://upload.wikimedia.org/wikipedia/commons/a/af/Arnold_Schwarzenegger_by_Gage_Skidmore_4.jpg', 'Boston', 'MA'),
    ('notrelevant', 'notrelevant', 'irrelevant@irrelevant.net', 4826491782, 'Not', 'Relevant', 'NR', '14', 'This is a tester user with a different city', null, 'New York', 'NY'),
    ('onemore', 'onemore', 'onemore@gmail.com', 9472619847, 'One', 'More', null, '25', 'This is one more useless user.', null, 'New York', 'NY');

INSERT INTO trainer
    (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state)
VALUES
    ('jyaleen_trainer', 'trainer_password', 'jyaleen@gymtrainer.com', 8273638282, 'Jyaleen', 'Trainer', null, '25', 'Hi there! My name is Jyaleen and I am a 25-year-old fitness enthusiast. I have been going to the gym and have seen great progress in my overall health and wellbeing. I love pushing myself to reach new fitness goals. In my free time, I enjoy hiking. I am excited to continue my fitness journey and inspire others along the way.', 'https://lh3.googleusercontent.com/pw/AL9nZEXr_-topVwCID22-xyGaJFVpTiD6ot5ZcHeTVQ-boB50uXDruw4MhCwF9LVZtli8Dh2QB-g1XK_qYHSdN0gLW29HondU2cLE5V7uRhOe9oIgjkPBFhyktBkPY6lmddzGIIcX2-ksPRiiColB7aJPejR=w505-h943-no?authuser=0', 'Boston', 'MA'),
    ('another_trainer', 'another_trainer', 'another@gymtrainer.com', 4726374893, 'Wanda', 'Wiggles', null, '58', 'This is another trainer for testing purposes!', null, 'Boston', 'MA'),
    ('yetanother', 'yetanother', 'hm@gmail.com', 9152837474, 'Bob', 'Bobby', null, '12', null, null, 'Boston', 'MA'),
    ('haha', 'hahahaha', 'haha@yahoo.com', 9163528472, 'Caitlin', 'Cool', null, '41', null, null, 'New York', 'NY'),
    ('fifthtrainer', 'fifth', 'five@aol.com', 5555555555, 'Fiona', 'Fifth', null, '55', null, null, 'New York', 'NY');

INSERT INTO gym
    (username, password, email, phoneNum, name, streetAddress, city, state, zipCode, profilePic, capacity, currentCapacity)
VALUES
    ('ymcaboston', 'whyemseea', 'ymca@ymca.org', 1111111111, 'YMCA Boston', '316 Huntington Ave', 'Boston', 'MA', 02115, 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/YMCA_Huntington_Avenue_Boston_entrance.jpg/220px-YMCA_Huntington_Avenue_Boston_entrance.jpg', 50, 20),
    ('planetfitness', 'saturniscool', 'planetfitness@pf.org', 2222222222, 'Planet Fitness', '17 Winter St', 'Boston', 'MA', 02108, 'https://prodd8.planetfitness.com/sites/default/files/styles/gallery_full_image/public/2021-05/exterior_1.jpg', 40, 10),
    ('southend', 'fitnesscenter', 'southend@south.south', 3333333333, 'South End Fitness Center', '785 Albany St, 4th Fl', 'Boston', 'MA', 02118, 'https://cdntrust.s3.us-east-2.amazonaws.com/busines/b552a450-c4d3-4d5f-9299-d592582150dd/0.jpg', 45, 15),
    ('marino', 'nosquatracks', 'marino@marino.edu', 4444444444, 'Marino Recreation Center', '369 Huntington Ave', 'Boston', 'MA', 02115, 'https://huntnewsnu.com/wp-content/uploads/2014/05/4847936340_ac406b6658_b-1024x683.jpg', 2, 1),
    ('randomgym', 'randomgym', 'random@random.gym', 5555555555, 'Random Gym', '123 Boston Ave', 'New York', 'NY', 10009, null, 30, 20);

INSERT INTO event
    (description, name, streetAddress, city, state, zipCode, startTime, endTime, hostGym, supervisorTrainer)
VALUES
    ('[26:2] The LORD appeared to Isaac and said, "Do not go down to Egypt; settle in the land that I shall show you."', 'Workout with Wanda', '456 Random Ave', 'Boston', 'MA', 02113, '2022-10-09 15:45:00', '2022-10-09 16:45:00', 'ymcaboston', 'another_trainer'),
    ('Jesus did many other things as well. If every one of them were written down, I suppose that even the whole world would not have room for the books that would be written.', 'Protein Powder Potluck', '321 Huntington Ave', 'Boston', 'MA', null, '2022-12-10 12:00:00', '2022-12-10 14:00:00', 'ymcaboston', 'yetanother'),
    ('"But Jael, Heber''s wife, picked up a tent peg and a hammer and went quietly to him while he lay fast asleep, exhausted. She drove the peg through his temple into the ground, and he died."', 'Gym Rats Eat Cheese', '456 Gainsborough St', 'Boston', 'MA', null, '2022-12-11 16:00:00', '2022-12-11 18:00:00', 'ymcaboston', null),
    ('"Our father is old, and there is no man around here to give us children. Let us get our father to drink wine and then sleep with him and preserve our family line through our father"', '72nd Annual Powerlifting Nationals', '316 Huntington Ave', 'Boston', 'MA', null, '2023-01-01 00:00:00', '2023-01-01 05:00:00', 'ymcaboston', null),
    ('This is a random event description', 'Random Event Name', '123 Random St', 'Random', 'NY', 12345, '2023-02-02 03:30:00', '2023-02-02 04:30:00', 'randomgym', null);

INSERT INTO trainingSession
    (description, name, cost, streetAddress, city, state, zipCode, profilePic, startTime, endTime, trainerUsername)
VALUES
    ('[26:2] The LORD appeared to Isaac and said, "Do not go down to Egypt; settle in the land that I shall show you."', 'Crying With Calisthenics', 10, '369 Huntington Ave', 'Boston', 'MA', 02115, null, '2022-12-11 09:00:00', '2022-12-11 10:00:00', 'jyaleen_trainer'),
    ('[38:26] Then Judah acknowledged them and said, She is more in the right than I, since I did not give her to my son Shelah. And he did not lie with her again.', 'Pouting with Powerlifters', 20, '99 Symphony', 'Boston', 'MA', 02115, null, '2022-12-12 12:00:00', '2022-12-12 14:00:00', 'jyaleen_trainer'),
    ('[46:1] When Israel set out on his journey with all that he had and came to Beer-sheba, he offered sacrifices to the God of his father Isaac.', 'Yoga with Togas', 25, '100 Westland Ave', 'Boston', 'MA', 02115, null, '2022-12-13 15:00:00', '2022-12-13 16:00:00', 'jyaleen_trainer'),
    ('We are a group of driven college students who seek to spread Chinese culture through artful and unique performances of Chinese Dragon Dance and Lion Dance.', 'Dying with Dragon Dance', 200, '400 Huntington Ave', 'Boston', 'MA', 02115, null, '2023-01-14 19:00:00', '2023-01-14 21:30:00', 'jyaleen_trainer'),
    ('This is a random training session description', 'Random Training Session Name', 12, '123 Random St', 'Random', 'NY', 12345, null, '2023-03-03 04:40:00', '2023-03-03 05:40:00', 'haha');

INSERT INTO exercises
    (name, description, safety, visual, isTimed, exerciseType)
VALUES
    ('Bicep Curls', 'Bicep curls are a strength training exercise that involves lifting weights from a hanging position to a contracted position in order to target and tone the biceps muscles.', 'Keep body in a neutral alignment and avoid compensation when performing the movement. Shoulders should remain stable. Elbows should be pinned to side.', 'https://www.inspireusafoundation.org/wp-content/uploads/2022/05/dumbbell-biceps-curl-1024x900.png', 0, 'Dumbbell'),
    ('Shoulder Press', 'Shoulder press is a weightlifting exercise that involves raising a weight above the head with the palms facing forward in order to work the deltoid muscles in the shoulders.', 'Here is some safety information about doing shoulder presses.', 'https://static.strengthlevel.com/images/illustrations/dumbbell-shoulder-press-1000x1000.jpg', 0, 'Dumbbell'),
    ('Plank', 'Plank involves holding the body in a straight line on the toes and forearms, with the back and legs straight in order to strengthen the core and improve overall stability.', 'Here is some safety information about planks.', 'https://cdn.spongebobwiki.org/0/04/Plankton.jpg', 1, 'Bodyweight'),
    ('Russian Twist', 'The Russian twist is a core exercise that involves sitting on the ground with your knees bent and feet flat on the ground. This exercise works your abdominal muscles and can also help to improve your balance and stability.', 'Here is safety information on Russian Twists.', 'https://static.strengthlevel.com/images/illustrations/russian-twist-1000x1000.jpg', 0, 'Dumbbell'),
    ('Push-Ups', 'A push-up is a bodyweight exercise in which you lower and raise your body using your arms and upper body strength.This exercise works your chest, triceps, and shoulders.', 'Here is some safety information about push-ups.', null, 0, 'Bodyweight'),
    ('Chest Flies', 'Chest flies, also known as flyes or pectoral flies, are a strength training exercise that targets the muscles of the chest, specifically the pectoralis major.', 'Here is some safety information about chest flies.', null, 0, 'Strength'),
    ('Lat Raises', 'Lat raises are a strength training exercise that targets the muscles of the back, specifically the latissimus dorsi, or lats.', 'Here is some safety information about lat raises.', null, 0, 'Strength'),
    ('Squats', 'Squats are a full-body exercise that targets the muscles of the legs and lower body, including the quadriceps, hamstrings, and glutes.', 'Here is some safety information about squats.', null, 0, 'Full-Body'),
    ('Hip Abduction', 'Hip abduction is a strength training exercise that targets the muscles of the hips, specifically the gluteus medius and gluteus minimus.', 'Here is some safety information about hip abductions.', null, 0, 'Strength'),
    ('Leg Curls', 'Leg curls are a strength training exercise that targets the muscles of the lower leg, specifically the hamstrings.', 'Here is some safety information about leg curls.', null, 0, 'Strength'),
    ('Calf Raises', 'Calf raises are a strength training exercise that targets the muscles of the lower leg, specifically the calves.', 'Here is some safety information about calf raises.', null, 0, 'Strength'),
    ('Sit-Ups', 'Sit-ups are a core exercise that targets the muscles of the abdominal region.', 'Here is some safety information about sit-ups.', null, 0, 'Core'),
    ('Reverse Crunches', 'Reverse crunches are a core exercise that targets the muscles of the lower abdominal region.', 'Here is some safety information about reverse crunches.', null, 0, 'Core'),
    ('Supermans', 'Supermans is a core exercise that targets the muscles of the lower back.', 'Here is some safety information about supermans.', null, 0, 'Core'),
    ('Side Plank', 'A side plank is a core exercise that targets the muscles of the side abdominal region, also known as the obliques.', 'Here is some safety information about side planks.', null, 0, 'Core');

INSERT INTO memberGymInterests
    (memberUsername, exerciseName, pr)
VALUES
    ('jyaleen_member', 'Bicep Curls', 205),
    ('jyaleen_member', 'Shoulder Press', 208),
    ('jyaleen_member', 'Plank', null),
    ('jyaleen_member', 'Russian Twist', 20),
    ('bingusbongus', 'Chest Flies', 300),
    ('bingusbongus', 'Bicep Curls', 200),
    ('fontenot', 'Shoulder Press', 212),
    ('fontenot', 'Russian Twist', 50),
    ('biden', 'Plank', null),
    ('biden', 'Squats', null),
    ('biden', 'Supermans', null),
    ('greenogre', 'Sit-Ups', null),
    ('greenogre', 'Leg Curls', 110),
    ('greenogre', 'Side Plank', null),
    ('frenchman', 'Side Plank', null),
    ('frenchman', 'Bicep Curls', 12),
    ('frenchman', 'Plank', null);

INSERT INTO memberSocialMedia
    (memberUsername, accountType, handle)
VALUES
    ('jyaleen_member', 'Instagram', 'jyaleeniscool'),
    ('jyaleen_member', 'Snapchat', 'jyaleenisstillcool'),
    ('jyaleen_member', 'BeReal', 'wooooojyaleen'),
    ('fontenot', 'Twitter', 'fontenottwitter'),
    ('fontenot', 'Instagram', 'instafontenot'),
    ('biden', 'Twitter', 'thewhitehouse'),
    ('greenogre', 'Facebook', 'greengreengreen'),
    ('bingusbongus', 'TikTok', 'BingBong'),
    ('onemore', 'Instagram', 'onemoresocialmedia');

INSERT INTO availabilities
    (memberUsername, dayOfWeek, startTime, endTime)
VALUES
    ('jyaleen_member', 'Monday', '12:00:00', '14:00:00'),
    ('jyaleen_member', 'Sunday', '14:00:00', '18:00:00'),
    ('fontenot', 'Saturday', '08:00:00', '14:00:00'),
    ('biden', 'Friday', '18:00:00', '23:00:00'),
    ('biden', 'Sunday', '12:00:00', '15:00:00');

INSERT INTO attendsEvent
    (eventID, memberUsername)
VALUES
    (1, 'jyaleen_member'),
    (1, 'fontenot'),
    (1, 'biden'),
    (1, 'bingusbongus'),
    (2, 'jyaleen_member'),
    (2, 'greenogre'),
    (3, 'fontenot'),
    (4, 'biden'),
    (5, 'frenchman'),
    (5, 'jyaleen_member');

INSERT INTO workoutRoutine
    (name)
VALUES
    ('Workout #1'),
    ('Workout #2'),
    ('Workout #3'),
    ('Workout Name'),
    ('Another Workout Name'),
    ('Trainer Workout'),
    ('Workout Perfect for NY Trainers');

INSERT INTO trainerWorkoutCreated
    (workoutName, trainerUsername)
VALUES
    ('Workout Perfect for NY Trainers', 'haha'),
    ('Trainer Workout', 'fifthtrainer'),
    ('Another Workout Name', 'jyaleen_trainer');

INSERT INTO memberWorkoutCreated
    (workoutName, memberUsername)
VALUES
    ('Workout #1', 'jyaleen_member'),
    ('Workout #2', 'jyaleen_member'),
    ('Workout #3', 'jyaleen_member'),
    ('Workout Name', 'fontenot');

INSERT INTO workoutDone
    (workoutName, memberUsername, date, location)
VALUES
    ('Workout #1', 'jyaleen_member', '2022-11-30', null),
    ('Workout #1', 'biden', '2022-12-01', 'The White House'),
    ('Workout Name', 'fontenot', '2022-12-10', 'Richards Classroom'),
    ('Trainer Workout', 'frenchman', '2022-12-11', null),
    ('Another Workout Name', 'greenogre', '2022-12-12', null);

INSERT INTO attendsTraining
    (sessionID, memberUsername)
VALUES
    (1, 'jyaleen_member'),
    (1, 'greenogre'),
    (1, 'frenchman'),
    (2, 'fontenot'),
    (2, 'jyaleen_member'),
    (2, 'bingusbongus'),
    (2, 'frenchman'),
    (4, 'jyaleen_member'),
    (4, 'frenchman');

INSERT INTO trainerGymInterests
    (trainerUsername, interest, pr)
VALUES
    ('jyaleen_trainer', 'Bicep Curls', 10),
    ('jyaleen_trainer', 'Shoulder Press', 10),
    ('jyaleen_trainer', 'Plank', null),
    ('jyaleen_trainer', 'Russian Twist', 199),
    ('another_trainer', 'Plank', null),
    ('another_trainer', 'Supermans', null),
    ('haha', 'Plank', null),
    ('haha', 'Russian Twist', null),
    ('haha', 'Bicep Curls', null),
    ('haha', 'Push-Ups', null);

INSERT INTO trainerSocialMedia
    (trainerUsername, accountType, handle)
VALUES
    ('jyaleen_trainer', 'Instagram', 'jyaleentrains'),
    ('jyaleen_trainer', 'TikTok', 'jyaleentiktoks'),
    ('jyaleen_trainer', 'Twitter', 'jyaleentweets'),
    ('haha', 'Twitter', 'hahahaha'),
    ('haha', 'Snapchat', 'hahahaha'),
    ('haha', 'YouTube', 'hahahahahahaha');

INSERT INTO employedBy
    (gymUsername, trainerUsername)
VALUES
    ('marino', 'jyaleen_trainer'),
    ('ymcaboston', 'haha'),
    ('southend', 'another_trainer'),
    ('planetfitness', 'yetanother'),
    ('randomgym', 'fifthtrainer');

INSERT INTO featuredIn
    (eventID, exerciseName)
VALUES
    (1, 'Bicep Curls'),
    (1, 'Squats'),
    (1, 'Plank'),
    (1, 'Reverse Crunches'),
    (4, 'Push-Ups'),
    (4, 'Supermans'),
    (5, 'Side Plank'),
    (5, 'Squats');

INSERT INTO gymSchedule
    (gymUsername, dayOfWeek, startTime, endTime)
VALUES
    ('ymcaboston', 'Monday', '06:00:00', '22:00:00'),
    ('ymcaboston', 'Tuesday', '06:00:00', '22:00:00'),
    ('ymcaboston', 'Wednesday', '06:00:00', '22:00:00'),
    ('ymcaboston', 'Thursday', '06:00:00', '22:00:00'),
    ('ymcaboston', 'Friday', '06:00:00', '22:00:00'),
    ('ymcaboston', 'Saturday', '06:00:00', '20:00:00'),
    ('ymcaboston', 'Sunday', '06:00:00', '20:00:00'),
    ('southend', 'Monday', '12:00:00', '03:00:00'),
    ('planetfitness', 'Saturday', '00:00:00', '23:59:59'),
    ('marino', 'Sunday', '05:00:00', '17:00:00'),
    ('marino', 'Tuesday', '03:00:00', '08:00:00');

INSERT INTO workoutContains
    (workoutName, exerciseName, weight, sets, reps, repTime, restTime)
VALUES
    ('Workout #1', 'Bicep Curls', 20, 3, 15, null, null),
    ('Workout #1', 'Shoulder Press', 30, 3, 10, null, null),
    ('Workout #1', 'Push-Ups', 0, 3, 5, null, null),
    ('Workout #1', 'Chest Flies', 50, 2, 10, null, null),
    ('Workout #1', 'Lat Raises', 5, 1, 20, null, null),
    ('Workout #2', 'Squats', 90, 3, 10, null, null),
    ('Workout #2', 'Hip Abduction', 100, 2, 8, null, null),
    ('Workout #2', 'Leg Curls', 70, 3, 12, null, null),
    ('Workout #2', 'Calf Raises', 0, 3, 30, null, null),
    ('Workout #3', 'Sit-Ups', 0, 3, 25, null, null),
    ('Workout #3', 'Plank', 0, 2, null, 60, null),
    ('Workout #3', 'Reverse Crunches', 0, 3, 20, null, null),
    ('Workout #3', 'Supermans', 0, 3, 15, null, null),
    ('Workout #3', 'Side Plank', 0, 6, null, 30, null);