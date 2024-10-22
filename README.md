# classify_populations
Performing PCA-based population inference, utilising PLINK for variant extraction and R for classification with 1000 genomes as a reference.

## Folder Contents
1. ``run_pipeline.sh`` – Main shell script that orchestrates the entire pipeline
2. ``prepare_pcs.sh`` – Script to prepare principal components
3. ``classify.R`` – R script to classify populations based on PCA results and save plots
4. ``random_forest_model.RData`` – Pre-trained random forest model for population inference
5. ``KGP_0.3.prune.in`` – Reference variants file
6. ``KGP_pca.acount`` – Reference allele frequency file
7. ``KGP_pca.eigenvec.allele`` – Reference PCA eigenvectors
8. ``KGP_pca.eigenval`` – Reference PCA eigenvalues

## How to Run
Step 1: Unzip the folder  
Unzip the folder to any directory on your system. The pipeline will run in the unzipped directory, so no additional configuration is required.  
> ``unzip run_classifier.zip``
> 
> ``cd run_classifier``

Step 2: Edit ``run_pipeline.sh``  
First, edit the slurm details accordingly. Then, provide study name and link to input data.  

The input data should be in Plink binary format (.bed, .bim, .fam). Provide name of study and the link to your input files (edit Line 21 and 22 of run_population_classifier.sh).  

Step 3: Run the pipeline  
Submit the pipeline using the run_pipeline.sh script. (Ensure you have the necessary permissions to run the script: ``chmod +x run_pipeline.sh`` )  
> ``sbatch run_pipeline.sh``
or
> ``bash run_pipeline.sh`` if not submitting to a slurm scheduler
or edit to use your job scheduler
 
This will run the entire pipeline, starting with preparing PCs from your data and then classifying populations using the pre-trained model.

## Output
- Population group classifications will be saved in .tsv files (e.g. EUR.tsv, AFR.tsv).
- Population plots will be saved as .png images (e.g. prob0.5.png).
- All output files will be saved in the same directory as the scripts.

## Contact
If you encounter any issues or have questions, feel free to contact Ritah via ritahnabunje@gmail.com. 

Best wishes!
