rm(list = ls())
library(data.table) 
library(dplyr)
library(ggrepel)
library(treemapify)
library(hrbrthemes)
library(RColorBrewer)

# Dataframe of viral clusters in phages
df <- read.csv("C:/Users/cnkho/Downloads/vout/vout/genome_by_genome_overview.csv", header = T)
df <- df[, c("Genome", "preVC")]

# Dataframe of phage database
dfPhag <- read.csv("C:/Users/cnkho/Downloads/phage_data.tsv", "\t", header = T)
dfPhag <- dfPhag[, c("Accession", "Genus", "Family", "Order", "Host")]

# Dataframe of information to each genome
dF <- read.table(file = 'C:/Users/cnkho/Downloads/GPD_metadata.tsv', sep = '\t', header = TRUE, fill = TRUE)
dF <- dF[dF$GPD_id %in% df$Genome,]


phagtax <- c()

# Sort the genomes into their viral Custer and add their phage accession codes
for(i in 0:105) { 
  
  VC <- paste("preVC_", i, sep = "")
  dfVC <- df[df$preVC==VC, ]
  if (nrow(dfVC)==0) next
  
  
  for (n in (1:nrow(dfVC))){
    
    dir <- paste("C:/Users/cnkho/Downloads/blastresults/blastresults/",dfVC[n,1],".txt", sep = "")
    
    if (file.info(dir)$size!=0){ # Check if Custer exist
      BLAST <- read.csv(dir, header = F, sep="")
      
      if (!is.na(BLAST[1,2])){  # Check if Blast has resulted in an output
        phagtax <- rbind(phagtax,c(dfVC[n,1], dfPhag[dfPhag$Accession %in% BLAST[1,2],], VC, nrow(dfVC), sum(BLAST[,4]))) 
        
      }
    }
    
  }
}

phagtax<-as.data.frame(phagtax)


# Filter so only coverage over 2000 bp is contained
phagtax <- phagtax[phagtax$V9>2000,]


# Dataframe of the original study predicted host
DF <- read.table(file = 'C:/Users/cnkho/Downloads/co_occurrence_analysis.txt', sep = '\t', header = TRUE, fill = TRUE)
h1 <- DF[DF$uvig %in% phagtax$V1,] # Find all phages from source data, with  corresponding ID as our data.
h2 <- as.data.frame(phagtax[phagtax$V1 %in% h1$uvig,]) # Ensure same genomes in our list, with the same ordering.
h1 <- h1[order(h1$uvig),]
h2 <- h2[order(unlist(h2$V1)),]
H<- cbind(h1$uvig, h2$V1, h1$predicted_host, h2$Host) #  Combine the predicted host organism from both studies.
H[which(h2$Host==h1$predicted_host),] # Find identical predictions


# Make dataframe for plots (host)
dat <- as.data.frame(table(unlist(phagtax$Host)))
dat$fraction <- dat$Freq / sum(dat$Freq)

# Number of colors you want
nb.cols <- length(dat$Var1)
mycolors <- colorRampPalette(brewer.pal(8, "Set3"))(nb.cols)
dat$label <- paste0(dat$Var1, "\n Freq: ", round(dat$fraction,2))

ggplot(dat, 
       aes(fill = Var1, 
           area = Freq, 
           label = label)) +
  geom_treemap() + 
  geom_treemap_text(colour = "black", 
                    place = "centre") +
  scale_fill_manual(values = mycolors) +
  theme(legend.position = "none")




# Make dataframe for plots (family)
dat <- as.data.frame(table(unlist(phagtax$Family)))
dat$fraction <- dat$Freq / sum(dat$Freq)

# Cumulative percentages
dat$ymax <- cumsum(dat$fraction)

# Bottom of each rectangle
dat$ymin <- c(0, head(dat$ymax, n=-1))

# Label position
dat$labelPosition <- (dat$ymax + dat$ymin) / 2

# Label
dat$label <- paste0(dat$Var1, "\n value: ", dat$Freq)

# Make the plot
ggplot(dat, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Var1)) +
  geom_rect() +
  geom_label_repel( x=3.5, aes(y=labelPosition, label=label), fontface = "bold") +
  scale_fill_brewer(palette=15) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "none")



# Make dataframe for plots (order)
dat <- as.data.frame(table(unlist(phagtax$Order)))
dat$fraction <- dat$Freq / sum(dat$Freq)

# Cumulative percentages 
dat$ymax <- cumsum(dat$fraction)

# Bottom of each rectangle
dat$ymin <- c(0, head(dat$ymax, n=-1))

# Label position
dat$labelPosition <- (dat$ymax + dat$ymin) / 2

# Label
dat$label <- paste0(dat$Var1, "\n value: ", dat$Freq)

# Make the plot
ggplot(dat, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Var1)) +
  geom_rect() +
  geom_label_repel( x=3.5, aes(y=labelPosition, label=label), fontface = "bold") +
  scale_fill_brewer(palette=16) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "none")
