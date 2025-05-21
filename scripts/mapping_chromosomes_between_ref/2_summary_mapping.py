import pandas as pd 
import argparse as arg 


def summary_mapping(input_file, output_file=None):
    # read the file
    df = pd.read_csv(input_file, sep='\t', usecols=[0, 1, 2, 3, 4, 5, 6, 7, 8], names=['Query', 'QueryLength', 'QueryStart', 'QueryEnd', 'Strand', 'Target', 'TargetLength', 'TargetStart', 'TargetEnd'])

    # compute mapped bases for query and target 
    df['MappedBasesQuery'] = df['QueryEnd'] - df['QueryStart']
    df['MappedBasesTarget'] = df['TargetEnd'] - df['TargetStart']
    # Aggregate total mapped bases for each query-target pair
    
    summary_df = df.groupby(['Query', 'Target', 'QueryLength']).agg(
        MappedBasesQuery=('MappedBasesQuery', 'sum'),
        MappedBasesTarget=('MappedBasesTarget', 'sum')
    ).reset_index()

    # Compute the percentage of mapped bases for each query-target pair
    summary_df['query_coverage_%'] = (summary_df['MappedBasesQuery'] / summary_df['QueryLength']) * 100
    #sort the dataframe by query_coverage_% in descending order
    summary_df = summary_df.sort_values('query_coverage_%', ascending=False)

    # save the summary dataframe to a file if output_file is provided
    if output_file:
        summary_df.to_csv(output_file, sep='\t', index=False)
    else:
        print(summary_df)

    return summary_df

def main(args):
    
    if args.output:
        summary_mapping(args.input, args.output)
    else:
        summary_mapping(args.input)




if __name__ == "__main__":
    parser = arg.ArgumentParser(description='Summarize the mapping result')
    
    parser.add_argument('-i', '--input', required=True,type=str, help='Input chromosome mapping paf file')
    
    parser.add_argument('-o', '--output', type=str, help='Output summary file')
    args = parser.parse_args()
    main(args)

