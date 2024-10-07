#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

FILENAME=./games.csv

echo -e "\nInserting teams and games from $FILENAME\n"

function insertTeamByName() {
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1';")
  if [[ -z $TEAM_ID ]]; then 
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$1');")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]; then 
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$1';")
    fi
  fi
  echo $TEAM_ID
} 

{
read
while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    # teams
    WINNER_ID=$(insertTeamByName "$WINNER") 
    OPPONENT_ID=$(insertTeamByName "$OPPONENT") 

    # games
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year='$YEAR' AND round='$ROUND' AND winner_id='$WINNER_ID' AND opponent_id='$OPPONENT_ID';")
    if [[ -z $GAME_ID ]]; then
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    fi

    echo "$WINNER (team_id=$WINNER_ID) win against $OPPONENT (team_id=$OPPONENT_ID) in $ROUND (game_id=$GAME_ID)"

  done
} < $FILENAME
