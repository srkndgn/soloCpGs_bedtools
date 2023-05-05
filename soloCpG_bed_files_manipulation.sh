# extract columns from a bed file to a csv file

# extract just 3 columns from 1st to 4th from the following dataset and save as csv/bed file.

# sample dataset
chr1	3001276	3001278	0	0.305556	TCGA	TTCGAT	WCGW
chr1	3003378	3003380	0	0.513889	TCGT	CTCGTG	WCGW
chr1	3005997	3005999	0	0.458333	ACGA	AACGAA	WCGW
chr1	3006415	3006417	0	0.375	TCGA	ATCGAT	WCGW
chr1	3008544	3008546	0	0.458333	TCGA	GTCGAG	WCGW
chr1	3011264	3011266	0	0.472222	ACGT	CACGTC	WCGW
chr1	3011549	3011551	0	0.291667	TCGT	ATCGTA	WCGW
chr1	3012256	3012258	0	0.444444	TCGT	GTCGTG	WCGW
chr1	3013471	3013473	0	0.277778	ACGA	TACGAA	WCGW

# awk script example to save your desired file format

awk '{print $1","$2","$3}' solo_WCGW_mm10.bed > solo_WCGW_mm10_comma.csv

awk '{print $1","$2","$3}' solo_WCGW_mm10.bed > solo_WCGW_mm10_comma.bed

awk '{print $1 "\t" $2 "\t" $3}' solo_WCGW_mm10.bed > solo_WCGW_mm10_tab.bed


# Bedtools is a fast, flexible toolset for genome arithmetic.
# Tutorial for bedtools > (http://quinlanlab.org/tutorials/bedtools/bedtools.html)
# Reference page > (https://bedtools.readthedocs.io/en/latest/index.html)

# install the bedtools
    cd anaconda3/envs/                  # go to your anaconda3 directory
    conda create --name bedtools        # create your bedtools environment
    
    cd anaconda3/envs/bedtools/         #go to your working directory
    
    conda activate bedtools             #activate conda environment
    
    conda install -c bioconda bedtools  #install bedtools
    
# create your working directory for your bedtools environment
    mkdir soloCpGs_bedtools             # working directory should be outside the anaconda3 directory
    cd soloCpGs_bedtools                # go to your bedtools working directory

# activate the bedtools environment in your working directory
    conda activate bedtools             #activate conda environment
    
# 1- load your data/bed files into your working directory
    # bed files should be in tab deliminated format without header
    # solo_WCGW_mm10.bed    # PMD_mm10.bed  # HMD_mm10.bed  # solo_WCGW_inCommonPMDs_mm10.bed
    # If the files are not tab deliminated you can modify with this codes
    awk '{print $1 "\t" $2 "\t" $3}' solo_WCGW_mm10.bed > solo_WCGW_mm10_tab.bed
    echo -e "track name=my_bed_file description='My BED file'\n$(awk '{print $1 "\t" $2 "\t" $3}' solo_WCGW_inCommonPMDs_mm10.bed)" > solo_WCGW_inCommonPMDs_mm10_tab.bed
    # after formatting your bed files with this code, open your bed files and delete header

# 2- you can use the head and tail commands together with a pipe (|) to check/show both the first few and last few rows of a file in Unix 
    
    { head -n 5 solo_WCGW_mm10.bed; echo "......"; tail -n 5 solo_WCGW_mm10.bed; }

    chr1    3001276 3001278
    chr1    3003378 3003380
    chr1    3005997 3005999
    chr1    3006415 3006417
    chr1    3008544 3008546
    ......
    chr9    124493818       124493820
    chr9    124493917       124493919
    chr9    124494653       124494655
    chr9    124494794       124494796

    { head -n 5 PMD_mm10.bed; echo "......"; tail -n 5 PMD_mm10.bed; }

    chr1    3700000 3800000 PMD     commonPMD
    chr1    4200000 4300000 PMD     commonPMD
    chr1    5700000 5800000 PMD     commonPMD
    chr1    8100000 8200000 PMD     commonPMD
    chr1    8200000 8300000 PMD     commonPMD
    ......
    chr9    112600000       112700000       PMD     commonPMD
    chr9    112700000       112800000       PMD     commonPMD
    chr9    112900000       113000000       PMD     commonPMD
    chr9    113000000       113100000       PMD     commonPMD
    chr9    114200000       114300000       PMD     commonPMD

# 3- by default, 'bedtools intersect' reports the intervals that represent overlaps between your two files
    
    bedtools intersect -a solo_WCGW_mm10.bed -b PMD_mm10.bed | head -n 5
    chr1    3700640 3700642
    chr1    3702033 3702035
    chr1    3702200 3702202
    chr1    3702376 3702378
    chr1    3704094 3704096

# 4- you can save the results to a file
    
    bedtools intersect -a solo_WCGW_mm10.bed -b PMD_mm10.bed > PMD_intersect.bed

    bedtools intersect -a solo_WCGW_mm10.bed -b HMD_mm10.bed > HMD_intersect.bed

# 5- you can use the head and tail commands together with a pipe (|) to check/show both the first few and last few rows of a file in Unix
    
    { head -n 5 PMD_intersect.bed; echo "......"; tail -n 5 PMD_intersect.bed; }

    chr1    3700640 3700642
    chr1    3702033 3702035
    chr1    3702200 3702202
    chr1    3702376 3702378
    chr1    3704094 3704096
    ......
    chr9    114294656       114294658
    chr9    114294926       114294928
    chr9    114295626       114295628
    chr9    114297039       114297041
    chr9    114297177       114297179

# 6- by -v option, you can identify those features in our A file that do not overlap features in the B file
    bedtools intersect -a solo_WCGW_mm10.bed -b PMD_mm10.bed -v | head -n 25
    bedtools intersect -a PMD_intersect.bed -b solo_WCGW_inCommonPMDs_mm10.bed -v | head -n 25
    bedtools intersect -a PMD_intersect.bed -b solo_WCGW_inCommonPMDs_mm10.bed -v > PMD_not_intersect.bed