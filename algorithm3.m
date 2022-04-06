function Algorithm_out=algorithm3(Algorithm_in,fid4,fid3)

[toa,mmsi,id,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,lat,lon,sog,cog,channel]=data_extraction(Algorithm_in);

TS=Algorithm_in.TS;
boat=Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat);

if channel==1
    frame_pres=Algorithm_in.Frame_pres_A;
    mano=boat.mano_channel_A;
else
    frame_pres=Algorithm_in.Frame_pres_B;
    mano=boat.mano_channel_B;
end

% We verify that one frame was lasted since the first message received by the
% same ship
if toa-boat.toa_init>60
%     Checking that the TS was booked
    if frame_pres.TS(TS)==1
        % The TS was booked
        if frame_pres.mmsi(TS)==mmsi
            %The TS was booked by the good ship
        else
            %The TS was not booked by the good ship
            if id==3 || id==1
                fprintf(fid4,"Alert3 : le TS was booked by the mmsi=%d but the mmsi = %d was received, TS=%d, toa=%d \n",[frame_pres.mmsi(TS);mmsi;TS;toa]);
                fprintf(fid3,"Alert3 : le TS was booked by the mmsi=%d but the mmsi = %d was received, TS=%d, toa=%d \n",[frame_pres.mmsi(TS);mmsi;TS;toa]);
                disp(["Alert3 : le TS was booked by the mmsi",frame_pres.mmsi(TS),"but the mmsi =",mmsi," was received, TS=",TS,"toa =",toa]);
            end
        end
    else
        %The TS was not booked
        if id==1
            disp(["Alert3 : TS was not reserved by the ship mmsi =",mmsi," mes id = 1, TS=",TS," toa = ",toa," slot_timeout ",slot_timeout,"slot_offset = ",slot_offset]);
            fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d,mes id = 1, TS==%d , toa=%f, slot_timeout =%d , slot_offset = %d \n",[mmsi;TS;toa;slot_timeout;slot_offset]);
            fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 1, TS==%d, toa=%f, slot_timeout =%d , slot_offset = %d \n",[mmsi;TS;toa;slot_timeout;slot_offset]);
        elseif id==3
            if repeat_indicator==1
%                 RATDMA access scheme was applied
            elseif mano==0
%                 Ship starts just to maneuvring
            else
                 %The TS was not booked
                fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d \n",[mmsi;TS;toa;slot_increment;keep_flag]);
                fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d \n",[mmsi;TS;toa;slot_increment;keep_flag]);
                disp(["Alert3 : TS was not reserved by the ship mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment]);
            end
        end
    end
end
mano_algo=boat.mano;
Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=boat;

% The TS booked is put non_booked
if channel==1
    boat.mano_channel_A=mano_algo;
    Algorithm_in.Frame_pres_A.TS(TS)=-2;
else
    boat.mano_channel_B=mano_algo;
    Algorithm_in.Frame_pres_B.TS(TS)=-2;
end
Algorithm_out=Algorithm_in;

end
