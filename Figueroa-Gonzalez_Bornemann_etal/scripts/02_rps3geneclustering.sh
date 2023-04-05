#!/bin/bash - 
#===============================================================================
#
#          FILE: 02_rps3geneclustering.sh
# 
#         USAGE: ./02_rps3geneclustering.sh 
# 
#   DESCRIPTION: Requires usearch software (you will likely be able to use an open-source implementation like vsearch instead if you dont have a license
#                
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: TLVB
#  ORGANIZATION: 
#       CREATED: 04/04/23 13:26
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

if [ "$#" -lt 2 ]
then
	echo "Requires usearch software, though you can easily adapt command to open-source vsearch."
	echo "As input, you need to pool all the rps3 (or more general gene) sequences you'd like to cluster."
	echo "For this analysis, its all identified rps3 genes of all assemblies."
	echo "Usage: bash 02_rps3geneclustering.sh {pooledrps3geneseqs} {similarity, default 0.99 for 99%}"
	exit 1
fi
pooledrps3fnaseqs=$1
similarity=0.99
usearch -cluster_fast $pooledrps3fnaseqs  -id $similarity -centroids $pooledrps3fnaseqs.clusters.uc -consout $pooledrps3fnaseqs.cons.out -uc $pooledrps3fnaseqs.uc

