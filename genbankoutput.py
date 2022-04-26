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

   
    currentpath="{dpath}/anti_out/{fil}".format(dpath=dirpath,fil=f)

    currentfile=currentpath+'/'+f+'.gbk'

    print (currentpath)

    print (currentfile)

    targetpath=dirpath+'/resultgbs/'

    print (targetpath)

    if os.path.isdir(targetpath):

        shutil.copy2(currentfile, targetpath)

    else:

        print ('Target path doesnt exist!')
        



