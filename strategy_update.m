function Algorithm_out=strategy_update(Algorithm_in,i,fid4)

Algorithm_in.i=i;
indice=i;
if indice==1
    indice_pres=1;
    indice_last=1;
else
    indice_pres=i;
    indice_last=i-1;
end
toa=Algorithm_in.Data.toa(indice_pres);
toa_last=Algorithm_in.Data.toa(indice_last);
% Synchronisation of the toa to the minute UTC
Algorithm_in.toa_recal_pres=synch_tps_frame(toa,Algorithm_in.dec);

% Update ship list. We remove ship if they do not send messages from more
% than six minutes. 
Struct_list_boat=Algorithm_in.Struct_list_boat;
nb_boat=Struct_list_boat.nb_boat;
new_idx_new_boat=1;
new_nb_boat=nb_boat;
list_mmsi=[];
list_boat=Struct_list_boat.list_boat;
for i=1:nb_boat
    boat=Struct_list_boat.list_boat(i);
    toa_last_boat=boat.toa_last;
    delta_t=toa-toa_last_boat;
    if(delta_t<370)
        list_boat(new_idx_new_boat)=boat;
        list_mmsi(new_idx_new_boat)=boat.mmsi;
        new_idx_new_boat=new_idx_new_boat+1;
    else
        new_nb_boat=new_nb_boat-1;
    end
end
Struct_list_boat.nb_boat=new_nb_boat;
Struct_list_boat.idx_new_boat=new_idx_new_boat;
Struct_list_boat.list_mmsi=list_mmsi;
Struct_list_boat.list_boat=list_boat;
Algorithm_in.Struct_list_boat=Struct_list_boat;

% Test to know if we do not received messages during several frames
if (abs(toa_last-toa)>60)
    nb_frame=fix(abs(toa_last-toa)/60);
    if (Algorithm_in.toa_recal_pres-Algorithm_in.toa_recal_past<0)
        nb_frame=nb_frame+1;
    end
    % boats update
    Algorithm_in=data_update(Algorithm_in,fid4,nb_frame);
% Test to know if we start a new frame
elseif (Algorithm_in.toa_recal_pres-Algorithm_in.toa_recal_past<0) && (toa_last-toa<0)
    % boats update
    nb_frame=1;
    Algorithm_in=data_update(Algorithm_in,fid4,nb_frame);
end
Algorithm_in.toa_recal_past=Algorithm_in.toa_recal_pres;

% TS computation
Algorithm_in.TS=compute_TS(Algorithm_in);

Algorithm_out=Algorithm_in;
end