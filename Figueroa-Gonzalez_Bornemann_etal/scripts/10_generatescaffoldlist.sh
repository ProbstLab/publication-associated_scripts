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
# 
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

