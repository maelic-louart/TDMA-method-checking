function Struct_list_boat=recording_new_boat(Algorithm,mmsi,lat,lon,sog,toa,id,fid4)
Struct_list_boat=Algorithm.Struct_list_boat;
TS=Algorithm.TS;
Boat=struct('mmsi',mmsi,'num_mes',1,'toa_init',toa,'toa_last',toa,'TS_last',TS,'id_last',id,'NTR',0,'X_lat_est',[lat;0],'X_lat_pred',[lat;0],'X_lon_est',[lon;0],'X_lon_pred',[lon;0],'P_lat_pred',zeros(2,2),'P_lat_est',zeros(2,2),'P_lon_pred',zeros(2,2),'P_lon_est',zeros(2,2),'list_toa_mes',[toa],'mano',0,'mano_channel_A',0,'mano_channel_B',0,'nb_error_lat',0,'nb_error_lon',0);    
Struct_list_boat.list_mmsi(Struct_list_boat.idx_new_boat)=mmsi;
Struct_list_boat.list_boat(Struct_list_boat.idx_new_boat)=Boat;
Struct_list_boat.nb_boat=Struct_list_boat.nb_boat+1;
Struct_list_boat.idx_new_boat=Struct_list_boat.idx_new_boat+1;
disp(["Recording new boat, TS=",TS,"mmsi =",mmsi,"toa = ",toa]);
fprintf(fid4,"Recording new boat, TS=%d ,mmsi=%d , toa=%d \n",[TS;mmsi;toa]);
end