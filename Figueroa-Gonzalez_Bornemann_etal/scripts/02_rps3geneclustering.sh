#!/bin/bash - 
#===============================================================================
#
#          FILE: 02_rps3geneclustering.sh
# 
#         USAGE: ./02_rps3geneclustering.sh 
# 
#   DESCRIPTION: Requires usearch software (you will likely be able to use an open-source implementation like vsearch instead if you dont have a license
#                
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
#        AUTHOR: TLVB
#  ORGANIZATION: 
#       CREATED: 04/04/23 13:26
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

if [ "$#" -lt 2 ]
then
	echo "Requires usearch software, though you can easily adapt command to open-source vsearch."
	echo "As input, you need to pool all the rps3 (or more general gene) sequences you'd like to cluster."
	echo "For this analysis, its all identified rps3 genes of all assemblies."
	echo "Usage: bash 02_rps3geneclustering.sh {pooledrps3geneseqs} {similarity, default 0.99 for 99%}"
	exit 1
fi
pooledrps3fnaseqs=$1
similarity=0.99
usearch -cluster_fast $pooledrps3fnaseqs  -id $similarity -centroids $pooledrps3fnaseqs.clusters.uc -consout $pooledrps3fnaseqs.cons.out -uc $pooledrps3fnaseqs.uc

