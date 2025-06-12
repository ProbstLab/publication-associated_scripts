import argparse

def process_fasta(input_fasta, output_fasta):
    sequence = ""
    header = ""

    # Read the input FASTA file
    with open(input_fasta, "r") as f:
        for line in f:
            if line.startswith(">"):
                header = line.strip()  # Store the header
            else:
                sequence += line.strip()  # Concatenate the sequence lines

    # Find the midpoint to split the sequence
    midpoint = len(sequence) // 2

    # Split into two halves
    first_half = sequence[:midpoint]
    second_half = sequence[midpoint:]

    # Create the new sequence (second half + reversed first half)
    new_sequence = second_half + first_half

    # Write the modified sequence to the output FASTA file
    with open(output_fasta, "w") as f:
        f.write(header + "\n")
        # Write the sequence in lines of 80 characters (FASTA format)
        for i in range(0, len(new_sequence), 80):
            f.write(new_sequence[i:i+80] + "\n")

if __name__ == "__main__":
    # Create an argument parser
    parser = argparse.ArgumentParser(description="Test circularity of elment in single fasta file by appending the first half of the sequence to the second half.")
    parser.add_argument("-i", "--input", required=True, help="Path to the input FASTA file")
    parser.add_argument("-o", "--output", required=True, help="Path to the output FASTA file")
    args = parser.parse_args()
    process_fasta(args.input, args.output)
