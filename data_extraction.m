function [toa,mmsi,id,nav_status,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,y,x,sog,cog,channel]=data_extraction(Algorithm_in)
j=Algorithm_in.i;
toa=Algorithm_in.Data.toa(j);
nav_status=Algorithm_in.Data.nav_status(j);
id=Algorithm_in.Data.id(j);
repeat_indicator=Algorithm_in.Data.repeat_indicator(j);
keep_flag=Algorithm_in.Data.keep_flag(j);
slot_timeout=Algorithm_in.Data.slot_timeout(j);
slot_increment=Algorithm_in.Data.slot_increment(j);
slot_offset=Algorithm_in.Data.slot_offset(j);
mmsi=Algorithm_in.Data.mmsi(j);
x=Algorithm_in.Data.x(j);
y=Algorithm_in.Data.y(j);
sog=Algorithm_in.Data.sog(j);
cog=Algorithm_in.Data.cog(j);
channel=Algorithm_in.Data.channel(j);
end