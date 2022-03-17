# -*- coding: utf-8 -*-
"""
Created on Wed Mar  9 14:04:19 2022

@author: signe
"""

# summary file creation
import os
from Bio import SeqIO

dirpath= format(os.getcwd())
dirs=next(os.walk('{}/anti_out'.format(dirpath)))[1]
ext=('.gbk')

# create our summary file
with open('summary.txt', 'w') as fp:
    pass

for f in dirs:
  onlyfiles = next(os.walk("{dpath}/anti_out/{fil}".format(dpath=dirpath,fil=f)))[2]
  for files in onlyfiles :
      if files.endswith(ext): 
          record= SeqIO.read("{path}/{dirs}/{fils}".format(path=dirpath,dirs=f,fils=files), "genbank")
          my_gene=record.features[1]
          produkt=my_gene.qualifiers["product"]
          name=os.path.basename(files)
          prods='\n'.join(produkt)
             #Open csv file, write variables, close csv file
          storefile = open("summary.txt",'a')
          storefile.write(name +"\n")
          storefile.write(record.description +"\n")
          storefile.write(prods +"\n")
          storefile.close() 

                
 
      