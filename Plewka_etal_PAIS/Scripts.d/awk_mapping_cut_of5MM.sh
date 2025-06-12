#!/bin/bash - 
#===============================================================================
#
#          FILE: awk_mmfil.sh
# 
#         USAGE: ./awk_mmfil.sh 
# 
#   DESCRIPTION: needs a valid sam file and a number specifying a float or integer percentage for the threshold for reads with too many mismatches thaat are to be filtered out. e.g. 5 means all reads with 5 or more mismatches in % are filtered out. uses the NM:i: field despicting the mismmatchnumbers to count the mismatches. this pattern thus must not occur in the reaadids or scaffold ids and this is checked for the very first read and scaffold row in the file and assumed to be held true for the rest of the file.
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 10/29/20 10:51
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

sam=$1
maxmmperc=$2

awk -F"\t" -v mm=$maxmmperc 'BEGIN{
                                   count=0
                                    }
			      $1~/^@/ {
                                       print $0
			              }
			      count == 0 && $1 !~ /^@/ {
			                                if($1 ~/NM:i:[0-9]*/ || $3 ~/NM:i:[0-9]*/ ) {
			                                                                             print "either your readids or scafids contain the mismatchfield pattern NM:i, exiting..."
			                                                                             exit 1
									                             }
						       else{
							    count=1
						            }
						       }
			      $1 !~/^@/ && match($0,"NM:i:[0-9]*") {
			                                            if(substr($0,RSTART+5,RLENGTH-5) / length($(10)) < mm ) {
								                                                        	print $0
								                                                              }
							            }' $sam

