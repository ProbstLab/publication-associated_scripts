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


