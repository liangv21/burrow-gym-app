# create new database for the app
CREATE DATABASE burrowGymApp;

# set burrowGymApp as current database
USE burrowGymApp;

# create new administrative position with username/password
CREATE USER 'jyaleen'@'%'
    IDENTIFIED BY 'gymratadmin';

# allows created user to perform all operations on db
GRANT ALL PRIVILEGES ON burrowGymApp.* TO 'jyaleen'@'%';

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
    userBio CHAR(225),
    profilePic BLOB,
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
    userBio CHAR(225),
    profilePic BLOB,
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
    capacity INT NOT NULL,
    currentCapacity INT NOT NULL
);

CREATE TABLE event (
    eventID TINYINT UNSIGNED NOT NULL UNIQUE,
    description CHAR(225),
    name TINYTEXT NOT NULL,
    streetAddress CHAR(200) NOT NULL,
    city CHAR(50) NOT NULL,
    state CHAR(50),
    calendarDate DATE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    hostGym CHAR(25) NOT NULL,
    supervisorTrainer CHAR(25),
    PRIMARY KEY (eventID, hostGym),
    CONSTRAINT fk_1
        FOREIGN KEY (hostGym) REFERENCES gym (username),
    CONSTRAINT fk_2
        FOREIGN KEY (supervisorTrainer) REFERENCES trainer (username)
);

CREATE TABLE trainingSession (
    sessionID TINYINT UNSIGNED NOT NULL UNIQUE,
    description CHAR(225),
    cost TINYINT UNSIGNED NOT NULL,
    streetAddress CHAR(200) NOT NULL,
    city CHAR(50) NOT NULL,
    state CHAR(50),
    calendarDate DATE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    trainerUsername CHAR(25),
    PRIMARY KEY (sessionID, trainerUsername),
    CONSTRAINT fk_3
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username)
);

CREATE TABLE exercises (
    name CHAR(50) PRIMARY KEY NOT NULL UNIQUE,
    description CHAR(225),
    safety CHAR(225) NOT NULL,
    visual BLOB,
    isTimed BOOL,
    exerciseType CHAR(50)
);

