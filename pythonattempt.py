# -*- coding: utf-8 -*-
"""
Created on Tue Mar  1 10:56:58 2022

@author: signe
"""

# removes files without results
import os
import shutil
dirpath= format(os.getcwd())
dirs=next(os.walk('{}/anti_out'.format(dirpath)))[1]
print(dirs)

for f in dirs:
  onlyfiles = next(os.walk("{dpath}/anti_out/{fil}".format(dpath=dirpath,fil=f)))[2] #dir is your directory path as string
  print (len(onlyfiles))
  currentpath="{dpath}/anti_out/{fil}".format(dpath=dirpath,fil=f)
  if len(onlyfiles)==5:
      shutil.rmtree(currentpath)
