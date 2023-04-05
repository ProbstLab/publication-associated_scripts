#!/bin/bash - 
#===============================================================================
#
#          FILE: 06_combination_rps3adjmetadata_clusteringmetadata.sh
# 
#         USAGE: ./06_combination_rps3adjmetadata_clusteringmetadata.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/04/23 14:24
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
awk 'FNR!=1 && NR==FNR {set[$2]=$0} FNR !=NR && FNR!=1 {print $0"\t"set[$3]}' Sample2tablescancat.txt  rps3_clustertype2clusternum2geneid.txt  > Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined.txt
cat  Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined.txt | egrep -v "^C" >  Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined_Cin1stcolrowsrem.txt
rm Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined.txt
