# -*- coding: utf-8 -*-
"""
Created on Wed Mar  9 14:04:19 2022

@author: signe
"""

# summary file creation
import os
from Bio import SeqIO
import csv

dirpath= format(os.getcwd())
dirs=next(os.walk('{}/anti_out'.format(dirpath)))[1]
ext=('.gbk')

# create our summary file
with open('summary.csv', 'w') as fp:
    pass

for f in dirs:
  onlyfiles = next(os.walk("{dpath}/anti_out/{fil}".format(dpath=dirpath,fil=f)))[2]
  for files in onlyfiles :
      if files.endswith(ext): 
          record= SeqIO.read("{path}/{dirs}/{fils}".format(path=dirpath,dirs=f,fils=files), "genbank")
          my_gene=record.features[1]
          produkt=my_gene.qualifiers["product"]
          name=os.path.basename(files)
          prods=' '.join(produkt)
             #Open csv file, write variables, close csv file
          storefile = csv.writer(open("summary.csv",'a'))
          storefile.writerow([name,record.description,prods])
         
                
 
      