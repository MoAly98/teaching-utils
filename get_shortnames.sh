#!bin/bash

ASSIGN_NUM=$1 # The assignment number (1 or 2)
DIR=$2 # The directory downloaded from blackboard
LEN_UID=8 # UID length

if [[ "$DIR" == "" ]]
then
    echo $DIR
    DIR="./"
fi

echo "Looking for assignments in $DIR"

if [[ $ASSIGN_NUM == 1 ]]; then
    IDENTIFIER="First"
    START_IDX=35
else
    if [[ $ASSIGN_NUM != 2 ]]; then
        echo "Assignment number must be 1 or 2"
        break
    fi
    IDENTIFIER="Final"
    START_IDX=32
fi

echo "Your are shortening the names of Assignment $ASSIGN_NUM"
echo "Assignment Identifier: $IDENTIFIER"
echo "Assignment Preamble Length: $START_IDX"
echo "UID Expected Length after preamble: $LEN_UID"

CURRENT_DIR=$PWD
cd $DIR
ls -1 "$IDENTIFIER"*.py | awk -v START_IDX="$START_IDX" -v LEN_UID="$LEN_UID" '{print("cp \""$0"\" "substr($0,START_IDX,LEN_UID)"_ip.py")}' > shorten.sh; chmod +x shorten.sh ;
./shorten.sh
rm xx.sh

echo "Copying over to $DIR/shortnames/"
mkdir -p shortnames/
mv *_ip.py shortnames/
cd $CURRENT_DIR

