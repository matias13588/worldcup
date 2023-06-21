#! /bin/bash

if [[ $1 == "test" ]]
then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
    PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Script to insert data from games.csv into worldcup database

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    # Insert winning teams into teams table
    # Ignore first row from csv file
    if [[ $WINNER != "winner" ]]
    then
        # Get team_id
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        # If not found
        if [[ -z $TEAM_ID ]]
        then
            # Insert team
            INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
            if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
            then
                echo Inserted team into teams table, $WINNER
            fi
            # Get new team_id
            TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        fi
    fi

    # Insert opponent teams into teams table
    # Ignore first row from csv file
    if [[ $OPPONENT != "opponent" ]]
    then
        # Get team_id
        TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        # If not found
        if [[ -z $TEAM_ID ]]
        then
            # Insert team
            INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
            if [[ $INSERT_TEAM_RESULTO = "INSERT 0 1" ]]
            then
                echo Inserted team into teams table, $OPPONENT
            fi
            # Get new team_id
            TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        fi
    fi

    # Insert games data into games table
    # Ignore first row from csv file
    if [[ $YEAR != "year" ]]
    then
        # Get team_id from winning team
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        # Get team_id from opponent team
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        # Insert data to the games table
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
        if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then
            echo "Game inserted into games table, $ROUND | $WINNER - $OPPONENT"
        fi
    fi
done