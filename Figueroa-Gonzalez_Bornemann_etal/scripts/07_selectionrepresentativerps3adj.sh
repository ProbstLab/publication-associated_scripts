#!/bin/bash - 
#===============================================================================
#
#          FILE: 07_selectionrepresentativerps3adj.sh
# 
#         USAGE: ./07_selectionrepresentativerps3adj.sh 
# 
#   DESCRIPTION:  This script will select the best rps3adj representative based on the following heuristics and order of priorities for representative selection:
#                 1) the rps3 gene could be EXTENDED IN BOTH by the set amount (by default 1000 bp), AND is the CENTROID
#                 2) the longest rps3adj gene, i.e., likely with both sides extended but not the centroid necessarily
#                 Please define an output file as the script will otherwise print to screen
#                 The script currently uses a hard-coded input file name 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/04/23 14:51
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
awk -F"\t" '{
             if($2 in set ==0){
		               set[$2]["Clustertype"]=$1
			       set[$2]["Geneid"]=$3
			       set[$2]["Borders"]=$NF
			       set[$2]["length"]=$(NF-1) - $(NF-4)
		               }
	     else{
		     if( $1 ~/S/ && $NF ~/^Lexp_Rexp/){
			     set[$2]["Clustertype"]=$1
			     set[$2]["Geneid"]=$3
			     set[$2]["Borders"]=$NF
			     set[$2]["length"]=$(NF-1) - $(NF-4)
		     }
	              else{
			      if(set[$2]["Clustertype"]~/S/ && set[$2]["Borders"]~/^Lexp_Rexp/ ){
			      }
		              else{
				      if($(NF-1) - $(NF-4) > set[$2]["length"] ){
			                  set[$2]["Clustertype"]=$1
				          set[$2]["Geneid"]=$3
				          set[$2]["Borders"]=$NF
				          set[$2]["length"]=$(NF-1) - $(NF-4)
			                                                          }
				 }
									                            }
	                   }
                }

           END{for(i in set){
                  print i"\t"set[i]["Clustertype"]"\t"set[i]["Geneid"]"\t"set[i]["Borders"]"\t"set[i]["length"]
                             }
              }     ' Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined_Cinfirstcolrowsremoved.txt

