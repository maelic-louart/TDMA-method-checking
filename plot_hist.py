#
#       Programme utilisé pour tracer une trame et extraire des informations du fichier log
#
#       Les fichiers d'entrée sont les fichiers réels
#
#       JJ SZKOLNIK (15/04/2019)
#       Version 1
#


# librairie libais https://github.com/schwehr/libais
import csv
from fileinput import filename
import ais.stream
import ais
import sys
import matplotlib.pyplot as plt
import numpy as np

from math import sqrt, exp, pi
from numpy import matrix

filenames_list_inno_x="list_inno_x.dat"
filenames_list_S_x="list_S_x.dat"
filenames_list_inno_y="list_inno_y.dat"
filenames_list_S_y="list_S_y.dat"
filenames_list_inno_sog="list_inno_sog.dat"
filenames_list_S_sog="list_S_sog.dat"


list_inno_x=[]
with open("statistical_data/"+filenames_list_inno_x) as f:
    # with open('statistical_data/'+filename) as f:
    for line in f.readlines():
        if line !='\n':
            list_line =line.split(",")
            list=[float(e) for e in list_line]
            list_inno_x.extend(list)

list_S_x=[]
with open("statistical_data/"+filenames_list_S_x) as f:
    # with open('statistical_data/'+filename) as f:
    for line in f.readlines():
        if line !='\n':
            list_line =line.split(",")
            list=[3.29*float(e) for e in list_line]
            list_S_x.extend(list)      

list_inno_y=[]
with open("statistical_data/"+filenames_list_inno_y) as f:
    # with open('statistical_data/'+filename) as f:
    for line in f.readlines():
        if line !='\n':
            list_line =line.split(",")
            list=[float(e) for e in list_line]
            list_inno_y.extend(list)

list_S_y=[]
with open("statistical_data/"+filenames_list_S_y) as f:
    # with open('statistical_data/'+filename) as f:
    for line in f.readlines():
        if line !='\n':
            list_line =line.split(",")
            list=[3.29*float(e) for e in list_line]
            list_S_y.extend(list)  

list_inno_sog=[]
with open("statistical_data/"+filenames_list_inno_sog) as f:
    # with open('statistical_data/'+filename) as f:
    for line in f.readlines():
        if line !='\n':
            list_line =line.split(",")
            list=[float(e) for e in list_line]
            list_inno_sog.extend(list)

list_S_sog=[]
with open("statistical_data/"+filenames_list_S_sog) as f:
    # with open('statistical_data/'+filename) as f:
    for line in f.readlines():
        if line !='\n':
            list_line =line.split(",")
            list=[2.4*float(e) for e in list_line]
            list_S_sog.extend(list)            


# # bins=np.arange(0,2251,10)
my_dpi=96
bin_sog_inno=np.arange(-4,4,0.1)
plt.figure(1,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
plt.hist(list_inno_sog,bins = bin_sog_inno,color='k')
plt.xlim(xmin=-4,xmax=4)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel(chr(957)+'$_{sog}$',fontsize=25)
plt.ylabel('Number of measurements',fontsize=25)
plt.savefig('histogram_sog_inno.eps', format='eps', dpi=my_dpi)

my_dpi=96
bin_sog_S=np.arange(0,15,0.033)
plt.figure(2,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
plt.hist(list_S_sog,bins = bin_sog_S,color='k')
plt.xlim(xmin=1.25,xmax=3.6)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel('$2.4\sqrt{S_{sog}}$',fontsize=25)
plt.ylabel('Number of measurements',fontsize=25)
plt.axvline(2.07,linewidth=2,color='k',linestyle='--')
plt.axvline(2.6,linewidth=2,color='k',linestyle='--')
plt.axvline(2.92,linewidth=2,color='k',linestyle='--')
plt.axvline(3.28,linewidth=2,color='k',linestyle='--')
plt.savefig('histogram_S_sog.eps', format='eps', dpi=my_dpi)

bin_x_inno=np.arange(-30,30,1)
plt.figure(3,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
plt.hist(list_inno_x,bins = bin_x_inno,color='k')
plt.xlim(xmin=-30,xmax=30)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel(chr(957)+'$_{L}$',fontsize=25)
plt.ylabel('Number of measurements',fontsize=25)
plt.savefig('histogram_x_inno.eps', format='eps', dpi=my_dpi)

my_dpi=96
bin_x_S=np.arange(0,155,2)
plt.figure(4,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
plt.hist(list_S_x,bins = bin_x_S,color='k')
plt.xlim(xmin=20,xmax=90)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel('$3.29\sqrt{S_{\phi}}$',fontsize=25)
plt.ylabel('Number of measurements',fontsize=25)
plt.axvline(33.51,linewidth=2,color='k',linestyle='--')
plt.axvline(47.5,linewidth=2,color='k',linestyle='--')
# plt.axvline(74.2,linewidth=2,color='k',linestyle='--')
plt.savefig('histogram_S_x.eps', format='eps', dpi=my_dpi)

bin_y_inno=np.arange(-30,30,1)
plt.figure(5,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
plt.hist(list_inno_y,bins=bin_y_inno,color='k')
plt.xlim(xmin=-30,xmax=30)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel(chr(957)+'$_{l}$',fontsize=25)
plt.ylabel('Number of measurements',fontsize=25)
plt.savefig('histogram_y_inno.eps', format='eps', dpi=my_dpi)

my_dpi=96
bin_y_S=np.arange(0,155,2)
plt.figure(6,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
plt.hist(list_S_y,bins = bin_y_S,color='k')
plt.xlim(xmin=20,xmax=90)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.grid()
plt.xlabel('$3.29\sqrt{S_{\lambda}}$',fontsize=25)
plt.ylabel('Number of measurements',fontsize=25)
plt.axvline(33.51,linewidth=2,color='k',linestyle='--')
plt.axvline(47.5,linewidth=2,color='k',linestyle='--')
# plt.axvline(74.2,linewidth=2,color='k',linestyle='--')
plt.savefig('histogram_S_y.eps', format='eps', dpi=my_dpi)


