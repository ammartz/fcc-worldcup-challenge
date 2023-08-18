#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat ./games.csv | while IFS=',' read -r YEAR ROUND WINNER OPPO W_GOALS O_GOALS
do
#Eleminate first row
if [[ $YEAR != 'year' ]]
then
#Get team id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
#If not found
if [[ -z $WINNER_ID ]]
then
echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
fi

OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPO'")
#If not found
if [[ -z $OPPO_ID ]]
then
echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPO')")
OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPO'")
fi


echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND',$WINNER_ID,$OPPO_ID, $W_GOALS, $O_GOALS)")
fi
done 
