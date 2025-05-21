import argparse as arg
import re
import pandas as pd



def id2name(input_file, output_file=None):
    
    chromosome_pattern = re.compile(r"chromosome (\d+)", re.IGNORECASE)
    mitochondrion_pattern = re.compile(r"mitochondrion", re.IGNORECASE)
    scaffold_pattern = re.compile(r"unplaced.*scaffold", re.IGNORECASE)

    mapping = []

    # read the fastq file and check all headers
    with open(input_file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if line.startswith('>'):
                parts = line.strip().split()
                seq_id = parts[0][1:]
                header_info = " ".join(parts[1:])
                if mitochondrion_pattern.search(header_info):
                    chromosome = "MT"
                    category = "Mitochondrion"
                elif scaffold_pattern.search(header_info):
                    chromosome = "Unplaced"
                    category = "Unplaced"
                elif math := chromosome_pattern.search(header_info):
                    chromosome = math.group(1)
                    category = "Chromosome"
                else:
                    chromosome = "Unknown"
                    category = "Unknown"

                mapping.append((seq_id, chromosome, category))
    
    df = pd.DataFrame(mapping, columns=['SeqID', 'Chromosome', 'Category'])
    if output_file:
        df.to_csv(output_file, sep='\t', index=False)
    else:
        print(df)
    return df




def main(args):
    
    if args.output:
        id2name(args.input, args.output)
    else:
        id2name(args.input)
    

if __name__ == "__main__":
    parser = arg.ArgumentParser(description='Summarize the mapping result')
    
    parser.add_argument('-i', '--input', required=True,type=str, help='Input whole genome fasta file')
    
    parser.add_argument('-o', '--output', type=str, help='sequence id to readable chromsome number')
    args = parser.parse_args()
    main(args)