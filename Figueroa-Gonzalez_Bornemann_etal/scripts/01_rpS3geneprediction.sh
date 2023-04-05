#!/bin/bash

if [ "$#" -lt 2 ]
then
	echo "Use phylosift rpS3 hmm as well as grep in FunTaxDB output to ID rpS3 genes and extract the geneid"
	echo "extract gene sequences in nucleotide format for rps3 sequences for subsequent clustering"
  	echo "usage: rabd.sh <proteins.faa> <blast output of proteins>"
	echo "requires phylosift hmm for rps3 220120_rpS3_DNGNGWU00028.hmm to be in the subfolder ./bin/220120_rpS3_DNGNGWU00028.hmm relative to the script location."
	echo "hmm was downloaded on the 20th of Jan 2022, hence the 220120 prefix"
	echo "requires pullseq software https://github.com/bcthomas/pullseq"
	exit 1
fi

fna=$1
blast=$2
threads=10
echo "finding rpS3 genes..."

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#grep "ribosomal protein S3" $blast | grep -v "ribosomal protein S30" | grep -v "ribosomal protein S3A" | grep -v "ribosomal protein S31" | grep -v "ribosomal protein S3Ae" | grep -v "ribosomal protein S3ae" | awk '{print$1}' > rpS3.hits
hmmsearch --cpu $threads --tblout ${faa}-vs-rpS3hmm.hits -E 0.0000000000000000000000000001 $SCRIPT_DIR/bin/220120_rpS3_DNGNGWU00028.hmm $faa
grep  -v "^#" ${faa}-vs-rpS3hmm.hits  | awk '{print $1}' > rpS3_hmm.hits

egrep "[Rr]ibosomal [Pp]rotein S3[ Pp]" $blast  | awk '{print$1}' > rpS3_grep.hits

cat rpS3_hmm.hits  rpS3_grep.hits | sort | uniq > rpS3.hits

cat rpS3.hits | pullseq -N -i $fna > rps3_hits.fna
rm rpS3_hmm.hits  rpS3_grep.hits rpS3.hits



