#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE_TABLE=$($PSQL "TRUNCATE TABLE teams, games")



#insertar tabla teams
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER != 'winner' && $OPPONENT != 'opponent' && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
    then
    #chequear si existe el winner en la tabla equipos
    CHECK_WINNER=$($PSQL "select * from teams where name='$WINNER'")
    #si no existe
    if [[ -z $CHECK_WINNER ]]
      then
      #insertar equipo en la tabla
      INSERTAR_EQUIPO=$($PSQL "insert into teams(name) values('$WINNER')")
      fi
    #chequear si existe opponent en la tabla equipos
    CHECK_OPPONENT=$($PSQL "select * from teams where name='$OPPONENT'")
    #si no existe
    if [[ -z $CHECK_OPPONENT ]]
      then
      #insertar equipo en la tabla
      INSERTAR_EQUIPO=$($PSQL "insert into teams(name) values('$OPPONENT')")
      fi
  fi
done

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER != 'winner' && $OPPONENT != 'opponent' && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
    then
    #conseguir winner_id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    #conseguir opponent_id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    #insertar en tabla games
    INSERT_INTO_GAMES=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
  fi
done