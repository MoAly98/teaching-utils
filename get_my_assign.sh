YOUR_UID_LIST=$1
INDIR=$2
OUTDIR=$3

 if [[ "$INDIR" == "" ]]; then
    INDIR="./"
    echo "looking for python scripts in directory: $INDIR"
 fi

 if [[ "$OUTDIR" == "" ]]; then
     OUTDIR="./"
     echo "Dumping python scripts for your students in directory: $OUTDIR/myassign/"
fi

mkdir -p $OUTDIR/myassign/
echo "Looking for usernames in file $YOUR_UID_LIST"

while read uid; do

    STUDENT_FILE="$INDIR/$uid"_ip.py
    echo Looking for file: "$uid"_ip.py
    # If UID file not found
    if [ ! -f $STUDENT_FILE ]; then
        # Check if file already been processed in a previous round
        if [ ! -f $OUTDIR/myassign/$STUDENT_FILE ]; then
            echo "$STUDENT_FILE not found in current directory and $OUTDIR/myassign/!"
        else
            echo "$STUDENT_FILE already in $OUTDIR/myassign/"
        fi
    else
        echo "Copying $STUDENT_FILE to $OUTDIR/myassign/"
        cp "$STUDENT_FILE" $OUTDIR/myassign/
    fi
done < <(grep '' $YOUR_UID_LIST)
