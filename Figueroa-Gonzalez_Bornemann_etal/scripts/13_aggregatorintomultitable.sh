#!/bin/bash - 
#===============================================================================
#
#          FILE: 13_aggregatorintomultitable.sh
# 
#         USAGE: ./13_aggregatorintomultitable.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/04/23 21:12
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
awk -F"\t" 'BEGIN{
                  val=0
	          }
	     {
		     if(FILENAME in file==0){
		                      file[FILENAME]
				      val+=1
				      file[FILENAME]=0
				      value[val]=FILENAME
			              }
		     if(NR!=FNR){
			          set[$1]=set[$1]"\t"$2
			         }
		      else{
			        set[$1]=$2
		          }
	     }
	     END{numfiles= NR / FNR
		 printf "Scaffold\t"
	         for(i=1;i<=numfiles;i++){
		                   printf value[i]
				   if(i!=numfiles){
					           printf "\t"
					           }
		                          }
		 print ""
		 for(i in set){
			       print i"\t"set[i]
		               }
		 }' *readth.agg.txt > Breadthtable_aggreagated.tsv

