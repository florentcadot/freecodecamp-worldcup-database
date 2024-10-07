# Worldcup database

A freecodecamp project to practice some SQL.
I've done it locally using a postgres docker container.

Here are some useful commands:

````bash
# Start the container
docker run --name postgres-freecodecamp -p 5432:5432 -e POSTGRES_USER=florent -e POSTGRES_PASSWORD=mysecretpassword -d postgres:16-alpine

# Connect to psql
docker exec -it postgres-freecodecamp psql -U florent -d postgres

# Run PSQL command from local bash script 
docker exec postgres-freecodecamp psql -U florent --dbname=worldcup -t --no-align -c "INSERT INTO teams(name) VALUES('France');"
````

.. and the SQL queries I've used to set up the DB:

````sql
CREATE DATABASE worldcup;
\c worldcup
CREATE TABLE teams(team_id SERIAL PRIMARY KEY, name VARCHAR(100) UNIQUE NOT NULL);
CREATE TABLE games(game_id SERIAL PRIMARY KEY, year INT NOT NULL, round VARCHAR(100) NOT NULL, winner_id INT NOT NULL, opponent_id INT NOT NULL, winner_goals INT NOT NULL, opponent_goals INT NOT NULL);
ALTER TABLE games ADD CONSTRAINT fk_games_winner FOREIGN KEY (winner_id) REFERENCES teams(team_id);
ALTER TABLE games ADD CONSTRAINT fk_games_opponent FOREIGN KEY (opponent_id) REFERENCES teams(team_id);
````