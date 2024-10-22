# population inference using reference classifier at a given probability threshold

# Collect the study name from the command line
args <- commandArgs(trailingOnly = TRUE)
NAME <- args[1]


# thresholds to check
thresholds <- c(0.5)

# population groups (lists to save)
populations <- c("EUR", "AFR", "AMR", "EAS", "SAS")

library(dplyr)
library(data.table)
library(ggplot2)

# Load the the rf model from the file
load("random_forest_model.RData")

# Study PCs
study <- read.table(paste0(NAME, "_pcs.sscore"))
for (i in 1:10){names(study)[i+4] <- paste0("PC", i)}
study_pcs <- study %>% select(1,2,(1+4):ncol(study))

#----- adjust the study PCs to same scale as ref PCs using ref eigen valuess
eigen_vals <- read.table("KGP_pca.eigenval")

# adjusting UKB PCs to ref scale
study_cPCs <- study_pcs[,c(1,2,ncol(study_pcs))]
for (i in 1:10){
  study_cPCs[2+i] <- study_pcs[,paste0("PC", i)]/(-sqrt(eigen_vals[i,])/2)
  names(study_cPCs)[2+i] <- paste0("PC", i)
}

#---- population inference
pred_pop <- predict(rf_model, study_cPCs, type="prob")

study_grouped <- cbind(study_cPCs,pred_pop)

# Function to assign the population based on threshold
assign_population <- function(data, threshold) {
  pred <- rep("NA", nrow(data))
  pred <- ifelse(data$AFR > threshold, "AFR", pred)
  pred <- ifelse(data$EUR > threshold, "EUR", pred)
  pred <- ifelse(data$AMR > threshold, "AMR", pred)
  pred <- ifelse(data$EAS > threshold, "EAS", pred)
  pred <- ifelse(data$SAS > threshold, "SAS", pred)
  return(pred)
}

# Loop over the thresholds and assign populations
for (threshold in thresholds) {
  pred_column <- paste0("pred", threshold)
  study_grouped[[pred_column]] <- assign_population(study_grouped, threshold)
}

#------------create and save plots for each threshold
#Colour Palette
pal <- c(
  "AFR" = "#E41A1C",
  "EUR" = "#377EB8", 
  "AMR" = "#4DAF4A", 
  "EAS" = "#FF7F00",
  "SAS" = "#984EA3",
  "NA" = "grey"
)

for (threshold in thresholds) {
  # column name based on the threshold
  pred_column <- paste0("pred", threshold)
  
  # plot for each threshold
  p <- ggplot(study_grouped, aes_string(x = "PC1", y = "PC2", color = pred_column)) +
    geom_point() +
    theme_classic() +
    scale_color_manual(values = pal, limits = names(pal)) +
    guides(color = guide_legend(title = "Population")) +
    theme(text = element_text(size = 9)) +
    ggtitle(paste("Prob >", threshold))
  
  # Save the plot 
  ggsave(paste0("prob", threshold, ".png"), plot = p, width = 6, height = 4, dpi = 300)
}

#------------- Save grouped populations
names(study_grouped)[c(1,2)] <- c("IID", "FID")
write.table(study_grouped, file = "grouped.tsv", sep = "\t", row.names = FALSE, quote = FALSE)

# Loop through each population group
for (pop in populations) {
  # Subset for a population group
  pop_data <- subset(study_grouped, study_grouped$pred0.5 == pop) %>%
              select("IID", "FID")
  
  # Write population list
  write.table(pop_data, file = paste0(pop, ".tsv"), sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)
}
