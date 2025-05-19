import os
import csv
import argparse
import sys
import pandas as pd





def main(args):
    input_csv = args.input
    df = pd.read_csv(input_csv)

    # extract rows from df 
    summary_rows = df.to_dict(orient='records')
    
    sys.stdout.write("\\begin{table}[!h]\n")
    sys.stdout.write("\\caption{\\textbf{Mendelian inconsistency summary for on H. zea trios.} ")
    sys.stdout.write("Each row shows the total number of CNVs, consistent and inconsistent CNVs, and the Mendelian inconsistency rate (MIR).}\n")
    sys.stdout.write("\\label{tab:mir-summary}\n")
    sys.stdout.write("\\centering\n")
    sys.stdout.write("\\tiny\n")
    sys.stdout.write("\\begin{tabular}{c c c c c c}\n")
    sys.stdout.write("\\toprule \n")
    sys.stdout.write("Trio & Method & Total CNVs & Consistent & Inconsistent & MIR \\\\\n")
    sys.stdout.write("\\midrule\n")
    
    for row in summary_rows:
        sys.stdout.write(f"{row['trio']} & {row['method']} & {row['total_cnvs']} & {row['consistent']} & {row['inconsistent']} & {row['mir']} \\\\\n")


    sys.stdout.write("\\bottomrule\n")
    sys.stdout.write("\\end{tabular}\n")
    sys.stdout.write("\\end{table}\n")

















if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="generate latex table for MIR.")
    parser.add_argument("-i", "--input", required=True, help="Input CSV file.")
    args = parser.parse_args()

    main(args)
