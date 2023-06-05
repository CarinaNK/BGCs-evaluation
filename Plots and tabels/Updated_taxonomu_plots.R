rm(list = ls())
library(data.table) 
library(dplyr)
library(ggrepel)
library(treemapify)
library(hrbrthemes)
library(RColorBrewer)
library(treemap)


# dataframe of Blast results
df <- read.csv("C:/Users/cnkho/Downloads/blastres/blastres/combined.txt", header = F, sep="")

# dataframe of phage database
dfPhag <- read.csv(gzfile("C:/Users/cnkho/Downloads/1May2023_data.tsv.gz"), "\t", header = T)
dfPhag <- dfPhag[, c("Accession", "Genus", "Family", "Order", "Host")]


df3 <- c()
for (i in 1:length(unique(df$V1))){
  nam <- paste(unique(df$V1)[i], sep = "")
  df1 <- df[df$V1==nam, ]
  for (n in 1:length(unique(df1$V2)))
    nam <- paste(unique(df1$V2)[n], sep = "")
    df2 <- df1[df1$V2==nam, ]
    df3 <- rbind(df3, cbind(df2$V1, df2$V2, sum(df2$V4)))
  
}


df3<-as.data.frame(df3)
df3 <- df3 %>% distinct()
write.csv(df3, "C:/Users/cnkho/Downloads/blastres.csv", row.names=FALSE) # use code for cytoscape

tax <- c()

# Sort the genomes into their viral Custer and add their phage accession codes
for(i in 1:length(df$V2)) { 
  

  tax <- rbind(tax,cbind(dfPhag[dfPhag$Accession %in% df3[i,2],],df3[i,1], df3[i,3])) 

}

tax<-as.data.frame(tax)


# Filter so only coverage over 2000 bp is contained
phagtax <- tax[tax$`df3[i, 3]`>2000,]
tax <- tax[tax$`df3[i, 3]`<2000,]

# dataframe of the original study predicted host
DF <- read.table(file = 'C:/Users/cnkho/Downloads/co_occurrence_analysis.txt', sep = '\t', header = TRUE, fill = TRUE)
h1 <- DF[DF$uvig %in% phagtax$`df3[i, 1]`,] # Find all phages from source data, with  corresponding ID as our data.
h2 <- as.data.frame(phagtax[phagtax$`df3[i, 1]` %in% h1$uvig,]) # Ensure same genomes in our list, with the same ordering.
h1 <- h1[order(h1$uvig),]
h2 <- h2[order(unlist(h2$`df3[i, 1]`)),]
H<- cbind(h1$uvig, h2$V1, h1$predicted_host, h2$Host) #  Combine the predicted host organism from both studies.
H[which(h2$Host==h1$predicted_host),] # Find identical predictions


# Make dataframe for plots (host)
host <- as.data.frame(table(unlist(phagtax$Host)))
host <-rbind(host, data.frame(Var1 = c('No alignment'), Freq = length(tax$Host)))
host$fraction <- host$Freq / sum(host$Freq)

