import pandas as pd 
import argparse as arg




def main(args):
    # read the summary file 
    summary_df = pd.read_csv(args.input, sep='\t')
    # read the two mapping file
    mapping_df1 = pd.read_csv(args.mapping_1, sep='\t')
    mapping_df2 = pd.read_csv(args.mapping_2, sep='\t')
    # contact the two mapping file
    mapping_df = pd.concat([mapping_df1, mapping_df2])

    # only keep the rows of same chromosome name with the highest coverage
    summary_df = summary_df.sort_values('query_coverage_%', ascending=False).drop_duplicates('Query')
    summary_df['GCA-SeqID'] = summary_df['Query']
    summary_df['GCF-SeqID'] = summary_df['Target']

    # rename the sequnce id in summary file to the chromosome name in mapping file
    summary_df['Query'] = summary_df['Query'].map(mapping_df.set_index('SeqID')['Chromosome'])
    summary_df['Target'] = summary_df['Target'].map(mapping_df.set_index('SeqID')['Chromosome'])
    
    # rename the column name Query to "GCA_000001405.15" and Target to "GCF_022581195.2"
    summary_df = summary_df.rename(columns={'Query': 'GCA_000001405.15', 'Target': 'GCF_022581195.2'})

    if args.output:
        summary_df.to_csv(args.output, sep='\t', index=False)
    else:
        print(summary_df)



if __name__ == "__main__":
    parser = arg.ArgumentParser()
    parser.add_argument('-i', '--input', required=True,type=str, help='Input summary file')
    parser.add_argument('-o', '--output', type=str, help='Output rename summary file')
    parser.add_argument('-m1', '--mapping_1', required=True, type=str, help='input sequence id mapping file')
    parser.add_argument('-m2', '--mapping_2', required=True, type=str, help='input sequence id mapping file')

    args = parser.parse_args()
    main(args)