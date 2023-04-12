#!/bin/bash - 
#===============================================================================
#
#          FILE: 13_aggregatorintomultitable.sh
# 
#         USAGE: ./13_aggregatorintomultitable.sh 
# 
#   DESCRIPTION: 
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

