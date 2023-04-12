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
#        LICENSE:
#MIT License

#Copyright (c) 2023 Till Bornemann (ProbstLab)

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

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
ruby $SCRIPT_DIR/bin/04_01calc_coverage_v3.rb -s $rps3adj.sam -f $rps3adj | sort -k1,1 > $rps3adj.scaff2cov.txt


