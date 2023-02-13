import folium
import json
import numpy as np
import datetime

mapObj = folium.Map(location=[48.32689792878417, -4.480279922100552], zoom_start=11)

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
        self.kind = []
        self.value = []
    
mmsiList = []
boatList = []
f = open("alerts_algorithm_1.json", "r")
dict = json.loads(f.read())

#populate boatlist
for i in range(len(dict)):
    if not dict[i]["mmsi"] in mmsiList:
            mmsiList.append(dict[i]["mmsi"])

for mmsi in mmsiList:
    newBoat = Boat(mmsi)
    boatList.append(newBoat)

#populate attributes of boats
for i in range(len(dict)-1):
    #     break
    for j in range(len(boatList)):
        if(boatList[j].mmsi == dict[i]["mmsi"]):
            boatList[j].lat.append(dict[i]["lat"])
            boatList[j].lon.append(dict[i]["lon"])
            boatList[j].sog.append(dict[i]["sog"])
            boatList[j].toa.append(dict[i]["toa"])
            boatList[j].kind.append(dict[i]["kind"])
            boatList[j].value.append(dict[i]["value"])
            boatList[j].globalTOA.append(dict[i]["toa"])

print("create_cartography_longitude")
for boat in boatList:
    tmp = []
    for i in range(len(boat.lat)):
        tmp1 = []
        tmp1.append(boat.lat[i])
        tmp1.append(boat.lon[i])
        kind = boat.kind[i]
        if kind==1:
            value=boat.value[i]
            customIcon= folium.Icon(color='green', prefix="fa")
            colorLine = "green"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj)
            tmp.append(tmp1)
mapObj.save("output_longitude.html")

print("create_cartography_latitude")
for boat in boatList:
    color = "blue"
    tmp = []
    for i in range(len(boat.lat)):
        tmp1 = []
        tmp1.append(boat.lat[i])
        tmp1.append(boat.lon[i])
        kind = boat.kind[i]
        if kind==2:
            value=boat.value[i]
            customIcon= folium.Icon(color='green', prefix="fa")
            colorLine = "green"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj)
            tmp.append(tmp1)
mapObj.save("output_latitude.html")

print("create_cartography_sog")
for boat in boatList:
    color = "blue"
    tmp = []
    for i in range(len(boat.lat)):
        tmp1 = []
        tmp1.append(boat.lat[i])
        tmp1.append(boat.lon[i])
        kind = boat.kind[i]
        if kind==3:
            value=boat.value[i]
            customIcon= folium.Icon(color='green', prefix="fa")
            colorLine = "green"
            folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj)
            tmp.append(tmp1)
mapObj.save("output_sog.html")