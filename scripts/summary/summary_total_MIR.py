import os
import csv
import argparse
import sys

def parse_summary_line(summary_line):
    """
    Parse a SUMMARY line from the per-trio CSV file.
    Example:
    SUMMARY,Total CNVs: 12,Consistent: 8,Inconsistent: 4,,,Inconsistent rate: 0.3333
    """
    fields = summary_line.strip().split(',')
    total = int(fields[1].split(':')[1].strip())
    consistent = int(fields[2].split(':')[1].strip())
    inconsistent = int(fields[3].split(':')[1].strip())
    rate = float(fields[6].split(':')[1].strip())
    return total, consistent, inconsistent, rate



def summarize_directory(input_dir, output_csv, input_csv_file, method):
    summary_rows = []

    trios= [ "Trio1", "Trio2", "Trio3", "Trio4"]
    
    
    
    for trio in trios:

        cur_path = os.path.join(input_dir, trio)
        
        cur_MIR_file = os.path.join(cur_path, input_csv_file)

        with open(cur_MIR_file, 'r') as f:
            lines = f.readlines()
            for line in reversed(lines):
                if line.startswith("SUMMARY"):
                    total, consistent, inconsistent, rate = parse_summary_line(line)
                    summary_rows.append({
                        'trio': trio,
                        'method': method,
                        'total_cnvs': total,
                        'consistent': consistent,
                        'inconsistent': inconsistent,
                        'mir': round(rate, 4)
                    })
                    break

    with open(output_csv, 'w', newline='') as out:
        writer = csv.DictWriter(out, fieldnames=['trio', 'method','total_cnvs', 'consistent', 'inconsistent', 'mir'])
        writer.writeheader()
        for row in summary_rows:
            writer.writerow(row)
    
    # sys.stdout.write("\\begin{table}[!h]\n")
    # sys.stdout.write("\\caption{\\textbf{Mendelian inconsistency summary for CNVkit on H. zea trios.} ")
    # sys.stdout.write("Each row shows the total number of CNVs, consistent and inconsistent CNVs, and the Mendelian inconsistency rate (MIR).}\n")
    # sys.stdout.write("\\label{tab:mir-summary}\n")
    # sys.stdout.write("\\centering\n")
    # sys.stdout.write("\\tiny\n")
    # sys.stdout.write("\\begin{tabular}{c c c c}\n")
    # sys.stdout.write("\\toprule \n")
    # sys.stdout.write("Trio & Method & Total CNVs & Consistent & Inconsistent & MIR \\\\\n")
    # sys.stdout.write("\\midrule\n")
    
    # for row in summary_rows:
    #     sys.stdout.write(f"{row['trio']} & {row['method']} & {row['total_cnvs']} & {row['consistent']} & {row['inconsistent']} & {row['mir']} \\\\\n")


    # sys.stdout.write("\\bottomrule\n")
    # sys.stdout.write("\\end{tabular}\n")
    # sys.stdout.write("\\end{table}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Summarize MIR metrics from per-trio CSVs.")
    parser.add_argument("--input-dir", required=True, help="Directory containing per-trio csv files")
    parser.add_argument("--output", required=True, help="Path to output summary CSV")
    parser.add_argument("--input", required=True, help="input csv files")
    parser.add_argument("--method", required=True, help="method used for CNV calling")
    args = parser.parse_args()

    summarize_directory(args.input_dir, args.output, args.input, args.method)
