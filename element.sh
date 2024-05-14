PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
SYMBOL=$1

# Function to display data
display_data() {
  echo "$1" | while read BAR BAR NUMBER BAR SYMBOL BAR NAME BAR WEIGHT BAR MELTING BAR BOILING BAR TYPE
  do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
}

# Check if SYMBOL argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  SYMBOL=$1
  # Determine if input is a number, symbol, or name
  if [[ ! $SYMBOL =~ ^[0-9]+$ ]]
  then
    # Check the length of the input to determine if it's a symbol or name
    LENGTH=$(echo -n "$SYMBOL" | wc -m)
    if [[ $LENGTH -gt 2 ]]
    then
      # Input is a name, query by full name
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE name='$SYMBOL'")
    else
      # Input is a symbol, query by symbol
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$SYMBOL'")
    fi
  else
    # Input is a number, query by atomic number
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$SYMBOL")
  fi

  # Check if data is found and display it
  if [[ -z $DATA ]]
  then
    echo "I could not find that element in the database."
  else
    display_data "$DATA"
  fi
fi
