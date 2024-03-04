# Utilities for Teaching Intro to Python course UoM

## Get this code

You can get code by simply running `git clone` for this repository or downloading the scripts manually.

## Downloading from Blackboard

You should start by downloading assignment files for all students from blackboard.

1. Grade Centre -> Full Grade Centre
2. Find the column for your assignment and press on gray arrow
3. Choose `Assignment File Download`
4. Scroll down to `SELECT FILES` and choose `All attempt files`
5. Scroll up and select all students
6. Press `Submit`


This will download a directory with the assignment scripts for *All* students on the course.

## Shortening names

The assignment files will have very long names. We only care about the username, which is somewhere along the long strings.
To shorten the names you should run the script `get_shortnames.sh` as follows:

```
source get_shortnames.sh <ASSIGN_NUM> <DIRECTORY>
```

where

- `<ASSIGN_NUM>` is either 1 or 2; if 1, will look for python scripts starting with `First` in the long names, otherwise will look for `Final`

- `<DIRECTORY>` is the path to the folder containing the long-name files (the one you downloaded from blackboard).

This will create a folder `<DIRECTORY>/shortnames/` containing files shortened to `<username>_ip.py`.

The username is assumed to be 1 letter + 5 digits + 2 letters. You can adjust the number of digits to `N` by adding a 3rd argument to the code with

```
source get_shortnames.sh <ASSIGN_NUM> <DIRECTORY> N
```


If the username structure changes completely, or you want to reuse this in another case, the relevant code to adjust is
```
/[a-z][0-9]{'"$UID_LENGTH"'}[a-z]{2}/
```

## Getting your assignments in a separate folder

Once you have a folder with files called `<username>_ip.py`, the next step is to filter these to get the assignments you need to mark. I will assume these are split into 2 groups: primary and secondary.

1- Copy the list of usernames from marking sheet for each group into a separate file (`primary.txt` and `secondary.txt`)
2- Run the `get_my_assign.sh` code with

    ```
    source get_my_assign.sh primary.txt <INDIR> <OUTDIR>/primary/
    source get_my_assign.sh secondary.txt <INDIR> <OUTDIR>/secondary/
    ```

    where `INDIR` is the directory containing the scripts with shortened names and `OUTDIR` is the directory to which scripts from each group should go.


## Quick feedback construction

To be able to write feedback more quickly, I find that the best method involves compiling a list of common feedback comments in a text file and reuse combinations of these comments for each student. Compiling the list may take some time as you have to mark some students to build it up, but after a few students you will find the mistakes repeat and you the comments can be reused.

I set up a straightforward workflow to be able to compile feedback quickly for all students, and it goes like:

- Make a `feedback.txt` file and start giving a code per quote, for example:

    ```
    # Calculation

    C1. The code does not do calculation correctly.. .
    C2. some other comemnt

    # Plotting

    P1. Plots can be better....

    ```

    with the only rules being:
    - `#` for commented lines
    - Comment codes must be: `1 letter + N digits + "." (full stop)`

- As you are marking students on the spreadsheet, simply put in the comments section (last column) the codes corresponding to the quote you wanted to give to this student, followed by "|" as separator, for example:
    ```
    C1|C2|C3|P2|
    ```
- If you have an extra comment you want to make that has no code (e.g. specific to the student, just type it out between `|` separators), for example:
    ```
    C1|C2|C3|P2|This particular script has some problem, maybe multiple|
    ```

- When you are done marking, download the spreadsheet and run the script `get_feedback.py`:
    ```
    python3 get_feedback.py -f `feedback.txt` -s `<path_to_spreadsheet>`  -n `<last_name>` -r `<first_row>` `<second_row>` -c `<comments_column>` -o <output_directory_for_feedback>
    ```
    where the settings are explained as follows:
    -  `path_to_spreadsheet`:  full path to the spreadsheet you downloaded
    -  `last_name`: your last name as used in the spreadsheet to be able to retrieve your marking sheet
    - `first_row` and `last_row`: The number of the first and last rows containing a primary student in the sheet (ones for which you need to give feedback)
    - `comments_column`: The column name which contains the feedback codes as explained above
    - `output_directory_for_feedback`: a directory to which the feedback per student should be dumped


The output of the last step will be a directory containing one text file per username, where the content of that text file is your feedback stiched together, ready to be posted online!


## Faster uploading to blackboard

Once you are ready to upload your marks, you can use blackboard smart views to upload your mark and feedbacks a bit faster than searching for your students' username in a list of 300 students...

1. Grade Centre -> Full Grade Centre
2. Manage -> Smart Views
3. Create Smart View
4. Choose name that reflects who you are (last name) and which assignment is this (1 or 2) -- You may also want to have 2 smart views, one for primary and one for secondary.
5. Go to `Selection Criteria` field and choose `custom`
6. Change `User Criteria` to `Username` and add one student's username in the `Value` field
7. Press `Add User Criteria` and repeat for all your students
8. When done go to `Formula Editor` section and press `Manually Edit`. Change each `AND` to `OR`.
9. In `Filter Results` section, use drop-down menu to choose `All Columns`
10. Press `Submit`


Now if you click on the smart view you created, you will only see your students and you will be able to just click through your students in order to upload your marks and feedback.