CREATE TABLE memberGymInterests (
    memberUsername CHAR(25) NOT NULL,
    interest CHAR(50),
    PRIMARY KEY (memberUsername, interest),
    CONSTRAINT fk_4
        FOREIGN KEY (memberUsername) REFERENCES member (username)
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
    eventID TINYINT UNSIGNED NOT NULL,
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

CREATE TABLE workoutCreated (
    workoutName CHAR(50) NOT NULL,
    trainerUsername CHAR(25),
    PRIMARY KEY (workoutName, trainerUsername),
    CONSTRAINT fk_9
        FOREIGN KEY (workoutName) REFERENCES workoutRoutine (name),
    CONSTRAINT fk_check
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username)
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
    sessionID TINYINT UNSIGNED NOT NULL,
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
    PRIMARY KEY (trainerUsername, interest),
    CONSTRAINT fk_14
        FOREIGN KEY (trainerUsername) REFERENCES trainer (username)
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
    eventID TINYINT UNSIGNED NOT NULL,
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

CREATE TABLE likes (
    memberUsername CHAR(25) NOT NULL,
    exerciseName CHAR(50) NOT NULL,
    pr CHAR(50) NOT NULL,
    PRIMARY KEY (memberUsername, exerciseName),
    CONSTRAINT fk_22
        FOREIGN KEY (memberUsername) REFERENCES member (username),
    CONSTRAINT fk_23
        FOREIGN KEY (exerciseName) REFERENCES exercises (name)
);

CREATE TABLE workoutContains (
    workoutName CHAR(50) NOT NULL,
    exerciseName CHAR(50) NOT NULL,
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

CREATE TABLE targetMuscles (
    exerciseName CHAR(50) PRIMARY KEY NOT NULL,
    muscleGroup CHAR(255),
    CONSTRAINT fk_26
        FOREIGN KEY (exerciseName) REFERENCES exercises (name)
);

# insert table data
insert into member (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('wklisch0', 'LyJ40X', 'wklisch0@economist.com', 1277494588, 'Townie', 'Klisch', null, 42, 'Arteriovenous malformation, other site', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHtSURBVDjLY/j//z8DJZiBKgY49drM9J3idhLEtu+xjvea4nLNqsVspnWr2S6QmF6+Zol2ltpq5QSlmcpxijMxDABp9pjkuMuu28rIpsMi3rLZFKzIus38mm6OuqRxpf41nC5w7rOJd+i1ngnUXGLTbj7Tsskk3rbL8ppZreEu7Ry1mWpJSvHK8Uoz0TWK5U/nYIg8y8rgPsl+l12P1WqgbTPdJtk/AtoWb1CkBdagnqyyWilawVM/Rw/FBQyx540ZGm/eYIg8P43BdYLdSZiEcYXeTJB/TaoNroH8q5OldVIhXE5SKUqhXSNRfZdKvPKVkOrED+L9d/8wN998w+B4XIL40I48K8FQf/O6+7In/7mbb35hsD2qjBKNDLU3ExjKb7pi1Rx61ke89+6fwBVP/jPXXn/HYHlYGiMdMJTe1JJc/PgHQ/X1xQyplznBYuFnmRiiz062nPfof8DSJ/8ZSq8/ZzA9KIEzIQE1Vvuuf/6fufv2M4bgsz4MxVdPui8Cal4C1Jx/+RGDPqpmTANiz7MAvXI+bO2L/5ZzHvzP2Pjif8DCx/8ZMi/fY9DcL0FUUmbwPKkg3Hr7T+WOV//95j/8z5B6/jaD6l4JkvIC0J9FTtPu/2dIPn+PQXG3BFmZiUFzbweDLH7NVMmNAOGld33BRiNUAAAAAElFTkSuQmCC', 'Bộc Bố', null);
insert into member (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('kplues1', 'vvA6ISvnvJs', 'jplues1@1688.com', 4083404377, 'Dewey', 'Plues', null, 75, null, null, 'Itaberaí', null);
insert into member (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('ebason2', 'jqfGyLmfi', 'ibason2@youtube.com', 5806680799, 'Kean', 'Bason', null, 73, 'Nondisp artic fx head of r femr, init for opn fx type 3A/B/C', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAALBSURBVDjLbVNLSFRRGP7uw3lpw5TaNCZ5R6eEhIhahBFRoIsetEgJImhRUBQTUpCLFhK5dN8ycDESLSqCULLoSVZYDZYDTo7TOCTJTOk4zeu+Tv+5OjZWB37uOf/5/+9833fOFRhjqBxDQ0M1pmleNQyjnWIDBSh+Uozpuj7Q09Pzq7JeqAQIhUI7qfluQ0OD3+12QxRF0BrFYhGpVApxGgR0vLe3N/wPADXX0ObHlpaWgKqqSCaTyOVy/HTIsgyv12vVRSKRacrt6OvrK/C1WEai5AWfzxfQNA3RaHQmm80qNLfx4POpqak5DkzsAiQlWO6TyxNKtrtcLsRiMVDT0WAwmKiQmujv7+9IJBIRRVGs2v8B1HPNdBqfx/HX4DnOjtcQ2/o1Hsy+OsPGYq2YzzgtzcfaxiExDczQwfTl0DQDg+FdlqlexwKObB5H67kPwjIDAunuOgiBLBEkJ30PAaZA/Bx8kwzSYOhZ3OjMUV6zWqZvv/4jgZ/EC/X0Hcj2OghCDRVWAU4PpU0gn4Gx9AVq4RtMPQ+nPwimlioAiCJMfpKKxcn3pLManu17kRwZoP6N2LK/E/H7z5GemEExnYFc/xZ2zxoAzZLBiKqndRtEWx25Y8IoGfiUdkJ8+gbqoozdp6/B7m9DYeIRIi9HMdpRdcl6B4zcZcywtC58DhOLd/RCdJhFE6VCCfGRxwgc6IYj9gzC4Em4Zu5BaaoFE9hluQzAtTKS4NmqQHLVEoCK5lPn0azpeHJiGI5NfuDwldVrla/7IJmCsgKgkgcmGcQ9mCSAdYCDjJRtlNchue3Ihx+i+sFFYvQdeerJLkkwJMytAnAJ9sazcDZJEGz25SsU6SZMA81ddYi8GEbjeidkqQrZlI6v8wLdG7tpPaTorT2MG2l5YT0cbSX01a/6Q0ZmdgGgX4g5GBwehn0hQ/gNd0qgkPVltHcAAAAASUVORK5CYII=', 'Akkol’', null);
insert into member (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('atrowler3', 'zp5pir', 'ctrowler3@vk.com', 9496114863, 'Odille', 'Trowler', null, 47, null, null, 'Newport Beach', 'California');
insert into member (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('bburriss4', 't15ewxLLeNAc', 'gburriss4@columbia.edu', 8881095427, 'Ketti', 'Burriss', null, 48, null, null, 'Dinaig', null);

insert into trainer (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('dgehrels0', 'Tige3p', 'egehrels0@woothemes.com',7875873669, 'Lesley', 'Gehrels', null, 25, null, null, 'Gandajika', null);
insert into trainer (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('dtew1', '1qha460Mn', 'vtew1@nsw.gov.au', 7427382357, 'Dulciana', 'Tew', null, 44, null, null, 'Châteaurenard', 'Provence-Alpes-Côte d''Azur');
insert into trainer (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('shardy2', 'nMj4ygE8KJ', 'ehardy2@guardian.co.uk', 6008826067, 'Reynolds', 'Hardy', null, 44, 'Displ oblique fx shaft of unsp tibia, 7thK', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAHcSURBVDjLhZPZihpREIb7JeY2wbcQmjxZbrIQ5nKSIYQ8gyuKOwqKihuKKy5xnJ5GRzteTIjTp51e+HPqDDaKSy7qoqvq/+qvYykNBgP0+310u110Oh202220Wi00m000Go0rANKlkHq9HhzHOYr5fC4g1Wr1IkSiySRQVVVMVhTFhVCOu0CpVDoLkcgyNdM0StTr9eZms4FlWSJPwEqlgnw+fxIi0dRdIxe/cMuqYRgw2SO2v9OiNpvNUCwWkcvljiASTd5Ztm0bJLa3GvTpZ+iT9xySErXpdEoukE6nDyAS35Gt12vRZJomTP0R+q9PYPc3MB6+C9AOMplMyAXi8bgLkWq12ju+I9M0TTRtnzp45pOZ8g2G+vMIMh6PyQUikYiACEq5XJb5jmy1Wr1C/vQ55CMM5XYPwr+1hKgPh0NygVAodOXuUigUZL4jWy6Xx5CHH2B313gaXcOxLeEimUwiEAi8PXhRvp+czWbZYrHYg3yAfvcFf6e3eDE2+2KPu8J+ZDIZOZVKMbrEV0gPz/df4ViGK/b7/R73EU8dRyKRkGOxGKNL3P3EJOb5A/FZAEU0GvXyl2Z0YKPR6KT4IoAiHA57g8EgI7HP5/OcPOX//V35VC8XvzlX/we1NDqN64FopAAAAABJRU5ErkJggg==', 'Canedo', 'Aveiro');
insert into trainer (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('jchampley3', 'e62LSIHEmLGt', 'jchampley3@google.it', 7549786563, 'Evangelin', 'Champley', null, 41, null, null, 'Lens', 'Nord-Pas-de-Calais');
insert into trainer (username, password, email, phoneNum, firstName, lastName, middleInitial, age, userBio, profilePic, city, state) values ('hmcginny4', 'Q92CfhSzvQJ', 'bmcginny4@people.com.cn', 1186466544, 'Giff', 'McGinny', null, 54, 'Age-related incipient cataract', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAGaSURBVBgZpcG9alRRGIXh99vnKIGgrbaCl5BOC2/BJgi2NmIlFoK9oI1CIJ39kInxhxReh1VKCZmfQkiVTOLs863l7GAau5DnCdtcRzx+ufPi4aON98cLr9uAhCVSiWVk4Uxk40xS4vbNenpwMH395cPmdr/xYGPrxtp6ubPGVayfLnIL2O4X1WVxfMJVnVUXVnqnefv0Plf17N0hTW+LZjkkBiyTAmEkkxI5mBxMWizT3Lt7i1TS9Ng0UYKwcQkcJhSUEkQUIpLoTKdCP5hGQ9L0qaQpgCMgoDMoQDKdoURHH5BhsohGKZpimdFoxGQyYXdnh9nREXvjMbPphO97u8ynE/a/7jKbT/ix/5nf8zmj0QgpufDq0083g+RB8iC5Zrpmepnp80z/qdVny+rFsvrkvLp58uabV+iHWrkQQQC2iQjMik1hpRQ6IG1KmGaoA03vFE0HmJUIsGkigksCuggs0Vii6SVxKYBgJYL/dfzTdTSyafrpr8Px8491U5koRWYiiawVScjGSpxGFpaQaMashG2uo3BNfwFx+DLsFQ4W2wAAAABJRU5ErkJggg==', 'Buenavista', 'Oaxaca');

insert into gym (username, password, email, phoneNum, name, streetAddress, city, state, capacity, currentCapacity) values ('sgotthard0', 'A6ssdSnkdJt', 'amacalaster0@bizjournals.com', 8295446634, 'Kling, Pfannerstill and Lang', '123 Potato St', 'Dumaguete', null, 54, 194);
insert into gym (username, password, email, phoneNum, name, streetAddress, city, state, capacity, currentCapacity) values ('njancik1', 'LQUwCVccH', 'mwatting1@exblog.jp', 7474115908, 'Zieme-Walker', '456 Tomato St', 'Xinzha', null, 10, 154);
insert into gym (username, password, email, phoneNum, name, streetAddress, city, state, capacity, currentCapacity) values ('cbaffin2', 'mcD1SJ9xrp', 'bmariet2@bbc.co.uk', 3134453407, 'Daugherty and Sons', '12 Symphony Drive', 'Daba', null, 24, 174);
insert into gym (username, password, email, phoneNum, name, streetAddress, city, state, capacity, currentCapacity) values ('ffragino3', '1b5pvy15', 'fbyne3@instagram.com', 1488940438, 'Kuvalis Inc', '58-31 Hello Ave', 'Mambi', null, 15, 191);
insert into gym (username, password, email, phoneNum, name, streetAddress, city, state, capacity, currentCapacity) values ('rburke4', 'urrOzV7', 'fwindrass4@canalblog.com', 4974078881, 'Schultz, Becker and Christiansen', '32 Database Drive', 'Puconci', null, 108, 154);

insert into event (eventID, description, name, streetAddress, city, state, calendarDate, startTime, endTime, hostGym, supervisorTrainer) values (1, 'Replacement of Left Iris with Nonaut Sub, Perc Approach', 'Romaguera and Sons', '03598 Bashford Avenue', 'Umm Sa‘īd', null, '2022-01-17', '3:20', '6:20', 'sgotthard0', 'dgehrels0');
insert into event (eventID, description, name, streetAddress, city, state, calendarDate, startTime, endTime, hostGym, supervisorTrainer) values (2, 'Drainage of Left Inferior Parathyroid Gland, Open Approach', 'Cummerata, Beier and Kerluke', '68325 American Ash Junction', 'Anle', null, '2021-11-27', '5:41', '11:03', 'cbaffin2', 'shardy2');
insert into event (eventID, description, name, streetAddress, city, state, calendarDate, startTime, endTime, hostGym, supervisorTrainer) values (3, 'Dilation of Abdominal Aorta, Bifurcation, Open Approach', 'Zemlak-Hansen', '88184 Clemons Lane', 'Labuhan', null, '2022-08-31', '10:39', '17:07', 'sgotthard0', null);
insert into event (eventID, description, name, streetAddress, city, state, calendarDate, startTime, endTime, hostGym, supervisorTrainer) values (4, 'Supplement L Fallopian Tube w Autol Sub, Perc Endo', 'Runolfsson, Parisian and Orn', '2 Morrow Point', 'Checca', null, '2022-04-18', '15:34', '23:23', 'sgotthard0', null);
insert into event (eventID, description, name, streetAddress, city, state, calendarDate, startTime, endTime, hostGym, supervisorTrainer) values (5, 'Removal of Nonaut Sub from Kidney, Open Approach', 'Jacobson, Larson and Hilll', '92 Thompson Way', 'Mizur', null, '2022-08-18', '23:00', '21:40', 'ffragino3', null);

insert into trainingSession (sessionID, description, cost, streetAddress, city, state, calendarDate, startTime, endTime, trainerUsername) values (1, null, 30.24, '29 Kingsford Lane', 'Oranzherei', null, '2022-05-25', '15:17', '4:28', 'hmcginny4');
insert into trainingSession (sessionID, description, cost, streetAddress, city, state, calendarDate, startTime, endTime, trainerUsername) values (2, 'Other specified injury of brachial artery', 38.4, '843 Stang Street', 'Pamakayo', null, '2022-04-06', '10:12', '6:12', 'jchampley3');
insert into trainingSession (sessionID, description, cost, streetAddress, city, state, calendarDate, startTime, endTime, trainerUsername) values (3, null, 24.22, '6 Barby Park', 'Qitan', null, '2022-08-24', '16:17', '17:15', 'jchampley3');
insert into trainingSession (sessionID, description, cost, streetAddress, city, state, calendarDate, startTime, endTime, trainerUsername) values (4, 'Disp fx of 2nd metatarsal bone, r ft, subs for fx w malunion', 12.53, '500 Ludington Terrace', 'Independencia', 'Guanajuato', '2022-09-17', '18:23', '18:49', 'dtew1');
insert into trainingSession (sessionID, description, cost, streetAddress, city, state, calendarDate, startTime, endTime, trainerUsername) values (5, null, 28.11, '251 Corscot Alley', 'Yamaguchi-shi', null, '2022-06-15', '14:40', '16:39', 'hmcginny4');

insert into exercises (name, description, safety, visual, isTimed, exerciseType) values ('Ziziphus reticulata (Vahl) DC.', 'Major contusion of spleen', 'Destruct conjunc les NEC', 'http://dummyimage.com/223x100.png/5fa2dd/ffffff', true, 'Seamless');
insert into exercises (name, description, safety, visual, isTimed, exerciseType) values ('Viola vallicola A. Nelson var. vallicola', null, 'Pass musculosk exer NEC', 'http://dummyimage.com/236x100.png/5fa2dd/ffffff', false, 'User-centric');
insert into exercises (name, description, safety, visual, isTimed, exerciseType) values ('Sesuvium L.', 'Oth injury due to oth accident on board merchant ship, subs', 'Bilat subq mammectom NEC', null, null, 'workforce');
insert into exercises (name, description, safety, visual, isTimed, exerciseType) values ('Orthotrichum bolanderi Sull.', 'Nondisp fx of lateral condyle of r tibia, 7thM', 'Repl pacem 1-cham, rate', null, true, '4th generation');
insert into exercises (name, description, safety, visual, isTimed, exerciseType) values ('Acer rubrum L.', null, 'Percu endosc jejunostomy', null, null, 'Implemented');

insert into memberGymInterests (memberUsername, interest) values ('wklisch0', 'a');
insert into memberGymInterests (memberUsername, interest) values ('kplues1', 'tempor');
insert into memberGymInterests (memberUsername, interest) values ('wklisch0', 'eget nunc donec quis orci');
insert into memberGymInterests (memberUsername, interest) values ('ebason2', 'pulvinar sed nisl');
insert into memberGymInterests (memberUsername, interest) values ('bburriss4', 'duis faucibus');

insert into memberSocialMedia (memberUsername, accountType, handle) values ('wklisch0', 'Tromp, Gorczany and Kertzmann', 'jsabbins0');
insert into memberSocialMedia (memberUsername, accountType, handle) values ('ebason2', 'Strosin LLC', 'aslowly1');
insert into memberSocialMedia (memberUsername, accountType, handle) values ('kplues1', 'Feeney-Bashirian', 'kdevenport2');
insert into memberSocialMedia (memberUsername, accountType, handle) values ('atrowler3', 'Kiehn Inc', 'ofawdery3');
insert into memberSocialMedia (memberUsername, accountType, handle) values ('atrowler3', 'Daniel LLC', 'kdublin4');

insert into availabilities (memberUsername, dayOfWeek, startTime, endTime) values ('atrowler3', 'Monday', '12:06', '17:52');
insert into availabilities (memberUsername, dayOfWeek, startTime, endTime) values ('wklisch0', 'Tuesday', '8:58', '17:18');
insert into availabilities (memberUsername, dayOfWeek, startTime, endTime) values ('kplues1', 'Wednesday', '14:18', '19:37');
insert into availabilities (memberUsername, dayOfWeek, startTime, endTime) values ('bburriss4', 'Thursday', '19:10', '14:47');
insert into availabilities (memberUsername, dayOfWeek, startTime, endTime) values ('ebason2', 'Friday', '19:33', '14:43');

insert into attendsEvent (eventID, memberUsername) values (1, 'atrowler3');
insert into attendsEvent (eventID, memberUsername) values (1, 'ebason2');
insert into attendsEvent (eventID, memberUsername) values (2, 'kplues1');
insert into attendsEvent (eventID, memberUsername) values (2, 'bburriss4');
insert into attendsEvent (eventID, memberUsername) values (3, 'bburriss4');

insert into workoutRoutine (name) values ('Acetaminophen');
insert into workoutRoutine (name) values ('Oxygen');
insert into workoutRoutine (name) values ('T-BUTYL ALCOHOL');
insert into workoutRoutine (name) values ('AVOBENZONE');
insert into workoutRoutine (name) values ('Famotidine');

insert into workoutCreated (workoutName, trainerUsername) values ('Acetaminophen', 'shardy2');
insert into workoutCreated (workoutName, trainerUsername) values ('Oxygen', 'dtew1');
insert into workoutCreated (workoutName, trainerUsername) values ('T-BUTYL ALCOHOL', 'dtew1');
insert into workoutCreated (workoutName, trainerUsername) values ('AVOBENZONE', 'shardy2');
insert into workoutCreated (workoutName, trainerUsername) values ('Famotidine', 'shardy2');

insert into workoutDone (workoutName, memberUsername, date, location) values ('Oxygen', 'bburriss4', '2022-06-29', null);
insert into workoutDone (workoutName, memberUsername, date, location) values ('Oxygen', 'atrowler3', '2022-06-1', null);
insert into workoutDone (workoutName, memberUsername, date, location) values ('Acetaminophen', 'bburriss4', '2022-04-29', null);
insert into workoutDone (workoutName, memberUsername, date, location) values ('Famotidine', 'wklisch0', '2022-04-18', '939 Sullivan Hill');
insert into workoutDone (workoutName, memberUsername, date, location) values ('Acetaminophen', 'atrowler3', '2022-04-22', null);

insert into attendsTraining (sessionID, memberUsername) values (2, 'ebason2');
insert into attendsTraining (sessionID, memberUsername) values (2, 'atrowler3');
insert into attendsTraining (sessionID, memberUsername) values (3, 'kplues1');
insert into attendsTraining (sessionID, memberUsername) values (5, 'wklisch0');
insert into attendsTraining (sessionID, memberUsername) values (3, 'atrowler3');

insert into trainerGymInterests (trainerUsername, interest) values ('dgehrels0', 'a');
insert into trainerGymInterests (trainerUsername, interest) values ('dgehrels0', 'tempor');
insert into trainerGymInterests (trainerUsername, interest) values ('shardy2', 'eget nunc donec quis orci');
insert into trainerGymInterests (trainerUsername, interest) values ('dtew1', 'pulvinar sed nisl');
insert into trainerGymInterests (trainerUsername, interest) values ('jchampley3', 'duis faucibus');

insert into trainerSocialMedia (trainerUsername, accountType, handle) values ('jchampley3', 'Tromp, Gorczany and Kertzmann', 'easteregg');
insert into trainerSocialMedia (trainerUsername, accountType, handle) values ('shardy2', 'Strosin LLC', 'whatisthis');
insert into trainerSocialMedia (trainerUsername, accountType, handle) values ('dtew1', 'Feeney-Bashirian', 'randomusernameegghaha');
insert into trainerSocialMedia (trainerUsername, accountType, handle) values ('shardy2', 'Kiehn Inc', 'wowisthisanotheruser');
insert into trainerSocialMedia (trainerUsername, accountType, handle) values ('hmcginny4', 'Daniel LLC', 'omgyetanotheruser');

insert into employedBy (gymUsername, trainerUsername) values ('cbaffin2', 'dgehrels0');
insert into employedBy (gymUsername, trainerUsername) values ('cbaffin2', 'shardy2');
insert into employedBy (gymUsername, trainerUsername) values ('cbaffin2', 'dtew1');
insert into employedBy (gymUsername, trainerUsername) values ('rburke4', 'jchampley3');
insert into employedBy (gymUsername, trainerUsername) values ('rburke4', 'hmcginny4');

insert into featuredIn (eventID, exerciseName) values (1, 'Ziziphus reticulata (Vahl) DC.');
insert into featuredIn (eventID, exerciseName) values (3, 'Viola vallicola A. Nelson var. vallicola');
insert into featuredIn (eventID, exerciseName) values (3, 'Acer rubrum L.');
insert into featuredIn (eventID, exerciseName) values (5, 'Viola vallicola A. Nelson var. vallicola');
insert into featuredIn (eventID, exerciseName) values (5, 'Ziziphus reticulata (Vahl) DC.');

insert into gymSchedule (gymUsername, dayOfWeek, startTime, endTime) values ('cbaffin2', 'Monday', '6:00', '14:43');
insert into gymSchedule (gymUsername, dayOfWeek, startTime, endTime) values ('sgotthard0', 'Tuesday', '6:43', '6:42');
insert into gymSchedule (gymUsername, dayOfWeek, startTime, endTime) values ('sgotthard0', 'Sunday', '5:22', '19:49');
insert into gymSchedule (gymUsername, dayOfWeek, startTime, endTime) values ('njancik1', 'Saturday', '11:53', '8:09');
insert into gymSchedule (gymUsername, dayOfWeek, startTime, endTime) values ('ffragino3', 'Friday', '8:34', '19:33');

insert into gymAmenities (gymUsername, facility) values ('ffragino3', 'Lempholemma chalazanum (Ach.) de Lesd.');
insert into gymAmenities (gymUsername, facility) values ('ffragino3', 'Heuchera parvifolia Nutt. ex Torr. & A. Gray var. microcarpa Rosend., Butters & Lakela');
insert into gymAmenities (gymUsername, facility) values ('sgotthard0', 'Stachys rigida Nutt. ex Benth. var. rigida');
insert into gymAmenities (gymUsername, facility) values ('cbaffin2', 'Deschampsia holciformis J. Presl');
insert into gymAmenities (gymUsername, facility) values ('rburke4', 'Euphorbia segetalis L.');

insert into likes (memberUsername, exerciseName, pr) values ('bburriss4', 'Sesuvium L.', 187);
insert into likes (memberUsername, exerciseName, pr) values ('wklisch0', 'Orthotrichum bolanderi Sull.', 144);
insert into likes (memberUsername, exerciseName, pr) values ('bburriss4', 'Orthotrichum bolanderi Sull.', 159);
insert into likes (memberUsername, exerciseName, pr) values ('wklisch0', 'Sesuvium L.', 156);
insert into likes (memberUsername, exerciseName, pr) values ('kplues1', 'Sesuvium L.', 111);

insert into workoutContains (workoutName, exerciseName, sets, reps, repTime, restTime) values ('Acetaminophen', 'Sesuvium L.', 8, 6, 10, 7);
insert into workoutContains (workoutName, exerciseName, sets, reps, repTime, restTime) values ('Oxygen', 'Sesuvium L.', 7, 9, 6, 7);
insert into workoutContains (workoutName, exerciseName, sets, reps, repTime, restTime) values ('Acetaminophen', 'Orthotrichum bolanderi Sull.', 8, 5, 10, 6);
insert into workoutContains (workoutName, exerciseName, sets, reps, repTime, restTime) values ('T-BUTYL ALCOHOL', 'Acer rubrum L.', 10, 10, 5, 5);
insert into workoutContains (workoutName, exerciseName, sets, reps, repTime, restTime) values ('Oxygen', 'Viola vallicola A. Nelson var. vallicola', 2, 8, 9, 6);

insert into targetMuscles (exerciseName, muscleGroup) values ('Viola vallicola A. Nelson var. vallicola', 'Ara macao');
insert into targetMuscles (exerciseName, muscleGroup) values ('Acer rubrum L.', 'Alcelaphus buselaphus cokii');
insert into targetMuscles (exerciseName, muscleGroup) values ('Orthotrichum bolanderi Sull.', 'Sciurus niger');
insert into targetMuscles (exerciseName, muscleGroup) values ('Sesuvium L.', 'Chlidonias leucopterus');
insert into targetMuscles (exerciseName, muscleGroup) values ('Ziziphus reticulata (Vahl) DC.', 'Platalea leucordia');