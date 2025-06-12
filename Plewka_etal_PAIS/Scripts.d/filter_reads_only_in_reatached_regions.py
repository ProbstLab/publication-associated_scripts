import pysam
import argparse

def parse_bed_file(bed_file):
    """Parse BED file and return regions as a dictionary of lists by scaffold."""
    regions = {}
    with open(bed_file, 'r') as f:
        for line in f:
            scaffold, start, end = line.strip().split()[:3]
            start, end = int(start) + 1, int(end)  # Convert BED 0-based start to 1-based for SAM
            if scaffold not in regions:
                regions[scaffold] = []
            regions[scaffold].append((start, end))
    return regions

def filter_reads(input_sam, output_sam, bed_file):
    # Load regions from BED file
    regions = parse_bed_file(bed_file)

    # Open input SAM and output SAM files
    with pysam.AlignmentFile(input_sam, "r") as infile, \
         pysam.AlignmentFile(output_sam, "w", header=infile.header) as outfile:
        
        for read in infile:
            # Check if the read aligns to a scaffold in our regions list
            scaffold = read.reference_name
            if scaffold not in regions:
                continue

            # Calculate the start and end of the read's alignment
            start = read.reference_start + 1  # SAM is 1-based, Python is 0-based
            end = read.reference_end  # End position from pysam
            
            # Check if the read fully covers any region on this scaffold
            for region_start, region_end in regions[scaffold]:
                if start <= region_start and end >= region_end:
                    # Verify that the read maps continuously over this region using CIGAR
                    current_position = start
                    fully_covers_region = True
                    for operation, length in read.cigartuples:
                        if operation == 0:  # M = alignment match
                            current_position += length
                        elif operation == 2:  # D = deletion
                            current_position += length
                        elif operation == 1:  # I = insertion
                            continue
                        else:
                            # Skip any other types in CIGAR (e.g., clipping)
                            fully_covers_region = False
                            break
                        
                        # Stop early if we've covered up to region_end
                        if current_position >= region_end:
                            break
                    
                    # Write the read if it fully covers the region
                    if fully_covers_region:
                        outfile.write(read)
                        break  # No need to check other regions for this read

# Usage example
##input_sam = "ES22_IMP_S_C01_reorder.sam_mm5.sam"
##output_sam = "filtered_output.sam"
##bed_file = "regions.bed"
##filter_reads(input_sam, output_sam, bed_file)

if __name__ == "__main__":
    # Create an argument parser
    parser = argparse.ArgumentParser(description="Process a FASTA file by reversing and appending the first half of the sequence to the second half.")

    # Add arguments for input and output files
    parser.add_argument("-i", "--input", required=True, help="Path to the input FASTA file")
    parser.add_argument("-o", "--output", required=True, help="Path to the output FASTA file")
    parser.add_argument("-b", "--bed" , required=True, help="Bedfile with positions, where read maps")
    # Parse the arguments
    args = parser.parse_args()

    # Call the process_fasta function with the provided arguments
    filter_reads(args.input, args.output, args.bed)
