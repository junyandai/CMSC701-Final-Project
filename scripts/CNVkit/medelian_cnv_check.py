import argparse
import csv
import vcf

def load_cnv_regions(vcf_path, min_svlen=0):
    reader = vcf.Reader(filename=vcf_path)
    cnvs = []
    for record in reader:
        svtype = record.INFO.get('SVTYPE')
        start = int(record.POS)
        end = int(record.INFO.get('END'))
        if end - start < min_svlen:
            continue
        sample = record.samples[0]
        gt = sample['GT']
        cn = sample.data.CN if 'CN' in sample.data._fields else None
        cnvs.append({
            'chrom': record.CHROM,
            'start': start,
            'end': end,
            'svtype': svtype,
            'gt': gt,
            'cn': cn,
        })
    return cnvs

def reciprocal_overlap(cnv1, cnv2):
    if cnv1['chrom'] != cnv2['chrom'] or cnv1['svtype'] != cnv2['svtype']:
        return 0.0
    a_start, a_end = cnv1['start'], cnv1['end']
    b_start, b_end = cnv2['start'], cnv2['end']
    inter = max(0, min(a_end, b_end) - max(a_start, b_start))
    len_a = a_end - a_start
    len_b = b_end - b_start
    return min(inter / len_a, inter / len_b)

def check_consistency(child_cnvs, parent_cnvs, threshold=0.5):
    consistent = []
    inconsistent = []

    for c in child_cnvs:
        match_found = False
        for p in parent_cnvs:
            ro = reciprocal_overlap(c, p)
            if ro >= threshold:
                match_found = True
                break
        if match_found:
            consistent.append(c)
        else:
            inconsistent.append(c)
    return consistent, inconsistent

def main(args):
    child_cnvs = load_cnv_regions(args.child, args.min_svlen)
    mother_cnvs = load_cnv_regions(args.mother, args.min_svlen)
    father_cnvs = load_cnv_regions(args.father, args.min_svlen)

    cons_mother, _ = check_consistency(child_cnvs, mother_cnvs)
    cons_father, _ = check_consistency(child_cnvs, father_cnvs)

    consistent = [c for c in child_cnvs if c in cons_mother or c in cons_father]
    inconsistent = [c for c in child_cnvs if c not in consistent]

    total = len(child_cnvs)
    num_consistent = len(consistent)
    num_inconsistent = len(inconsistent)
    inconsistency_rate = round(num_inconsistent / total, 4) if total > 0 else 0.0

    with open(args.output, 'w', newline='') as csvfile:
        fieldnames = ['chrom', 'start', 'end', 'svtype', 'gt', 'cn', 'mendelian_status']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for c in consistent:
            writer.writerow({**c, 'mendelian_status': 'consistent'})
        for c in inconsistent:
            writer.writerow({**c, 'mendelian_status': 'inconsistent'})

        # Write summary as final row
        writer.writerow({})
        writer.writerow({
            'chrom': 'SUMMARY',
            'start': f'Total CNVs: {total}',
            'end': f'Consistent: {num_consistent}',
            'svtype': f'Inconsistent: {num_inconsistent}',
            'gt': '',
            'cn': '',
            'mendelian_status': f'Inconsistent rate: {inconsistency_rate}'
        })

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Check Mendelian consistency of CNVs in trio VCFs.")
    parser.add_argument('--child', required=True, help='Child VCF from CNVkit')
    parser.add_argument('--mother', required=True, help='Mother VCF from CNVkit')
    parser.add_argument('--father', required=True, help='Father VCF from CNVkit')
    parser.add_argument('--output', required=True, help='Output CSV file path')
    parser.add_argument('--min-svlen', type=int, default=0, help='Minimum SV length to consider')
    args = parser.parse_args()
    main(args)
