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
# 
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