# mutate(host,
#        state = case_when(
#          Var1=="Acidithiobacillus" ~ "non-pathogenic",
#          Var1=="Aeromonas" ~ "pathogenic",
#          Var1=="Arthrobacter" ~ "neither",
#          Var1=="Bacillus" ~ "non-pathogenic",
#          Var1=="Bacteroides" ~ "pathogenic",
#          Var1=="Burkholderia" ~ "pathogenic",
#          Var1=="Buttiauxella" ~ "pathogenic",
#          Var1=="Butyrivibrio" ~ "non-pathogenic",
#          Var1=="Campylobacter" ~ "neither",
#          Var1=="Citrobacter" ~ "neither",
#          Var1=="Clostridioides" ~ "pathogenic",
#          Var1=="Clostridium" ~ "pathogenic",
#          Var1=="Eggerthella" ~ "pathogenic",
#          Var1=="Enterobacter" ~ "neither",
#          Var1=="Enterococcus" ~ "pathogenic",
#          Var1=="Erwinia" ~ "pathogenic",
#          Var1=="Erysipelothrix" ~ "pathogenic",
#          Var1=="Escherichia" ~ "non-pathogenic",
#          Var1=="Exiguobacterium" ~ "neither",
#          Var1=="Faecalibacterium" ~ "non-pathogenic",
#          Var1=="Flavobacterium" ~ "non-pathogenic",
#          Var1=="Fusobacterium" ~ "pathogenic",
#          Var1=="Gordonia" ~ "pathogenic",
#          Var1=="Hafnia" ~ "neither",
#          Var1=="Klebsiella" ~ "pathogenic",
#          Var1=="Lactobacillus" ~ "non-pathogenic",
#          Var1=="Listeria" ~ "neither",
#          Var1=="Moraxella" ~ "neither",
#          Var1=="Mycobacterium" ~ "neither",
#          Var1=="Paenibacillus" ~ "neither",
#          Var1=="Parageobacillus" ~ "non-pathogenic",
#          Var1=="Peptoclostridium" ~ "pathogenic",
#          Var1=="Polaribacter" ~ "non-pathogenic", #check maybe
#          Var1=="Providencia" ~ "neither",
#          Var1=="Pseudomonas" ~ "neither",
#          Var1=="Psychrobacillus" ~ "non-pathogenic", #check maybe
#          Var1=="Roseburia" ~ "non-pathogenic",
#          Var1=="Ruminococcus" ~ "neither",
#          Var1=="Salmonella" ~ "pathogenic",
#          Var1=="Serratia" ~ "neither",
#          Var1=="Solobacterium" ~ "neither",
#          Var1=="Staphylococcus" ~ "neither",
#          Var1=="Stenotrophomonas" ~ "neither",
#          Var1=="Streptococcus" ~ "neither",
#          Var1=="Streptomyces" ~ "neither",
#          Var1=="Synechococcus" ~ "non-pathogenic", #check maybe
#          Var1=="Thermus" ~ "non-pathogenic",
#          Var1=="Unspecified" ~ "not determined",
#          Var1=="Vibrio" ~ "neither",
#          Var1=="wolbachia" ~ "non-pathogenic",
#          Var1=="No alignment" ~ "not determined"
#        ))

host <- data.frame(host,state =c("non-pathogenic","pathogenic", "neither","non-pathogenic","pathogenic", "pathogenic","pathogenic","non-pathogenic","neither", "neither","pathogenic", "pathogenic","pathogenic", "neither","pathogenic","pathogenic","pathogenic","non-pathogenic", "neither","non-pathogenic","non-pathogenic", "pathogenic","pathogenic","neither","pathogenic","non-pathogenic","neither","neither", "neither","neither","non-pathogenic","pathogenic","non-pathogenic", "neither","neither","non-pathogenic","non-pathogenic", "neither","pathogenic","neither","neither","neither","neither","neither", "neither","non-pathogenic","non-pathogenic","not determined","neither","non-pathogenic", "not determined"))


tm <- treemap(dtf = host,
              index = c("state", "Var1"),
              vSize = "fraction",
              vColor = "state",
              title = "")

tm_plot_data <- tm$tm %>%
  mutate(x1 = x0 + w,
         y1 = y0 + h) %>%
  mutate(primary_group = ifelse(is.na(Var1), 1.2, .5)) %>%
  mutate(color = ifelse(is.na(Var1), NA, color))

tm_plot_data<- tm_plot_data[-which(is.na(tm_plot_data$Var1)), ]

tm_plot_data$label <- paste0(tm_plot_data$Var1, "\n Freq: ", round(tm_plot_data$vSize,2))

ggplot(tm_plot_data, aes(xmin = x0, ymin = y0, xmax = x1, ymax = y1)) +
  geom_rect(aes(fill = color, size = primary_group),
            show.legend = FALSE, color = "black", alpha = .3) +
  scale_fill_identity() +
  scale_size(range = range(tm_plot_data$primary_group)) +
  ggfittext::geom_fit_text(aes(label = label), min.size = 1) +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_void()



