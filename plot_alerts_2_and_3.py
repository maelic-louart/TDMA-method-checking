import folium
import json
import numpy as np
# import datetime

class Boat(object):
    globalTOA = []
    def __init__(self, mmsi):
        self.mmsi = mmsi
        self.id = -1
        self.lat = []
        self.lon = []
        self.sog = []
        self.toa = []
        self.cog = -1
        self.nb_error = []
        self.nb_r = []
        self.perc = []
    
mmsiList = []
boatList = []

# ALERTES 21
mapObj_21 = folium.Map(location=[48.32689792878417, -4.480279922100552], zoom_start=11)
f = open("alerts_algorithm_21.json", "r")
# f = open("message_strategy_100000.json", "r")
dict = json.loads(f.read())

#populate boatlist
for i in range(len(dict)):
    if not dict[i]["mmsi"] in mmsiList:
            mmsiList.append(dict[i]["mmsi"])

for mmsi in mmsiList:
    newBoat = Boat(mmsi)
    boatList.append(newBoat)

#populate attributes of boats
for i in range(len(dict)):
    for j in range(len(boatList)):
        if(boatList[j].mmsi == dict[i]["mmsi"]):
            boatList[j].lat.append(dict[i]["lat"])
            boatList[j].lon.append(dict[i]["lon"])
            boatList[j].sog.append(dict[i]["sog"])
            boatList[j].toa.append(dict[i]["toa"])
            boatList[j].nb_error.append(dict[i]["nb_error"])
            boatList[j].nb_r.append(dict[i]["nb_r"])
            boatList[j].perc.append(dict[i]["perc"])
            boatList[j].globalTOA.append(dict[i]["toa"])

print("create_cartography")
for boat in boatList:
    color = "blue"
    tmp = []
    for i in range(len(boat.lat)):
        tmp1 = []
        tmp1.append(boat.lat[i])
        tmp1.append(boat.lon[i])
        try:
            percentage = boat.perc[i] * 100
        except ZeroDivisionError:
            percentage = 0
        if(percentage < 60 and percentage > 30):
            customIcon= folium.Icon(color='green', prefix="fa")
            colorLine = "green"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_21)
            tmp.append(tmp1)
        elif(percentage < 80 and percentage > 60):
            customIcon= folium.Icon(color='orange', prefix="fa")
            colorLine = "orange"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_21)
            tmp.append(tmp1)
        elif(percentage < 95 and percentage > 80):
            customIcon= folium.Icon(color='red',  prefix="fa")
            colorLine = "red"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_21)
            tmp.append(tmp1)
        elif(percentage > 95):
            customIcon= folium.Icon(color='black', prefix="fa")
            colorLine = "black"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_21)
            tmp.append(tmp1)
        
mapObj_21.save("alert_21.html")

# ALERTES 22
mapObj_22 = folium.Map(location=[48.32689792878417, -4.480279922100552], zoom_start=11)
f = open("alerts_algorithm_22.json", "r")
# f = open("message_strategy_100000.json", "r")
dict = json.loads(f.read())

#populate boatlist
for i in range(len(dict)):
    # if(i > 300000) and (i > 499999):
    #     break
    # cnd = -1
    if not dict[i]["mmsi"] in mmsiList:
            mmsiList.append(dict[i]["mmsi"])

for mmsi in mmsiList:
    newBoat = Boat(mmsi)
    boatList.append(newBoat)

#populate attributes of boats
for i in range(len(dict)):
    # if(i > 300000) and (i > 499999):
    #     break
    for j in range(len(boatList)):
        if(boatList[j].mmsi == dict[i]["mmsi"]):
            boatList[j].lat.append(dict[i]["lat"])
            boatList[j].lon.append(dict[i]["lon"])
            boatList[j].sog.append(dict[i]["sog"])
            boatList[j].toa.append(dict[i]["toa"])
            boatList[j].nb_error.append(dict[i]["nb_error"])
            boatList[j].nb_r.append(dict[i]["nb_r"])
            boatList[j].perc.append(dict[i]["perc"])
            boatList[j].globalTOA.append(dict[i]["toa"])

print("create_cartography")
for boat in boatList:
    color = "blue"
    tmp = []
    for i in range(len(boat.lat)):
        tmp1 = []
        tmp1.append(boat.lat[i])
        tmp1.append(boat.lon[i])
        try:
            percentage = boat.perc[i] * 100
        except ZeroDivisionError:
            percentage = 0
        if(percentage < 60 and percentage > 30):
            customIcon= folium.Icon(color='green', prefix="fa")
            colorLine = "green"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_22)
            tmp.append(tmp1)
        elif(percentage < 80 and percentage > 60):
            customIcon= folium.Icon(color='orange', prefix="fa")
            colorLine = "orange"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_22)
            tmp.append(tmp1)
        elif(percentage < 95 and percentage > 80):
            customIcon= folium.Icon(color='red',  prefix="fa")
            colorLine = "red"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_22)
            tmp.append(tmp1)
        elif(percentage > 95):
            customIcon= folium.Icon(color='black', prefix="fa")
            colorLine = "black"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_22)
            tmp.append(tmp1)
        
mapObj_22.save("alert_22.html")


# # ALERTES 3
mapObj_3 = folium.Map(location=[48.32689792878417, -4.480279922100552], zoom_start=11)
f = open("alerts_algorithm_3.json", "r")
dict = json.loads(f.read())

#populate boatlist
for i in range(len(dict)):
    if not dict[i]["mmsi"] in mmsiList:
            mmsiList.append(dict[i]["mmsi"])

for mmsi in mmsiList:
    newBoat = Boat(mmsi)
    boatList.append(newBoat)

#populate attributes of boats
for i in range(len(dict)):
    for j in range(len(boatList)):
        if(boatList[j].mmsi == dict[i]["mmsi"]):
            boatList[j].lat.append(dict[i]["lat"])
            boatList[j].lon.append(dict[i]["lon"])
            boatList[j].sog.append(dict[i]["sog"])
            boatList[j].toa.append(dict[i]["toa"])
            boatList[j].nb_error.append(dict[i]["nb_error"])
            boatList[j].nb_r.append(dict[i]["nb_r"])
            boatList[j].perc.append(dict[i]["perc"])
            boatList[j].globalTOA.append(dict[i]["toa"])

print("create_cartography")
for boat in boatList:
    color = "blue"
    tmp = []
    for i in range(len(boat.lat)):
        tmp1 = []
        tmp1.append(boat.lat[i])
        tmp1.append(boat.lon[i])
        try:
            percentage = boat.perc[i] * 100
        except ZeroDivisionError:
            percentage = 0
        if(percentage < 60 and percentage > 30):
            customIcon= folium.Icon(color='green', prefix="fa")
            colorLine = "green"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_3)
            tmp.append(tmp1)
        elif(percentage < 80 and percentage > 60):
            customIcon= folium.Icon(color='orange', prefix="fa")
            colorLine = "orange"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_3)
            tmp.append(tmp1)
        elif(percentage < 95 and percentage > 80):
            customIcon= folium.Icon(color='red',  prefix="fa")
            colorLine = "red"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_3)
            tmp.append(tmp1)
        elif(percentage > 95):
            customIcon= folium.Icon(color='black', prefix="fa")
            colorLine = "black"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_3)
            tmp.append(tmp1)
        
mapObj_3.save("alert_3.html")