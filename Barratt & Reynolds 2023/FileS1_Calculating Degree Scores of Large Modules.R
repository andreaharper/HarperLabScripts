#R Script to calculate degree scores of large modules

#load required packages
library(tidyr)
library(magrittr)
library(dplyr)

#read in Cytoscape module edge file
module <- read.delim("CytoscapeInput-edges-MODULENAME.txt")

#check first few lines of dataset
head(module)

#create subset of only genes in "from" column
from <- as.data.frame(module$fromNode)
head(from)

#create subset of only genes in "to" column
to <- as.data.frame(module$toNode)
head(to)

#merge these datasets
list <- cbind(to, from)
head(list)

#rename column names
colnames(list)[1]  <- "list_to" 
colnames(list)[2]  <- "list_from" 
head(list)

#convert to long format so all gene names are in one column
list1 <- gather(list, to_or_from, gene, list_to:list_from, factor_key = T)
head(list1)

#count frequency of each gene name in the column - i.e. calculate degree score
counts <- as.data.frame(table(list1$gene))
head(counts)

#rename column names
colnames(counts)[1]  <- "Gene" 
colnames(counts)[2]  <- "Degree_Score"
head(counts)

#order genes from highest score to lowest
ord_counts <- counts %>% 
  arrange(desc(Degree_Score))
head(ord_counts)

#write degree scores file
write.csv(ord_counts, "MODULE NAME degree scores.csv", row.names = FALSE)