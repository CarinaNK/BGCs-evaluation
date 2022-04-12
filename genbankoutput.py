# -*- coding: utf-8 -*-
"""
Created on Mon Mar  7 09:09:03 2022

@author: signe
"""

# copies the sequence file and then removes it from folder.
import os
import shutil

dirpath= format(os.getcwd())
dirs=next(os.walk('{}/anti_out'.format(dirpath)))[1]



for f in dirs:
  print("{di}/anti_out/{paths}/{fil}.gbk".format(paths=f,fil=f,di=dirpath))
  print( "to {}/resultgbs/".format(dirpath))
  currentpath="{dpath}/anti_out/{fil}".format(dpath=dirpath,fil=f)
  shutil.copy2("{di}/anti_out/{paths}/{fil}.gbk".format(paths=f,fil=f,di=dirpath), "{}/resultgbs/".format(dirpath))
 
  os.remove("{di}/anti_out/{paths}/{fil}.gbk".format(paths=f,fil=f,di=dirpath))
  os.remove("{di}/anti_out/{paths}/{fil}.json".format(paths=f,fil=f,di=dirpath))


for files in  os.listdir('{}/resultgbs'.format(dirpath)):
    name=os.path.splitext('{}'.format(files))[0]
    shutil.copy2("{d}/subfas/{nam}.fa".format(d=dirpath,nam=name), "{}/sortedfasta/".format(dirpath))

