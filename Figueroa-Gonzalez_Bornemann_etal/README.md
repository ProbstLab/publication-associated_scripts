#Recovery, cross-mapping and breadth filtering of rps3-containing scaffold regions

Version: 05.04.2023

#Overview

The described workflow has the following steps:

1\) rpS3 gene identification

2\) rps3 gene clustering

3\) extraction of scaffold regions around rpS3

4\) selection of representative sequences

5\) abundance estimation (i.e., cross-mapping and coverage
determination)

6\) breadth filtering

In its current form, the workflow is not steamlined, i.e., the user
needs to do some parsing in between steps (commands will be provided)
and needs to execute the scripts in the right order. Future versions
will aim to steamline this process.

**Dependencies**

**Software**

- **B**ourne **a**gain **sh**ell (bash)

- **g**nu **awk** (gawk)

- pullseq (<https://github.com/bcthomas/pullseq>)

- bowtie2 (<https://github.com/BenLangmead/bowtie2>)

- hmmer3 (<http://hmmer.org/> ; to have access to hmmsearch command)

- usearch (<https://www.drive5.com/usearch/>)

- python3

- ruby

**Databases / files**

- 220120_rpS3_DNGNGWU00028.hmm hmm from Phylosift hmms
  (<https://phylosift.wordpress.com/tutorials/scripts-markers/> )

> **Preliminary remarks**

- Note that all scaffoldids/geneids need to be unique across all
  samples, hence adding, e.g., a sample identifier to scaffold/gene
  names is recommended (add it to the start of the scaffold/gene id,
  otherwise the prodigal format will be destroyed).

- Scripts work with both contigs and scaffolds

- {description} will be used as a placeholder for an input file you will
  need to provide, with the ‘description’ showing what file it is.
  Replace the {description} with your input file (without the brackets)

- Scaffold regions around rpS3 genes that were extracted will be called
  ‘rps3adj’ herein

**Required files**

For each sample:

-Assemblies in .fasta format

\- Genes in nucleotide format, with prodigal-style headers containing
start/stop info for each gene on the respective scaffold

\- Annotations of genes vs FunTaxDB (Bornemann et al., 2023)  (.b6
format BLAST output)

**1) Identification of rpS3 genes**

**Requirements**

\- 220120_rpS3_DNGNGWU00028.hmm hmm from Phylosift hmms, needs to be in
the folder ./bin/ relative to the main script

\- The default downloadable hmm name is just “DNGNGWU00028.hmm” and you
may rename it (do not forget to edit the name in the script as well).

**Usage**

bash 01_rpS3geneprediction.sh{fna} {b6 output}

- Run this for each of your samples

**Output**

- Will produce a rps3_hits.fna file as the final output containing genes
  annotated as *rpS3* in nucleotide format, with hits identified via
  either/or BLAST annotations and hmmsearch

- Also produces multiple temporary files (rpS3_hmm.hits, rpS3_grep.hits
  and rpS3.hits ) that are deleted at the end

**Remarks**

**-** by default uses 10 threads, can be adjusted in the script

\- if pullseq/hmmsearch are not in your PATH, give the entire path to
the software to execute them

\- there are a few intermediate files which can be deleted as only the
rps3_hits.fna file is needed in the end 

 

**2) rpS3 gene Clustering and selection of representative sequences**

**Requirements**

\- *rpS3* genes in fna format for all assemblies that are to be
clustered in a single file with unique IDs

**Usage**

bash 02_rps3geneclustering.sh {pooledrpS3.fna}

bash 03_generation_clustertype2clusternum2geneid.sh {pooledrpS3.fna}.uc

**Output**

Three files will be produced by the 02_rps3geneclustering.sh script:

- {pooledrpS3.fna}.clusters.uc

- {pooledrpS3.fna}.cons.out

- {pooledrpS3.fna}.uc

  - The last file is the one (with the .uc extension) we will continue
    with and use the second of the scripts on

The second script will simply simplify the .uc output file and only save
the relevant columns in a rps3_clustertype2clusternum2geneid.txt file

**Remarks**

\- I would highly recommend working in a separate folder to your normal
assembly folder as multiple files will be created in the next few steps

\- the 64-bit implementation of usearch is not open-source and hence may
not be available to everyone. There is an open-source vsearch
(<https://github.com/torognes/vsearch>) implementation you may use
instead. Please see the vsearch github for the analoguous commands to
the usearch commands specified in the script

**3) Extraction of scaffold regions around it**

**Requirements**

For each sample (similar to step 1):

\- .b6 BLAST output (same as used in 1)

\- genes fna file

\- scaffolds/contigs

**Usage**

python3 04_extract_rps3adjregions_rpS3hmm1E-28.py {b6} {genes fna/faa}
{assembly.fasta} {outputbasename}

**Output**

Two files are produced:

\- A .fasta file with subsets of scaffold sequence around rpS3 genes, up
to 1000 bp extended to either side by default

\- a statistics file containing the starts/stops for each extracted gene
on the scaffold as well as whether it could be extended for the full
length (1000bp) in none, one or both directions (needed to select
representative sequence)

**Remarks**

\- this will both extract scaffold regions around the same rpS3 genes as
identified in 1(it will redo the identification)

\- the default setting set in the bottom of the script will extend the
rpS3 genes by 1000 bp to both directions of its location on the scaffold
if possible

-\> if its not possible, it will extend as far as possible, i.e., to the
end of the scaffold 

**4) Selection of representative sequences**

**Concept**

\- The goal of this step is to find the best rpS3 sequence to represent
each cluster determined in 2)

Order of priority for selection of the representative sequence per
cluster:

1)  **rps3adj** could be **extended** for the full length (by default
    1000 bp) into both directions **AND** is the **centroid**

