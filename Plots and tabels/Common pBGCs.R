rm(list=ls())
   library(data.table) 
   library(splitstackshape)
   library(tidyr)
   library(ggplot2)
   require(plyr) 
   library(dplyr) 
   library(ggrepel)

   

# Dataframe of phages BGCS
df <- read.csv("C:/Users/cnkho/Downloads/summary.csv", header = F) # Data
df <-  cSplit(df, "V3", " ", type.convert = F)
length(unique(df$V2))

# Dataframe of information to each genome
dF <- read.table(file = 'C:/Users/cnkho/Downloads/GPD_metadata.tsv', sep = '\t', header = TRUE, fill = TRUE)


# Find each country genome is located in
pBGC <- dF[dF$GPD_id %in% df$V2,]
location <- cSplit(pBGC, "Countries_detected", ",", type.convert = F)
location <- location[,17:ncol(location)]


# Find the amount of prophages
length(which(pBGC$checkV_prophage=='Yes'))/nrow(pBGC)
length(which(dF$checkV_prophage=='Yes'))/nrow(dF)




# Omit replicates in each country
countCoun <- c()

for (i in (1:nrow(location))){
  countCoun <- qpcR:::rbind.na(countCoun,unique(na.omit(as.character(location[i,]))))
  
}

countCoun <- countCoun[-1,]



# Measure which pBGCs are most spread across borders
abunpBGCs <- pBGC[which(rowSums(!is.na(countCoun))>=quantile(rowSums(!is.na(countCoun)),probs = 0.95)),]
abunpBGCs <- df[df$V2 %in% abunpBGCs$GPD_id,]
dat <- as.data.frame(table(unlist(abunpBGCs[, c("V3_1", "V3_2", "V3_3")])))
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
  scale_fill_brewer(palette=4) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme_void() +
  theme(legend.position = "none") 