# 
# # Make dataframe for plots (family)
# family <- as.data.frame(table(unlist(phagtax$Family)))
# family$fraction <- family$Freq / sum(family$Freq)
# 
# # Cumulative percentages
# family$ymax <- cumsum(family$fraction)
# 
# # Bottom of each rectangle
# family$ymin <- c(0, head(family$ymax, n=-1))
# 
# # Label position
# family$labelPosition <- (family$ymax + family$ymin) / 2
# 
# # Label
# family$label <- paste0(family$Var1, "\n value: ", family$Freq)
# 
# # Make the plot
# ggplot(family, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Var1)) +
#   geom_rect() +
#   geom_label_repel( x=3.5, aes(y=labelPosition, label=label), fontface = "bold", size = 3) +
#   #scale_fill_brewer(palette=15) +
#   coord_polar(theta="y") +
#   xlim(c(2, 4)) +
#   theme_void() +
#   theme(legend.position = "right")
# 
# # Add label position
# family <- family %>%
#   arrange(desc(family)) %>%
#   mutate(lab.ypos = cumsum(fraction) - 0.5*fraction)
# family
# 
# mycols <- c("#FFC20A", "#0C7BDC", "#994F00", "#E1BE6A", '#E66100', '#40B0A6', '#5D3A9B', '#1AFF1A', '#FEFE62', '#4B0092', '#D35FB7', '#D41159', "#DC3220", '#35ab41')
# 
# ggplot(family, aes(x = 2, y = fraction, fill = Var1)) +
#   geom_bar(stat = "identity", color = "white") +
#   coord_polar(theta = "y", start = 0)+
#   geom_text(aes(y = lab.ypos, label = Freq), color = "white")+
#   #scale_fill_manual(values = mycols) +
#   theme_void()+
#   xlim(0.5, 2.5)
# 
# 
# # Make dataframe for plots (order)
# order <- as.data.frame(table(unlist(phagtax$Order)))
# order$fraction <- order$Freq / sum(order$Freq)
# 
# # Cumulative percentages 
# order$ymax <- cumsum(order$fraction)
# 
# # Bottom of each rectangle
# order$ymin <- c(0, head(order$ymax, n=-1))
# 
# # Label position
# order$labelPosition <- (order$ymax + order$ymin) / 2
# 
# # Label
# order$label <- paste0(order$Var1, "\n value: ", order$Freq)
# 
# # Make the plot
# ggplot(order, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Var1)) +
#   geom_rect() +
#   geom_label_repel( x=3.5, aes(y=labelPosition, label=label), fontface = "bold") +
#   #scale_fill_brewer(palette=16) +
#   coord_polar(theta="y") +
#   xlim(c(2, 4)) +
#   theme_void() +
#   theme(legend.position = "none")


# Make dataframe for plots (genus)
Genus <- as.data.frame(table(unlist(phagtax$Genus)))
Genus <-rbind(Genus, data.frame(Var1 = c('No alignment'), Freq = length(tax$Genus)))
Genus$fraction <- Genus$Freq / sum(Genus$Freq)


tm <- treemap(dtf = Genus,
              index = c("Var1"),
              vSize = "fraction",
              vColor = "state",
              title = "")

tm_plot_data <- tm$tm %>%
  mutate(x1 = x0 + w,
         y1 = y0 + h) %>%
  mutate(primary_group = ifelse(is.na(Var1), 1.2, .5)) %>%
  mutate(color = ifelse(is.na(Var1), NA, color))

tm_plot_data$label <- paste0(tm_plot_data$Var1, "\n Freq: ", round(tm_plot_data$vSize,2))

ggplot(tm_plot_data, aes(xmin = x0, ymin = y0, xmax = x1, ymax = y1)) +
  geom_rect(aes(fill = color, size = primary_group),
            show.legend = FALSE, color = "black", alpha = .3) +
  scale_fill_identity() +
  scale_size(range = range(tm_plot_data$primary_group)) +
  ggfittext::geom_fit_text(aes(label = label), min.size = 1) +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_void()

