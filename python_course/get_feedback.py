import xlwings as xw
import re
import argparse
import os

def argparser():
    parser = argparse.ArgumentParser()
    parser.add_argument("-f",   help="Feedback definitions")
    parser.add_argument("-s",   help="spreadsheet path")
    parser.add_argument("-r",   nargs=2, help="First and last row number with your primary students")
    parser.add_argument("-n",  type=str, help="Your last name to get the correct sheet")
    parser.add_argument("-c",  help="The sheet column containing your feedback codes")
    parser.add_argument("-o",  help="The outputd directory to dump feedbacks")
    return parser.parse_args()

def main():
    args = argparser()
    feedback_file = args.f
    xlsx = args.s
    first_row, last_row = args.r
    sheet = args.n
    feedback_col = args.c
    outdir = args.o

    os.makedirs(outdir, exist_ok=True)

    # Reed feedback MD:

    with open(feedback_file, "r") as f:
        lines = f.readlines()

    feedback_descriptions = []
    in_a_feedback = False
    feedback = ''
    for line in lines:
        if "#" in  line:   continue
        if re.match('^[A-Z]\d*\.', line) is not None:
            if feedback != '':
                feedback_descriptions.append(feedback)
            feedback = ''
            feedback += line
        else:
            feedback += line


    # Specifying a sheet
    ws = xw.Book(xlsx).sheets[sheet]

    # Selecting data from
    # a single cell

    students = ws.range(f"A{first_row}:A{last_row}").value
    feedback = ws.range(f"{feedback_col}{first_row}:{feedback_col}{last_row}").value

    for student, feedback in zip(students, feedback):
        if feedback is None:
            print(f"Could not find feedback for {student}, skipping")
            continue
        feedbackpoints = feedback.split("|")
        with open(f'{outdir}/{student}.txt', 'w') as outf:
            for feedback_pt in feedbackpoints:
                feedback_pt_stripped = feedback_pt.strip()
                for descript in feedback_descriptions:
                    feedback_pt_found_in_feedback_defs = re.match(feedback_pt_stripped.replace("*","\*"), descript)
                    if feedback_pt_stripped+"." in descript:
                        outf.write("- "+descript.replace(feedback_pt_stripped+".","").rstrip()+'\n\n')

                    elif re.match("^[A-Z][0-9]+", feedback_pt_stripped) is not None:
                        # If this is a comment code that does not match current description, move on to next description
                        continue

                    else:
                        #If this is not a comment code and instead is an actual comment text, write it as it is
                        outf.write("- "+feedback_pt.rstrip()+'\n\n')
                        break
if __name__ == "__main__":
    main()
