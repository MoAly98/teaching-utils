#!bin/bash

ASSIGN_NUM=$1 # The assignment number (1 or 2)
DIR=$2 # The directory downloaded from blackboard
UID_LENGTH=$3

if [[ "$DIR" == "" ]]
then
    echo $DIR
    DIR="./"
fi

if [[ "$UID_LENGTH" == "" ]]; then
    UID_LENGTH=5
    echo Assuming usernames have $UID_LENGTH numbers in them
fi

echo "Looking for assignments in $DIR"

if [[ $ASSIGN_NUM == 1 ]]; then
    IDENTIFIER="First"
else
    if [[ $ASSIGN_NUM != 2 ]]; then
        echo "Assignment number must be 1 or 2"
        break
    fi
    IDENTIFIER="Final"
fi

echo "Your are shortening the names of Assignment $ASSIGN_NUM"
echo "Assignment Identifier: $IDENTIFIER"

CURRENT_DIR=$PWD
echo "Current directory $CURRENT_DIR"

cd $DIR
ls -1 "$IDENTIFIER"*.py | awk 'match($0,/[a-z][0-9]{'"$UID_LENGTH"'}[a-z]{2}/){ print("cp \""$0"\" "substr($0, RSTART, RLENGTH)"_ip.py") }' > shorten.sh; chmod +x shorten.sh ;

./shorten.sh
rm shorten.sh

echo "Copying over to $DIR/shortnames/"
mkdir -p shortnames/
mv *_ip.py shortnames/
cd $CURRENT_DIR

