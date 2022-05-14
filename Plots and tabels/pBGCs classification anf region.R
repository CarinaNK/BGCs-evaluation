rm(list = ls(all.names = TRUE))

library(data.table) 
library(splitstackshape)
library(tidyr)
library(ggplot2)
require(plyr) 
library(dplyr) 
library(ggpubr)
library(viridis)



# Dataframe of phages pBGCS
df <- read.csv("C:/Users/cnkho/Downloads/summary.csv", header = F) # Data
df <-  cSplit(df, "V3", " ", type.convert = F)


# Classification of pBGCs
sub <- function(x)  gsub('NRPS-like|thioamide-NRP', 'NRPS',
                         gsub('T1PKS|T2PKS|T3PKS|hglE-PKS|transAT-PKS|transAT-PKS-like|PpyS-KS|otherks', 'polyketides',
                              gsub('RiPP-like|lanthipeptide|lanthipeptide-class-i|lanthipeptide-class-ii|lanthipeptide-class-iii|lanthipeptide-class-iv|lanthipeptide-class-v|thiopeptide|lassopeptide|sactipeptide|microviridin|proteusin|microcin|bottromycin|fungal-RiPP|RaS-RiPP|spliceotide|thioamitides|ranthipeptide|lipolanthine', 'RiPP',
                                   gsub('siderophore|hserlactone|arylpolyene|ectoine|butyrolactone|phosphonate|resorcinol|ladderane|phenazine|melanin|acyl_amino_acids|indole|cyanobactin|PUFA|oligosaccharide|amglyccycl|nucleoside|linaridin|blactam|aminocoumarin|guanidinotides|fused|phosphoglycolipid|furan|glycocin|PBDE|betalactone|CDPS|cyclic-lactone-autoinducer|epipeptide|halogenated|LAP|NAGGN|NAPAA|pyrrolidine|redox-cofactor|RRE-containing|tropodithietic-acid|fatty_acid', 'other', x))))

subbycol <- colwise(sub, .cols=c("V3_1", "V3_2", "V3_3"))

dfBGC <- subbycol(df) 
setDT(dfBGC)


# Count the instances of pBGCs
lookup <- melt(dfBGC, measure.vars = paste0("V3_", 1:3))[, .N, by = value]
lookup <- lookup[-5,] 
lookup$freq <- lookup$N/sum(lookup$N) # convert to %


lookup %>% # plot over pBGCs in the gut metagenomes
  ggplot( aes(x=value, y=freq, fill=value)) +
  geom_bar(stat="identity", alpha=.6, width=.4) +
  coord_flip() +
  theme(legend.position="none",axis.title=element_text(size=14,face="bold"), axis.text=element_text(size=12)) +
  labs(x = "", y = "% of all BGCs in MAGs")





# Dataframe of information to each genome

dF <- read.table(file = 'C:/Users/cnkho/Downloads/GPD_metadata.tsv', sep = '\t', header = TRUE, fill = TRUE)


# Take only those with BGCs
D <- cbind(df$V2,dfBGC)
pRiPP<- c(D[which(D$V3_1=="RiPP"),1],D[which(D$V3_2=="RiPP"),1],D[which(D$V3_3=="RiPP"),1])
pOther<- rbind(D[which(D$V3_1=="other"),1],D[which(D$V3_2=="other"),1],D[which(D$V3_3=="other"),1])
pNRPS<- rbind(D[which(D$V3_1=="NRPS"),1],D[which(D$V3_2=="NRPS"),1],D[which(D$V3_3=="NRPS"),1])
pPolyke<- rbind(D[which(D$V3_1=="polyketides"),1],D[which(D$V3_2=="polyketides"),1],D[which(D$V3_3=="polyketides"),1])


dFRIPP <- dF[dF$GPD_id %in% pRiPP[["V1"]],]
dFOther <- dF[dF$GPD_id %in% pOther[["V1"]],]
dFNRPS <- dF[dF$GPD_id %in% pNRPS[["V1"]],]
dFPolyke <- dF[dF$GPD_id %in% pPolyke[["V1"]],]


