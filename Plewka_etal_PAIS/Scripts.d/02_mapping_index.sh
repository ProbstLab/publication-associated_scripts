#!/bin/bash

file=$1

mkdir bt2
bowtie2-build ${file} bt2/${file} > bt2/${file}_index.log -p 20 --large-index

