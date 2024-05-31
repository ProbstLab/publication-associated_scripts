Stach_Deep_2024_ExStream_paper

This repo containts R Markdown scripts used for data processing, statistical analyses, and figure generation in the manuscript titled "Complex compositional and cellular response of river sediment microbiomes to multiple anthropogenic stressors" by Stach, Deep et al. 
The manuscript can be found here. 

Dependencies and needed input files are listed in the first chunks of the respective script.

Table of contents
- 01_ES22_rpS3_analysis.Rmd
	- Analysis of microbial community based on the rpS3 gene as detected in metagenomic data
	- Alpha- and Beta-Diversity analysis
	- Sensitive OTUs to respective stressors

- 02_ES22_MAG_abundance_tree.Rmd
	- Stressor response of MAGs to applied stressors
	- Phylogenetic tree

- 03_ES22_metabolic_MG_functions.Rmd
	- Impact of stressors on encoded functions in metagenome based on METABOLIC output
	- Equivalence testing based on TOSTER 

- 04_ES22_MAGs_MT_analysis.Rmd
	- Differential expression analysis for MAGs 

- 05_ES22_Genes_DEG.Rmd
	- Differential expression analysis of clustered genes