2)  rpS3 is **not centroid but** could be **extended**

3)  **longest rpS**

the following section will have multiple iterations of usage/output
detailing multiple small scripts in this section

1.  **Description**

Concatenate the metadata outputs from step 4)

1.  **Usage:**

bash 05_combination_rps3adj_metadatatables.sh

- needs to be run in a folder containing all metadata outputs from 4)
  (i.e., the .txt files) and no other .txt files

1.  **Output**

Will produce a concatenated Sample2tablescancat.txt file required for
follow-up steps.

2.  **Description**

this script requires the Sample2tablescancat.txt file of the previous
script and the and the rps3_clustertype2clusternum2geneid.txt from step
2) to be in the current folder and will combine them

3.  **Usage**

bash 06_combination_rps3adjmetadata_clusteringmetadata.sh

2.  **Output**

Will create a combined output file to select representative sequences
on, called
Sample2tablescancat_rps3_clustertype2clusternum2geneid_combined_Cin1stcolrowsrem.txt

3.  **Description**

Selection or rps3adj representative sequences and output as a table

**3.Usage**

bash 07_selectionrepresentativerps3adj.sh

**3.Output**

Will output a table (you need to specify an output, otherwise it will
print to stdout) containing the representative sequences and some info
about them. The table columns are in order left to right:

- Clusternumber

- Centroid or not

- GeneID

- ExtensionCharacteristics

- TotalSequenceLength

4.  **Description**

Will extract the fasta sequences of the representative rps3adj
sequences. Requires all of the rps3adj sequences of all samples to be
together in a single file

**4.Usage**

bash 08_extraction_rps3adj_repseqs.sh {tablereprps3adj}
{fastaallrps3adj}

**4.Output**

rps3adj_repseqs.fasta containing the representative sequences

**5) mapping on rpS3adj sequences**

**Description**

- Map reads to rps3adj sequences and calculate coverage and breadth

- Requires the calc_coverage_v3.rb script in the ./bin/ subfolder
  relative to the script

**Input**

For each sample:

\- for/rev reads

\- rps3adj representative sequences fasta file

**Usage**

bash 09_mapping.sh {reprps3adj} {for-read} {rev-read}

**Output**

{reprps3adj}.sam (containing mapping info)

{reprps3adj}.scaff2cov.txt with scaffold2coverage info

{reprps3adj}.sam.log with mapping summary

**Remarks**

- Check the log file for errors to verify that the mapping worked

