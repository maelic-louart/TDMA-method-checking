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
import ais.stream
import ais
import sys
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Ellipse

from math import sqrt, exp, pi
from numpy import matrix

foldername="statistical_data/"
filename_inno_x="list_inno_x.dat"
filename_S_x="list_S_x.dat"
filename_inno_sog="list_inno_sog.dat"
filename_S_sog="list_S_sog.dat"
filename_list_toa="list_toa.dat"


with open(foldername+filename_inno_x) as f:
    line=f.readline()
    list_line=line.split(",")
    list_inno_x=[abs(float(e)) for e in list_line]


with open(foldername+filename_S_x) as f:
    line=f.readline()
    list_line=line.split(",")
    list_S_x=[3.29*float(e) for e in list_line]


with open(foldername+filename_inno_sog) as f:
    line=f.readline()
    list_line=line.split(",")
    list_inno_sog=[abs(float(e)) for e in list_line]

with open(foldername+filename_S_sog) as f:
    line=f.readline()
    list_line=line.split(",")
    list_S_sog=[2.4*float(e) for e in list_line]

with open(foldername+filename_list_toa) as f:
   line=f.readline()
   list_line=line.split(",")
   list_toa=[float(e) for e in list_line]
   list_toa_adjusted=[float(e)-list_toa[0] for e in list_toa]


my_dpi=96


# plt.figure(1,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
# plt.xlim(xmin=4600,xmax=5400)
# plt.ylim(ymin=0,ymax=450)
# plt.plot(list_toa_adjusted,list_inno_x)
# plt.plot(list_toa_adjusted,list_S_x)
# plt.yticks(fontsize=20)
# plt.xticks(fontsize=20)
# plt.grid()
# plt.xlabel("time(s)",fontsize=25)
# plt.ylabel('distance(m)',fontsize=25)
# plt.legend(['|'+chr(957)+'|','$3.29\sqrt{S}$'],fontsize=20)
# plt.savefig('lon_innovation.eps', format='eps', dpi=my_dpi)
# plt.figure(1)
# plt.show()



plt.figure(2,figsize=(1200/my_dpi, 800/my_dpi), dpi=my_dpi)
plt.xlim(xmin=4600,xmax=5400)
plt.ylim(ymin=0,ymax=6)
plt.plot(list_toa_adjusted,list_inno_sog)
plt.plot(list_toa_adjusted,list_S_sog)
plt.yticks(fontsize=20)
plt.xticks(fontsize=20)
ellipse1 = Ellipse((4858,2.8),30,1,color="k",linestyle='dashed', fill=False)
ellipse2 = Ellipse((4905,2.7),30,1, color='k', fill=False)
ellipse3 = Ellipse((5180,3.5),30,3, color='k', linestyle='dashed',fill=False)
ellipse4 = Ellipse((5240,2.5),30,1.5, color='k', fill=False)
plt.gca().add_patch(ellipse1)
plt.gca().add_patch(ellipse2)
plt.gca().add_patch(ellipse3)
plt.gca().add_patch(ellipse4)
plt.grid()
plt.xlabel("time(s)",fontsize=25)
plt.ylabel('velocity(kt)',fontsize=25)
plt.legend(['|'+chr(957)+'|','$2.4\sqrt{S}$'],fontsize=20)
plt.savefig('sog_innovation.eps', format='eps', dpi=my_dpi)
plt.figure(2)
plt.show()