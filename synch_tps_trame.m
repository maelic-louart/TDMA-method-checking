function res=synch_tps_trame(toa,dec)
temps=rem(toa+dec*0.0266667,60);
res=temps;
end
       