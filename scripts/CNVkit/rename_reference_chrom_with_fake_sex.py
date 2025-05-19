#!/usr/bin/env python

import argparse
import csv

def load_mapping(mapping_file, sex_chrom_name):
    id_map = {}
    with open(mapping_file) as f:
        reader = csv.DictReader(f, delimiter="\t")
        for row in reader:
            seqid = row["SeqID"]
            chrom = row["Chromosome"]
            category = row["Category"]

            if category == "Chromosome":
                if chrom == "31":
                    id_map[seqid] = sex_chrom_name
                else:
                    id_map[seqid] = chrom
            elif category == "Unplaced":
                id_map[seqid] = f"unplaced_scaffold_{seqid}"
            elif category == "Mitochondrion":
                id_map[seqid] = "MT"
    return id_map

def rename_fasta(input_fasta, output_fasta, id_map):
    with open(input_fasta) as fin, open(output_fasta, "w") as fout:
        for line in fin:
            if line.startswith(">"):
                seqid = line[1:].strip().split()[0]
                new_id = id_map.get(seqid, seqid)
                fout.write(f">{new_id}\n")
            else:
                fout.write(line)

def main():
    parser = argparse.ArgumentParser(description="Rename FASTA headers to match renamed BAM sequence IDs.")
    parser.add_argument("--map", required=True, help="Path to the sequence ID mapping TSV file.")
    parser.add_argument("--in", dest="input_fasta", required=True, help="Input FASTA file.")
    parser.add_argument("--out", dest="output_fasta", required=True, help="Output FASTA file with renamed headers.")
    parser.add_argument("--sex-chrom-name", default="Z", help="New name for chromosome 31 (default: Z, use X to match CNVkit expectations).")

    args = parser.parse_args()
    id_map = load_mapping(args.map, args.sex_chrom_name)
    rename_fasta(args.input_fasta, args.output_fasta, id_map)

if __name__ == "__main__":
    main()