# Exstract the countries the phages is seen in
xRiPP <- cSplit(dFRIPP, "Continents_detected", ",", type.convert = F)
xOther <- cSplit(dFOther, "Continents_detected", ",", type.convert = F)
xNRPS <- cSplit(dFNRPS, "Continents_detected", ",", type.convert = F)
xPolyke <- cSplit(dFPolyke, "Continents_detected", ",", type.convert = F)

xRiPP <- xRiPP[,17:ncol(xRiPP)]
xOther <- xOther[,17:ncol(xOther)]
xNRPS <- xNRPS[,17:ncol(xNRPS)]
xPolyke <- xPolyke[,17:ncol(xPolyke)]

xRiPP[is.na(xRiPP)] = "s"
xOther[is.na(xOther)] = "s"
xNRPS[is.na(xNRPS)] = "s"
xPolyke[is.na(xPolyke)] = "s"


# Dataframe for plot
countinent <- c(rep("South America" , 4) , rep("Oceania" , 4) , rep("North America" , 4) , rep("Europe" , 4), rep("Asia" , 4), rep("Africa" , 4) )
BGCs <- rep(c("other" , "RiPP" , "NRPS", "polyktides") , 6)
Amount <- c(sum(xOther=="South America"), sum(xRiPP=="South America"), sum(xNRPS=="South America"), sum(xPolyke=="South America"), sum(xOther=="Oceania"), sum(xRiPP=="Oceania"), sum(xNRPS=="Oceania"), sum(xPolyke=="Oceania"), sum(xOther=="North America"), sum(xRiPP=="North America"), sum(xNRPS=="North America"), sum(xPolyke=="North America"), sum(xOther=="Europe"), sum(xRiPP=="Europe"), sum(xNRPS=="Europe"), sum(xPolyke=="Europe"), sum(xOther=="Asia"), sum(xRiPP=="Asia"), sum(xNRPS=="Asia"), sum(xPolyke=="Asia"),sum(xOther=="Africa"), sum(xRiPP=="Africa"), sum(xNRPS=="Africa"), sum(xPolyke=="Africa"))
data <- data.frame(countinent,BGCs,Amount)

# Stacked
p1 <- ggplot(data, aes(fill=BGCs, y=Amount, x=countinent)) + 
  geom_bar(position="stack", stat="identity") +
  scale_fill_viridis(discrete = T) +
  theme(axis.title=element_text(size=14,face="bold"), axis.text=element_text(size=12)) +
  xlab("")

