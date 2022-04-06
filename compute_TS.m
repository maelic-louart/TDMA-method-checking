function res=compute_TS(AIS_Algorithm,mmsi)
channel=AIS_Algorithm.Data.channel(AIS_Algorithm.i);
if channel==1
    frame_pres=AIS_Algorithm.Frame_pres_A;
else
    frame_pres=AIS_Algorithm.Frame_pres_B;
end
toa_recal_pres=AIS_Algorithm.toa_recal_pres;
TS=mod(fix(toa_recal_pres/0.0266667),2250);

% The computation of the TS can have an error of one TS this is why we add
% the following condition to find the true TS
if frame_pres.mmsi(TS-1)==mmsi
    TS=TS-1;
end
if frame_pres.mmsi(TS+1)==mmsi
    TS=TS+1;
end
res=TS;
end
