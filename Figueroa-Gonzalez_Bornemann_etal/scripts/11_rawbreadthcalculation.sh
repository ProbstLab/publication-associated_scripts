#!/bin/bash 
#===============================================================================
#
#          FILE: 11_rawbreadthcalculation.sh
#
#         USAGE: 11_rawbreadthcalculation.sh
#
#   DESCRIPTION: extract the coverage for each nucleotide position on scaffolds specified with the first argument from the given SAM file.
#                Currently only accepts single input scaffold ID and the ID is assumed to be unique. 
#                Could be easily modified to accept a list and build up multiple arrays documenting breadths of these multiple scaffolds simultaneaously.
#                This would presumably increase the speed tremendously.
#                Alternatively, you can use parallel to parallelize the process, though this is not efficient in terms of CPU usage.
#                not done with modding the script
#                Since each nucleotide position on each scaffold is a row per file, the files arent all that small - so maybe remove them after the follow-up steps
#             
#                Usage: bash 11_rawbreadthcalculation.sh {scaffoldlist} {samfile} > {output} 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (),
#  ORGANIZATION:
#       CREATED: 11/16/21 15:45
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
sam=$1
scaf=$2

gawk -F"\t"  'NR==FNR {
                       scaft[$1]=""
	               }
	      NR!=FNR && $1~/@/ {
                                 gsub(/LN:/,"",$NF)
				 gsub(/SN:/,"",$2)
				 if($2 in scaft){
			       	       	       scafs[$2]=$NF
					       set[$2][1]=""
					       }
			       }
          NR!=FNR && $1 !~/^@/ && $3 in scafs {
	                            for(i=$4;i <= $4 + length($10); i++){
							                  if(i in set[$3]){
										        set[$3][i]+=1
										      }
											  else{
								           		         set[$3][i]=1
											       }
									}
									}
	    END{
	        for(k in set){
			print "Position\t"k
			for(i=1;i<=int(scafs[k]);i++){
				       if(set[k][i] == ""){
					                    print i"\t0"
						    }
					    else{
			               print i"\t"set[k][i]
			                        }
				               }
				}}' $scaf $sam