# Stacked + percent
p2 <- ggplot(data, aes(fill=BGCs, y=Amount, x=countinent)) + 
  geom_bar(position="fill", stat="identity") +
  scale_fill_viridis(discrete = T) +
  theme(legend.position = "bottom",axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold")) +
  xlab("") + ylab("Percentage")


ggarrange(p1 + rremove("legend"), p2 , 
          labels = c("A", "B"),
          ncol = 1, nrow = 2)



allphag=dF
allphag=allphag[,"Continents_detected"]

count=data.frame(table(unlist(strsplit(tolower(allphag), ","))))
allphagnoncont=count[4,]
count=count[-4,]

SA <- c(Amount[1:4])
Oc <- c(Amount[5:8])
NoA <- c(Amount[9:12])
Eu <- c(Amount[13:16])
As <- c(Amount[17:20]) 
Af <- c(Amount[21:24])
S=c(sum(xRiPP=="s"), sum(xOther=="s"), sum(xPolyke=="s"), sum(xNRPS=="s"))

total=Oc+NoA+Eu+As+Af

# prop test for total proportions of total, vs continent. this data does have duplicates.

allvSA=prop.test(matrix(data=c(sum(total),sum(count[,2]),sum(SA),count[6,2]),nrow=2))
allvOc=prop.test(matrix(data=c(sum(total),sum(count[,2]),sum(Oc),count[5,2]),nrow=2))
allvNoA=prop.test(matrix(data=c(sum(total),sum(count[,2]),sum(NoA),count[4,2]),nrow=2))
allvEu=prop.test(matrix(data=c(sum(total),sum(count[,2]),sum(Eu),count[3,2]),nrow=2))
allvAs=prop.test(matrix(data=c(sum(total),sum(count[,2]),sum(As),count[2,2]),nrow=2))
allvAf=prop.test(matrix(data=c(sum(total),sum(count[,2]),sum(Af),count[1,2]),nrow=2))


# now pairwise comparison
continentaltotals=matrix(data=c(sum(SA),count[6,2],sum(Oc),count[5,2],sum(NoA),count[4,2],sum(Eu),count[3,2],sum(As),count[2,2],sum(Af),count[1,2]),nrow = 2)
colnames(continentaltotals)=c("SA","Oc","NoA","Eu","As","Af")

alltable=as.data.frame(c(allvSA$p.value,allvOc$p.value,allvNoA$p.value,allvEu$p.value,allvAs$p.value,allvAf$p.value))
alltable<- cbind(alltable, c((sum(SA)/count[6,2])/(sum(total/sum(count[,2]))), (sum(Oc)/count[5,2])/(sum(total/sum(count[,2]))), (sum(NoA)/count[4,2])/(sum(total/sum(count[,2]))), (sum(Eu)/count[3,2])/(sum(total/sum(count[,2]))), (sum(As)/count[2,2])/(sum(total/sum(count[,2]))), (sum(Af)/count[1,2])/(sum(total/sum(count[,2])))))
colnames(alltable)=c("pvalue", "prop")
rownames(alltable)=c("allvSA","allvOc","allvNoA","allvEu","allvAs","allvAF")

for (i in 1:6){
  for (j in i:6){
    if (i==j){
      next
      
    }
    else{
      
      test=prop.test(matrix(data=c(continentaltotals[,i],continentaltotals[,j]),nrow = 2))
      print(test$p.value)
      alltable=rbind(alltable,c(test$p.value, (continentaltotals[1,j]/continentaltotals[2,j])/(continentaltotals[1,i]/continentaltotals[2,i])))
      name=paste("allbgcs",colnames(continentaltotals)[i],"v",colnames(continentaltotals)[j])
      rownames(alltable)[nrow(alltable)]=name
      
    }
  }
}



# prop test for individual bgcs out of all bgcs vs the same in given continent.
# order Ripp, Other Nrps, Polyketide
continentalbgcs=matrix(data=c(SA,Oc,NoA,Eu,As,Af),nrow=4)
colnames(continentalbgcs)=c("SA","Oc","NoA","Eu","As","Af")
rownames(continentalbgcs)=c('Ripp','Other','Nrps','polyketide')
for (i in 1:6) {
  for (j in i:6){
    if (i==j){
      next
      
    }
    else{
      for (r in 1:4){
        Matrix <- matrix(data=c(continentalbgcs[r,i],sum(continentalbgcs[,i]),continentalbgcs[r,j],sum(continentalbgcs[,j])),nrow = 2)
        if (rowSums(Matrix)[1]==0){
          alltable=rbind(alltable,c("ND", "ND"))
        }
        else{
          test=prop.test(Matrix)
          alltable=rbind(alltable,c(test$p.value, (continentalbgcs[r,j]/sum(continentalbgcs[,j]))/(continentalbgcs[r,i]/sum(continentalbgcs[,i]))))
        }
        
        name=paste(rownames(continentalbgcs)[r],colnames(continentalbgcs)[i],"v",colnames(continentalbgcs)[j])
        rownames(alltable)[nrow(alltable)]=name
        
      }
    }
  }
}

adjusted=p.adjust(alltable$pvalue,"BH") #adjust p-values with BH
alltableadjusted=alltable
alltableadjusted$pvalue=adjusted
alltableadjusted[which(alltableadjusted$pvalue>0.05),]=data.frame("NS","NS")

