#!/bin/bash - 
#===============================================================================
#
#          FILE: 03_generation_clustertype2clusternum2geneid.sh
# 
#         USAGE: ./03_generation_clustertype2clusternum2geneid.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/04/23 14:07
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

if [ "$#" -lt 1 ]
then
	echo "Requires usearch cluster_fast tabular output as input and will extract the needed columns from it"
	echo "Will extract the clustertype column (centroid or not), cluster assignment column and the geneid column"
	exit 1
fi


clusteroutput=$1

cut -f1,2,9 $clusteroutput > rps3_clustertype2clusternum2geneid.txt  

