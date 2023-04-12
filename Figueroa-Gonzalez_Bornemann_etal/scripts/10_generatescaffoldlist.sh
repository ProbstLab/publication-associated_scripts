#!/bin/bash - 
#===============================================================================
#
#          FILE: 10_generatescaffoldlist.sh
# 
#         USAGE: ./10_generatescaffoldlist.sh 
# 
#   DESCRIPTION: Will generate a sequence list. 
#                Usage: bash 10_generatescaffoldlist.sh {reprps3adjsequences} 
#                the output file name is hard-coded as sequenceheaders.list
#      LICENSE:
#
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
#       CREATED: 04/04/23 17:18
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
reprps3adjsequences=$1

grep '>' $reprps3adjsequences | sed "s/^>//" > sequenceheaders.list

