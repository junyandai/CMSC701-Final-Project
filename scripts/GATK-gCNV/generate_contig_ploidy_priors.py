#!/usr/bin/env python3

import argparse
import pysam
import csv
import sys

def generate_ploidy_priors(reference_fasta, output_tsv, z_chrom_name):
    try:
        fasta = pysam.FastaFile(reference_fasta)
    except Exception as e:
        sys.stderr.write(f"Error opening reference FASTA file: {e}\n")
        sys.exit(1)

    contig_names = fasta.references

    autosome_priors = [0.01, 0.01, 0.97, 0.01]
    z_chrom_priors  = [0.01, 0.49, 0.49, 0.01]
    mt_priors       = [0.01, 0.98, 0.01, 0.00]

    mt_names = {'MT', 'M', 'CHRMT', 'CHRM'}

    try:
        with open(output_tsv, 'w', newline='') as tsvfile:
            writer = csv.writer(tsvfile, delimiter='\t')
            writer.writerow([
                'CONTIG_NAME',
                'PLOIDY_PRIOR_0',
                'PLOIDY_PRIOR_1',
                'PLOIDY_PRIOR_2',
                'PLOIDY_PRIOR_3'
            ])
            for contig in contig_names:
                contig_upper = contig.upper()
                if contig == z_chrom_name:
                    priors = z_chrom_priors
                elif contig_upper in mt_names:
                    priors = mt_priors
                else:
                    priors = autosome_priors
                writer.writerow([contig] + priors)
    except Exception as e:
        sys.stderr.write(f"Error writing TSV file: {e}\n")
        sys.exit(1)

def main(args):
    generate_ploidy_priors(args.reference, args.output, args.zchrom)

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description="Generate GATK-style contig ploidy priors TSV file.")
    
    parser.add_argument(
        "-r", "--reference",
        required=True,
        help="Path to reference genome FASTA file (must be indexed with .fai)"
    )
    parser.add_argument(
        "-o", "--output",
        required=True,
        help="Output TSV path for contig ploidy priors"
    )
    parser.add_argument(
        "-z", "--zchrom",
        required=True,
        help="Z chromosome contig name (must match exactly)"
    )

    args = parser.parse_args()
    
    main(args)
