# -*- coding: utf-8 -*-
"""
Created on Tue Apr 12 12:41:45 2022

@author: signe
"""
import os
import shutil

dirpath= format(os.getcwd())
dirs=next(os.walk('{}/anti_out'.format(dirpath)))[1]

for files in  os.listdir('{}/resultgbs'.format(dirpath)):
    name=os.path.splitext('{}'.format(files))[0]
    shutil.copy2("{d}/subfas/{nam}.fa".format(d=dirpath,nam=name), "{}/sortedfasta/".format(dirpath))