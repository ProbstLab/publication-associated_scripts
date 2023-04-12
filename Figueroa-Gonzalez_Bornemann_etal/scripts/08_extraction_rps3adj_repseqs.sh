#!/bin/bash - 
#===============================================================================
#
#          FILE: 08_extraction_rps3adj_repseqs.sh
# 
#         USAGE: ./08_extraction_rps3adj_repseqs.sh 
# 
#   DESCRIPTION: This script takes the identification results of represenative rps3adj sequences as input and extracts fasta sequences for these representative rps3adj sequences.
#                Requires pullseq software
#                Has hard-coded result filename currently
#                Usage: bash 08_extraction_rps3adj_repseqs.sh {identificationResults} {pooledfastaofallrps3adj} > rps3adj_repseqs.fasta
#       LICENSE: 
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
#  REQUIREMENTS: ---
#          BUGS: If results file is empty, check whether GeneIDs in tabular and fasta input match (adding the ExpandedGene prefix to the fasta input)
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/04/23 16:50
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

tablerepseqs=$1
fastaallrps3adj=$2

cut -f3 $tablerepseqs | sed "s/^/ExpandedGene_/" | pullseq -N -i $fastaallrps3adj  > rps3adj_repseqs.fasta


