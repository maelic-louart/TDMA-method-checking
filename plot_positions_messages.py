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



# POSITION
mapObj_pos = folium.Map(location=[48.32689792878417, -4.480279922100552], zoom_start=11)
f = open("message_strategy.json", "r")
dict = json.loads(f.read())

# populate boatlist
for i in range(len(dict)):
    if not dict[i]["mmsi"] in mmsiList:
            mmsiList.append(dict[i]["mmsi"])

for mmsi in mmsiList:
    newBoat = Boat(mmsi)
    boatList.append(newBoat)

# populate attributes of boats
for i in range(len(dict)):
    for j in range(len(boatList)):
        if(boatList[j].mmsi == dict[i]["mmsi"]):
            boatList[j].lat.append(dict[i]["lat"])
            boatList[j].lon.append(dict[i]["lon"])
            boatList[j].sog.append(dict[i]["sog"])
            boatList[j].toa.append(dict[i]["toa"])
            boatList[j].globalTOA.append(dict[i]["toa"])

print("create_cartography")
for boat in boatList:
    color = "blue"
    tmp = []
    for i in range(len(boat.lat)):
        tmp1 = []
        tmp1.append(boat.lat[i])
        tmp1.append(boat.lon[i])
        customIcon= folium.Icon(color='blue', prefix="fa")
        colorLine = "blue"
        folium.Circle(tmp1, radius=500,fill_color=colorLine, fill_opacity=1, color=colorLine, popup="MMSI:" + str(boat.mmsi), ).add_to(mapObj_pos)
        tmp.append(tmp1)
mapObj_pos.save("alert_position.html")

