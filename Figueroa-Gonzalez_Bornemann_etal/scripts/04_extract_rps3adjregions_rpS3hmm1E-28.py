"""
Script conceptualized by AJP on 15th Dec2021
Script written by TLVB on 15th Dec2021

Usage: python3  extract_rps3adjregions.py {.b6} {genes.faa/fna} {scaffolds.fasta} {outputbasename}
only native python3 modules are used (os,sys,re)
sanity checks are currently not included and it is the responsibility of the user to make sure that:
    1) scaffoldids match to geneids (minus the _{number} at the end designating the gene number on the respective scaffold) 
    2) the first column in the .b6 output contains the GeneIDs and the header format of the prodigal output remains separated by ' # ' and has start and stop in 2nd and third columns respectively.
    3) the regex "[Rr]ibosomal [Pp]rotein S3[ Pp]" must target the ribosomal protein S3 while leaving out other forms of ribosomal proteins in the .b6 output
    4) the hmm search does the same.
    5) the hits of 3) and 4) are combined and dereplicated.
    4) the scaffolds still have the correct length, i.e., havent been curated and potentially broken by ra2, so that the start/stop information in the gene header is still accurate and no out of range error is called
    These things should generally be the case but should be the first thing to check when the script does not produce an output or gives errors.
"""

def rps3Identifier(genes,b6):
    """
    Runs a hmmsearch with 10 cores on the supplied .faa file -- here an actual faa file is needed -- with Evalue 1E-10 and saves the geneids of hits in a list
    Currently a rps3-vs-funtaxdb_eval1E-28.hits file is generated and parsed to retain the GeneIDs. The hmm hits file is not deleted. 
    """
    os.system('hmmsearch --cpu 10 --tblout ' + genes + '-vs-rps3hmm1E-28.hits -E 0.0000000000000000000000000001 /software/metagenomics_pipeline/bin/220120_rpS3_DNGNGWU00028.hmm ' + genes)
    list=[]
    with open(genes + '-vs-rps3hmm1E-28.hits') as f:
        for row in f:
            if row.startswith('#'):
                continue
            else:
                list.append(row.split(' ')[0])
    pat=re.compile("[Rr]ibosomal [Pp]rotein S3[ Pp]")
    with open(b6) as f:
        for row in f:
            if re.search(string=row,pattern=pat):
                list.append(row.split('\t')[0])
    list = set(list)
    print(list)
    return list

def scaffoldReader(scaffolds):
    """
    takes a .fasta format file as input and turns it into a dictionary, using scaffold ids as keys and the sequences as values. trailing newlines and leading > are removed.
    """

    scafdir={}
    with open(scaffolds) as f:
        for row in f:
            if row.startswith('>'):
                scaffold=row.lstrip('>').strip('\n')
                scafdir[scaffold]=''
 #               print(scaffold)
            else:
                scafdir[scaffold]+=row.rstrip('\n')
    return scafdir

def GeneExtractor(genes,rps3geneids):
    """
    Takes the rps3identifiers generated via rps3identifier() as well as prodigal-outputformat genes either in .faa or .fna format and uses the headers therein to gather information about starts and stops of genes as well as the corresponnding scaffolds names. Finally, it retains only those pieces of information belonging to rps3 genes and their scaffolds.
    """
    genedic={}
    pat=re.compile("_[0-9]+$")
    with open(genes) as f:
        for row in f:
            if row.startswith('>'):
                splits=row.lstrip('>').split(' # ')
 #               print(splits[0])
                #print(re.sub(pat,'',splits[0]))
                scafname=re.sub(pat,'',splits[0])
                genedic[splits[0]]={'start':int(splits[1]), 'stop':int(splits[2]),'scafname':scafname}
    rps3dic={k: genedic[k] for k in rps3geneids}
    return rps3dic


# option a no 1000 on left side or on right side or neither
def rps3adjExtractor(rps3dic,scaffolds,adjreglength):
    """
    takes the output of the previous functions and extracts nucleotide strings from scaffolds containign the rps3 gene as well as up to adjreglength(default set to 1000) nucleotides in either direction. if either left- or right-handside does not have adjreglength nucleotides available, all the available sequence up to the start or end of the scaffold is taken instead. The output consists of two files, a fasta file containing the rps3 geneids as headers and the sequences as bodies, as well as a table detailing starts/stops of rps3 genes as well as their left/right extended borders. This latter table can later be used to select the best representative rps3 after clustering for each cluster.
    Update: New column that reports whether the expansion of the specified size was successful or not is appended at the end of the output table; giving either Lexp/Rexp for successfull lefthand/righthandside expansion or noLexp/noRexp for unsuccessful expansion, resulting in e.g., Lexp_Rexp for hits where the expansion was successfull on both sides.
    Update2: Will now use the gene header for the output fasta file but will prepend a >ExpandedGene_ to indicate that this is not the normal rps3 sequence/gene squence on its own.
    """
    if os.path.exists(outputbasename + '_rps3adjreg.fasta' ):
        os.remove(outputbasename + '_rps3adjreg.fasta')
    if os.path.exists(outputbasename + '_rps3adjreg.txt'):
        os.remove(outputbasename + '_rps3adjreg.txt')
    with open(outputbasename + '_rps3adjreg.txt','a') as f:
        print("Gene\tLeftBorder\trps3start\trps3stop\tRightBorder\tExpansionSuccess",file=f)
    for key in rps3dic:
        valuedic=rps3dic[key]
        string=scaffolds[valuedic['scafname']]
 #       print(string)
        #leftside matcher / -1 as python starts counting at 0
        # min value is 0, i.e., the start of the string
        starts=  valuedic['start']-1
        regionExpansion=''
        if starts - adjreglength >=0 : 
            left = starts - adjreglength
            regionExpansion+='Lexp_'
        else:
            left = 0
            regionExpansion+='noLexp_'
        # right side matcher // -1 as python indexes start at 0 
        # max value is length of scaffold len(string)
        ends = valuedic['stop'] -1 
        if ends +adjreglength <= len(string):
            right = ends +adjreglength
            regionExpansion+='Rexp'
        else:
            right = len(string)
            regionExpansion+='noRexp'
        target =string[left:right]
        with open(outputbasename + '_rps3adjreg.fasta','a') as f:
            print('>ExpandedGene_' + key,file=f)
            print(target,file=f)
        with open(outputbasename + '_rps3adjreg.txt','a') as f:
            print(key+'\t'+str(left)+'\t'+str(valuedic['start']-1) +'\t' +str(valuedic['stop']-1)+'\t' +str(right) + '\t'+ str(regionExpansion) ,file=f)

if __name__=='__main__':
    import sys
    import re
    import os
    blastb6=sys.argv[1]
    genes=sys.argv[2]
    scaffolds=sys.argv[3]
    outputbasename=sys.argv[4]
    adjreglength=1000
    rps3geneids=rps3Identifier(genes,blastb6)
    scafdir=scaffoldReader(scaffolds)
    rps3dic = GeneExtractor(genes,rps3geneids)
    rps3adjExtractor(rps3dic,scafdir,adjreglength)




