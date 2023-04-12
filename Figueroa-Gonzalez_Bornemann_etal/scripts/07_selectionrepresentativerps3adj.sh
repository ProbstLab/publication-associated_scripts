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

