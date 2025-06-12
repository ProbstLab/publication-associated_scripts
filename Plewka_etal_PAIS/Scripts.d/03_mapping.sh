#!/bin/bash

if [ "$#" -lt 4 ]
then
   echo "usage: 03_mapping.sh <fasta_file_name.fasta> <QCed_rawreads1>  <QCed_rawreads2> <bed_file>"
 exit 1
fi

file=$1 ## input fasta file (no directory path; only file name)
raw1=$2 ## Forward qced raw reads
raw2=$3 ## Reverse qced raw reads
bed_file=$4

nice bowtie2 -p 30 -x bt2/${file} -1 ${raw1} -2 ${raw2} 2> ${file}_mapping.sam.log > ${file}.sam
bash awk_mapping_cut_of5MM.sh ${file}.sam 5 >  ${file}_max5percMM.sam
python filter_reads_only_in_reatached_regions.py -i ${file}_max5percMM.sam -o ${file}_filteredFLANKING_CUT.sam -b ${bed_file} 
samtools view -Sb ${file}_filteredFLANKING_CUT.sam | samtools sort  > ${file}_filteredFLANKING_CUT.bam
bedtools genomecov -ibam ${file}_filteredFLANKING_CUT.bam -bg > ${file}_filteredFLANKING_CUT_genomecov.txt

pigz -p 40 *sam
pigz -p 40 *bam

