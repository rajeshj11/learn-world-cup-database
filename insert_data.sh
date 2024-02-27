#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

i=1
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[ i -ne 1 ]]; then
    WINNER_ID="$($PSQL "select team_id from teams where name='$winner'")"
    if [[ -z $WINNER_ID ]]; then
     ($PSQL "insert into teams (name) values('$winner')")
      WINNER_ID="$($PSQL "select team_id from teams where name='$winner'")"
    fi
    OPPONENT_ID="$($PSQL "select team_id from teams where name='$opponent'")"
    if [[ -z $OPPONENT_ID ]]; then
    ($PSQL "insert into teams (name) values('$opponent')")
     OPPONENT_ID="$($PSQL "select team_id from teams where name='$opponent'")"
    fi
    ($PSQL "insert into games (year, winner_id,opponent_id, winner_goals,opponent_goals,round) values($year,$WINNER_ID, $OPPONENT_ID,$winner_goals,$opponent_goals,'$round')")
  fi
  (( i++ ))
done
