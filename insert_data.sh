#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read  YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 if [[ $YEAR != 'year' ]]
 then
    TEAM_ID_AS_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_AS_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
   
      if [[ -z $TEAM_ID_AS_WINNER ]]
      then
        INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
        TEAM_ID_AS_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        echo INSERTED WINNER, $TEAM_ID_AS_WINNER
      fi
      if [[ -z $TEAM_ID_AS_OPPONENT ]]
      then
        INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        TEAM_ID_AS_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        echo INSERTED OPPONENT, $TEAM_ID_AS_OPPONENT
      fi

      GAMES_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id=$TEAM_ID_AS_WINNER AND opponent_id=$TEAM_ID_AS_OPPONENT")
      echo $GAMES_ID
      if [[ -z $GAMES_ID ]]
      then
        INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$TEAM_ID_AS_WINNER,$TEAM_ID_AS_OPPONENT,$WINNER_GOALS,$OPPONENT_GOALS)")
        #GAMES_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id=$TEAM_ID_AS_WINNER AND opponent_id=$TEAM_ID_AS_OPPONENT")
        echo INSERTED GAME
      fi
    
 fi 
done