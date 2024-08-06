#!/bin/bash - 
#===============================================================================
#
#          FILE: 06_combination_rps3adjmetadata_clusteringmetadata.sh
# 
#         USAGE: ./06_combination_rps3adjmetadata_clusteringmetadata.sh 
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
#       CREATED: 04/04/23 14:24
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
awk 'FNR!=1 && NR==FNR {set[$2]=$0} FNR !=NR && FNR!=1 {print $0"\t"set[$3]}' Sample2tablescancat.txt  rps3_clustertype2clusternum2geneid.txt  > Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined.txt
cat  Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined.txt | egrep -v "^C" >  Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined_Cinfirstcolrowsremoved.txt
rm Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined.txt
