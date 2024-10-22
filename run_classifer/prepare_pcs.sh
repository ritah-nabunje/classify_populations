#!/bin/bash

# Collect the arguments
NAME=$1
INPUT=$2

VARIANTS="KGP_0.3.prune.in"
REF_AFREQ="KGP_pca.acount"
REF_SCORES="KGP_pca.eigenvec.allele"

# extract required variants 
plink2 --bfile ${INPUT} \
--extract ${VARIANTS} \
--make-bed --out ${NAME}_required_variants

# perform PCA using loadings from the reference PCA
plink2 --bfile ${NAME}_required_variants \
	--read-freq ${REF_AFREQ} \
	--score ${REF_SCORES} 2 5 header-read no-mean-imputation \
	variance-standardize \
	list-variants \
	--score-col-nums 6-15 \
	--out ${NAME}_pcs
