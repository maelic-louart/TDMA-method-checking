function Algorithm_out=recording_new_boat(Algorithm_in,fid4)
% extraction of the data contained in the message
[toa,mmsi,id,status_nav,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,y,x,sog,cog,channel]=data_extraction(Algorithm_in);
% We extract the structure containing the list of boats
Struct_list_boat=Algorithm_in.Struct_list_boat;
TS=Algorithm_in.TS;
% We fix the moving average
nb_frame_av=Algorithm_in.nb_frame_av;
% We initialize the list_nb_r
list_nb_r=zeros(1,nb_frame_av);
list_nb_r(Struct_list_boat.idx_mov_av)=1;
%boat initialisation
Boat=struct('mmsi',mmsi,'list_nb_r1',list_nb_r,'list_nb_r21',list_nb_r,'list_nb_r22',list_nb_r,'list_nb_r3',list_nb_r,'toa_init',toa,'toa_last',toa,'TS_last',TS,'id_last',id,'nav_status_last',status_nav,'NTR',0,'ListNTS_A',[-1],'ListNTS_B',[-1],'X_y_est',[y;0],'X_y_pred',[y;0],'X_x_est',[x;0],'X_x_pred',[x;0],'P_y_pred',zeros(2,2),'P_y_est',zeros(2,2),'P_x_pred',zeros(2,2),'P_x_est',zeros(2,2),'list_toa_mes',[toa],'mano',0,'mano_channel_A',0,'mano_channel_B',0,'nb_error_1_y',0,'nb_error_1_x',0,'list_nb_err_21',zeros(1,nb_frame_av),'list_nb_err_22',zeros(1,nb_frame_av),'list_nb_err_3',zeros(1,nb_frame_av));    
Struct_list_boat.list_mmsi(Struct_list_boat.idx_new_boat)=mmsi;
Struct_list_boat.list_boat(Struct_list_boat.idx_new_boat)=Boat;
% number of boat recorded
Struct_list_boat.nb_boat=Struct_list_boat.nb_boat+1;
% indice of the next boat to record
Struct_list_boat.idx_new_boat=Struct_list_boat.idx_new_boat+1;
Algorithm_in.idx_boat=find(Struct_list_boat.list_mmsi==Algorithm_in.Data.mmsi(Algorithm_in.i));
Algorithm_out=Algorithm_in;
Algorithm_out.Struct_list_boat=Struct_list_boat;
disp(["Recording new boat, TS=",TS,"mmsi =",mmsi,"toa = ",toa]);
fprintf(fid4,"Recording new boat, TS=%d ,mmsi=%d , toa=%d \n",[TS;mmsi;toa]);
end