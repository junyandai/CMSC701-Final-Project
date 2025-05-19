import os
import csv
import argparse
import sys

def escape_latex(s):
    """Escape underscores for LaTeX."""
    return s.replace('_', '\\_')

def process_trio_csv(file_path):
    rows = []
    with open(file_path, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row['chrom'].startswith("SUMMARY") or row['chrom'] == '':
                continue
            rows.append(row)
    return rows

def generate_per_trio_tables(trio_data):
    for trio, rows in trio_data.items():
        if not rows:
            continue

        sys.stdout.write("\\begin{table}[!h]\n")
        sys.stdout.write(f"\\caption{{\\textbf{{CNV calls in {trio} child.}} CNVs are shown with genotypes estimated by CNVkit by copy number and Mendelian consistency status.}}\n")
        sys.stdout.write(f"\\label{{tab:{trio.lower()}-cnv}}\n")
        sys.stdout.write("\\centering\n")
        sys.stdout.write("\\scriptsize\n")
        sys.stdout.write("\\begin{tabular}{c c c c c c}\n")
        sys.stdout.write("\\toprule\n")
        sys.stdout.write("Chrom & Start & End & CNV type & GT & Status \\\\\n")

        for row in rows:
            chrom = escape_latex(row['chrom'])
            start = row['start']
            end = row['end']
            svtype = row['svtype']
            gt = row['gt']
            status = row['mendelian_status']
            sys.stdout.write(f"{chrom} & {start} & {end} & {svtype} & {gt} & {status} \\\\\n")


        sys.stdout.write("\\bottomrule\n")
        sys.stdout.write("\\end{tabular}\n")
        sys.stdout.write("\\end{table}\n\n")

def main(input_dir):
    trios = ["Trio1", "Trio2", "Trio3", "Trio4"]
    trio_data = {}

    for trio in trios:
        csv_path = os.path.join(input_dir, trio, "mendelian_consistency.csv")
        if not os.path.exists(csv_path):
            print(f"[!] Missing: {csv_path}", file=sys.stderr)
            trio_data[trio] = []
            continue
        trio_data[trio] = process_trio_csv(csv_path)

    generate_per_trio_tables(trio_data)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate LaTeX tables per trio from CNV consistency CSVs.")
    parser.add_argument("--input-dir", required=True, help="Directory containing trio folders with mendelian_consistency.csv files")
    args = parser.parse_args()

    main(args.input_dir)
