#!/bin/bash

#SBATCH --job-name=xxxx  
#SBATCH --time=6:00:00
#SBATCH --mem=100G
#SBATCH --account=gen1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=xxzz@le.ac.uk
#SBATCH --error=xxxx.err
#SBATCH --output=xxxx.out

# Load required modules
module load plink2
module load R

# set the working directory to the location of this script
WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $WORKDIR

# inputs
NAME="study_name"              # set the study name
INPUT="/path/to/data"          # provide path to input data directory

# Export variables
export NAME
export INPUT

# Step 1: prepare study PCs
echo "Running prepare_pcs.sh..."
bash prepare_pcs.sh $NAME $INPUT

# Step 2: assign population groups
echo "Running classify.R..."
Rscript classify.R $NAME


