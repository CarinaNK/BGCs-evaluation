# -*- coding: utf-8 -*-
"""
Created on Mon Mar  7 09:09:03 2022

@author: signe
"""

import os
import shutil

dirpath= format(os.getcwd())
dirs=next(os.walk('{}/anti_out'.format(dirpath)))[1]



for f in dirs:
  currentpath="{di}/anti_out/{paths}/{fil}.gbk".format(paths=f,fil=f,di=dirpath)
  print(currentpath)
  outputpath="to {}/resultgbs/".format(dirpath)
  print( outputpath)
  
  shutil.copy2("{di}/anti_out/{paths}/{fil}.gbk".format(paths=f,fil=f,di=dirpath), "{}/resultgbs/".format(dirpath))
 
  os.remove("{di}/anti_out/{paths}/{fil}.gbk".format(paths=f,fil=f,di=dirpath))
  os.remove("{di}/anti_out/{paths}/{fil}.json".format(paths=f,fil=f,di=dirpath))