- Sam files can become somewhat large, so beware disk space if you do
  many cross-mappings

  - To save additional temporary disk space, you can also do directly
    calculate the breadth per scaffold from the .sam files (will be
    covered in following steps) and then compress/delete the sam files

- I typically put this command into a for loop, with an example
  following below

  - Assumes that all reads are in the same folder and that the reads are
    named like {Sample}\_PE.1.fastq.gz / {Sample}\_PE.2.fastq.gz

> for i in \$(ls \*PE.1.fastq.gz);do
>
> pe2=\$(echo \$i \| sed “s/PE\\1\\/PE.2./g” )
>
> base=\$(basename \$i \| awk -F”\_” ’{print \$1”.fasta”}’)
>
> cp -s {reprps3adj} \$base

bash 09_mapping.sh \$base \$i \$pe2

done

**6) Calculation of breadth per rpS3adj**

The entire reason why we go through the added trouble of extracting
rpS3adj so that coverage unevenness across scaffolds carrying rpS3 genes
dont confound the actual coverage of the gene

 A high breadth value will indicate that all/most of the sequence is
present in the sample and hence is an added indicator for a ‘true’ hit
(though this is likely more important for genome-level analyses where
mobile genetic elements can severely skew coverage profiles)

**Reasons for coverage unevenness/abnormalities:**

\- prophages where subpopulations are not integrated into a genome,
i.e., prophage regions in genomes will have higher coverage
corresponding to the proportion of free-living prophage particles

\- transposons / repeats / genetic islands and other genetic features
that are frequently shared between organisms - unless they all assembled
in their own scaffolds, the non-assembled proportions will also inflate
coverage of the assembled proportions

**Inputs**

\- you need the sam file and a list of sequenceids

The sequenceid list can be generated via:

bash 10_generatescaffoldlist.sh {reprrps3adj}

This will generate a “sequenceheaders.list” file

**Usage**

bash 11_rawbreadthcalculation.sh {sam} sequenceheaders.list \>
{sam}.breadth

**Output**

\- the output will be a 2 column table

The first column will contain nucleotide positions (1-scaffoldlength),
the 2nd column will contain coverage information for this position

For each scaffold, the first entry will be a header column with
"Position\t"{scaffoldid}

- The output file should have the .breadth extension and allow inference
  to which sample it belongs (required for following script)

**Generate scaffold2breadth tables**

-will calculate the % breadth per scaffold (breadth being defined as %
of positions with coverage \>0)

**Input**

-requires the previous scripts output file as input, i.e. {sam}.breadth
file

**Usage**

bash 12_breadthaggregator.sh {sam}.breadth

**Output**

\- generate a table with two columns, a scaffoldid column and a breadh
(in percentage) column

\- output by default will be called {sam}.breadth.agg.txt

**Aggregate many scaffold2breadth tables that share the same
scaffold/rps3adj ids:**

\- this will generate one table with the first column being the
scaffoldid and then each other column being the respective breadths for
the scaffoldids of each other sample

**Input**

All files ending on readth.agg.txt in the current folder

**Usage**

bash 13_aggregatorintomultitable.sh

**Output**

\- to save to file, you need to define an output, otherwise it will
print to screen

**Filter rpS3adj data via breadth**

\- for this analyses, we used a breadth filter of 95% for genes, i.e.,
95% of nucleotide positions across the rps3-adj sequence should have a
coverage of at least 1

-\> this ensures that the gene is really present in the sample and not
just some region in the sequence is shared with some other higher
abundant sequence and consequently overestimates the sequence abundance

-\> if a rps3adj gene had a breadth of \<95% in a sample, it's coverage
was set to 0.

-\> this analysis was done in R. If you have a scaffold2coverage table
(1<sup>st</sup> column are scaffoldids, then each other column a sample
with respective coverage values) and the same arrangement of
scafffoldIDs to sample columns in the breadth table, you can filter the
coverage table using:

covtable\[breadthtable \<0.95\] \<- 0

- This assumes that scaffoldids are converted to rownames, i.e., all
  cells in the tables are either coverage values or breadth values and
  consequently numeric.

- Will set all coverages where the breadth is below 95% to 0.
