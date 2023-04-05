#!/bin/bash - 
#===============================================================================
#
#          FILE: 04_combination_rps3adj_metadatatables.sh
# 
#         USAGE: ./04_combination_rps3adj_metadatatables.sh 
# 
#   DESCRIPTION: Requires you to have all metadata tables from the rps3adj region extraction in the current folder. No other files with the .txt extension are allowed
#                Will create a Sample2tablescancat.txt file
#                
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/04/23 13:53
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error


rm Sample2tablescancat.txt
for i in $(ls *.txt);do
	awk -v  name=$i 'NR==1{
	                       print "Sample\t"$0
		       }
	                 NR!=1 {
			        print name"\t"$0
			}' $i
done > Sample2tablescancat.txt  


