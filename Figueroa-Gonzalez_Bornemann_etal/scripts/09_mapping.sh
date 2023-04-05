#!/bin/bash - 
#===============================================================================
#
#          FILE: 09_mapping.sh
# 
#         USAGE: ./09_mapping.sh 
# 
#   DESCRIPTION: Script to map paired-end reads to a reference sequence (in this case the rps3adj sequences).
#                Usage: bash 09_mapping.sh {rps3adjfasta} {forread} {revread}
#                This script will generate a scaff2cov file and keep the .sam file as it will be needed for breadth calculations.
#                Due to keeping the sam file, this script, if a large crossmapping is performed, might take substantial disk space
#                
# 
#       OPTIONS: ---
#  REQUIREMENTS: Requires Bowtie2
#                Requires ruby
#                Requires the ruby script in a subfolder, relative to this parent script, ./bin/calc_coverage_v3.rb
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: TLVB
#  ORGANIZATION: 
#       CREATED: 04/04/23 17:08
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

if [ "$#" -lt 3 ]
then
  	echo "usage: 09_mapping.sh <input-fasta> <fwd_fastq> <rev_fastq>"
	exit 1
fi

rps3adj=$1
read1=$2
read2=$3

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "creating mapping index"
mkdir bt2
bowtie2-build $rps3adj bt2/$rps3adj > bt2/$rps3adj.log

echo "mapping..."
nice bowtie2 -p 10 --sensitive -x bt2/$rps3adj -1 $read1 -2 $read2 2> $rps3adj.sam.log | /home/ajp/software/shrinksam-master/shrinksam > $rps3adj.sam

echo "calculating coverage..."
ruby $SCRIPT_DIR/bin/calc_coverage_v3.rb -s $rps3adj.sam -f $rps3adj | sort -k1,1 > $rps3adj.scaff2cov.txt


