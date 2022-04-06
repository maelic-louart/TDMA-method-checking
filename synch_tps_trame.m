function res=synch_tps_trame(toa,dec)
temps=toa+dec*0.02667;
while (temps>60)
    temps=temps-60;            
end
res=temps;
end
       