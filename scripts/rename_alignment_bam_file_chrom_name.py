import pysam
import csv
import argparse

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

def rename_bam(mapping_file, input_bam, output_bam, sex_chrom_name):
    id_map = load_mapping(mapping_file, sex_chrom_name)

    bam_in = pysam.AlignmentFile(input_bam, "rb")
    header = bam_in.header.to_dict()

    for ref in header["SQ"]:
        old_name = ref["SN"]
        new_name = id_map.get(old_name, old_name)
        ref["SN"] = new_name

    bam_out = pysam.AlignmentFile(output_bam, "wb", header=header)

    for read in bam_in.fetch(until_eof=True):
        bam_out.write(read)

    bam_in.close()
    bam_out.close()

    pysam.index(output_bam)

def main():
    parser = argparse.ArgumentParser(description="Rename BAM reference sequence IDs based on mapping file.")
    parser.add_argument("--map", required=True, help="Path to the sequence ID mapping TSV file.")
    parser.add_argument("--in", dest="input_bam", required=True, help="Input BAM file.")
    parser.add_argument("--out", dest="output_bam", required=True, help="Output BAM file with renamed reference names.")
    parser.add_argument("--sex-chrom-name", default="Z", help="Name to assign to chromosome 31 (default: Z). Use 'X' to trick CNVkit gender inference.")

    args = parser.parse_args()
    rename_bam(args.map, args.input_bam, args.output_bam, args.sex_chrom_name)

if __name__ == "__main__":
    main()
