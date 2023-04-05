#!/bin/bash - 
#===============================================================================
#
#          FILE: 12_breadthaggregator.sh
# 
#         USAGE: ./12_breadthaggregator.sh 
# 
#   DESCRIPTION: Aggregates raw braedth tables by calculating the breadth for each scaffold from raw coverage per nucleotideposition data
#                Breadth defined as % of positions covered by a minimum of 1 read, i.e., coverage >= 1
#                Usage: bash 12_breadthaggregator.sh {breadhfile} > {breadthfile}.agg.txt
#                Output is a sequenceid2breadth file
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/04/23 21:08
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
breadth=$1
awk '$1~/Position/ {
                    scaf=$2
		    num=0
		    mincovtimes=0
	             }
    $1!~/Position/ {
                     num+=1
		     if($2 > 0){
			         mincovtimes+=1
			        }
			set[scaf]=mincovtimes / num
		    }
	  END{
	       for(i in set){
		               print i"\t"set[i]
		             }
	     } ' $breadth > ${breadth}.agg.txt


