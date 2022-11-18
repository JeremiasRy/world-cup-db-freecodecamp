#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
  if [[ $YEAR != "year" ]]
  then
    #lets process
    WINNERINDB=$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")
    OPPONENTINDB=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")
    if [[ -z $WINNERINDB ]]
    then
      WINNER_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $WINNER_INSERT_RESULT == "INSERT 0 1" ]]
      then 
        echo "Inserted $WINNER to teams"
      fi
    fi
    if [[ -z $OPPONENTINDB ]]
    then
      OPPONENT_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $OPPONENT_INSERT_RESULT == "INSERT 0 1" ]]
      then 
        echo "Inserted $OPPONENT to teams"
      fi
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then 
      echo "Inserted game $YEAR $ROUND $WINNER versus $OPPONENT with a score of $WINNER_GOALS - $OPPONENT_GOALS"
    fi
  fi
  done
