function [toa,mmsi,id,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,lat,lon,sog,cog,channel]=data_extraction(Algorithme_AIS)
j=Algorithme_AIS.i;
toa=Algorithme_AIS.Data.toa(j);
id=Algorithme_AIS.Data.id(j);
repeat_indicator=Algorithme_AIS.Data.repeat_indicator(j);
keep_flag=Algorithme_AIS.Data.keep_flag(j);
slot_timeout=Algorithme_AIS.Data.slot_timeout(j);
slot_increment=Algorithme_AIS.Data.slot_increment(j);
slot_offset=Algorithme_AIS.Data.slot_offset(j);
mmsi=Algorithme_AIS.Data.mmsi(j);
lat=Algorithme_AIS.Data.x(j);
lon=Algorithme_AIS.Data.y(j);
sog=Algorithme_AIS.Data.sog(j);
cog=Algorithme_AIS.Data.cog(j);
channel=Algorithme_AIS.Data.channel(j);
end