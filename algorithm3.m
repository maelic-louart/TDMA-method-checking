function Algorithm_out=algorithm3(Algorithm_in,fid4,fid3,fid4_json,fid3_json)
[toa,mmsi,id,nav_status,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,y,x,sog,cog,channel]=data_extraction(Algorithm_in);

TS=Algorithm_in.TS;
nb_frame_stead=Algorithm_in.nb_frame_stead;
Struct_list_boat=Algorithm_in.Struct_list_boat;
boat=Struct_list_boat.list_boat(Algorithm_in.idx_boat);
% indice of the moving average
idx_mov_av=Struct_list_boat.idx_mov_av;
threshold_sog=1;

if channel==1
    ListNTS=boat.ListNTS_A;
    mano=boat.mano_channel_A;
else
    ListNTS=boat.ListNTS_B;
    mano=boat.mano_channel_B;
end

% number of error encountred
list_nb_err_3=boat.list_nb_err_3;
% number of messages received
list_nb_r3=boat.list_nb_r3;

% We verify that one frame was lasted since the first message received by the
% same ship
if toa-boat.toa_init>60
    % the accuracy of the prediction is one TS
    accuracy=1;
    list=[rem(TS+2250-accuracy,2250);TS;rem(TS+2250+accuracy,2250)];
    % Checking that the TS was booked
    if sum(any(ListNTS==list))>=1
        % The TS was booked
    else
        % The TS was not booked
        if id==1 || id==2
            list_nb_err_3(idx_mov_av)=list_nb_err_3(idx_mov_av)+1;
            if sog<=14-threshold_sog
                RI=10;
                if(sum(list_nb_r3)>(60*nb_frame_stead/RI))
                    fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                    fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                    disp(["Alert3 : TS was not reserved by the ship mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3),"perc.=",sum(list_nb_err_3)/sum(list_nb_r3)]);
                    encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_3),'nb_r',sum(list_nb_r3),'perc',sum(list_nb_err_3)/sum(list_nb_r3)));
                    fprintf(fid3_json, encodedJSON);
                    fprintf(fid3_json,",");
                    fprintf(fid4_json,encodedJSON);
                    fprintf(fid4_json,",");
                else
                    fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d,mes id = 1, TS==%d , toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                    fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 1, TS==%d, toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                    disp(["Alert3 : TS was not reserved by the ship mmsi =",mmsi," mes id = 1, TS=",TS," toa = ",toa," slot_timeout ",slot_timeout,"slot_offset = ",slot_offset,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3)]);
                end
            elseif 14-threshold_sog<=sog && sog<=23-threshold_sog
                RI=6;
                if(sum(list_nb_r3)>(60*nb_frame_stead/RI))
                    fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                    fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                    disp(["Alert3 : TS was not reserved by the ship mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3),"perc.=",sum(list_nb_err_3)/sum(list_nb_r3)]);
                    encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_3),'nb_r',sum(list_nb_r3),'perc',sum(list_nb_err_3)/sum(list_nb_r3)));
                    fprintf(fid3_json, encodedJSON);
                    fprintf(fid3_json,",");
                    fprintf(fid4_json,encodedJSON);
                    fprintf(fid4_json,",");
                else
                    fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d,mes id = 1, TS==%d , toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                    fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 1, TS==%d, toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                    disp(["Alert3 : TS was not reserved by the ship mmsi =",mmsi," mes id = 1, TS=",TS," toa = ",toa," slot_timeout ",slot_timeout,"slot_offset = ",slot_offset,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3)]);
                end
            else
                RI=2;
                if(sum(list_nb_r3)>(60*nb_frame_stead/RI))
                    fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                    fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                    disp(["Alert3 : TS was not reserved by the ship mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3),"perc.=",sum(list_nb_err_3)/sum(list_nb_r3)]);
                    encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_3),'nb_r',sum(list_nb_r3),'perc',sum(list_nb_err_3)/sum(list_nb_r3)));
                    fprintf(fid3_json, encodedJSON);
                    fprintf(fid3_json,",");
                    fprintf(fid4_json,encodedJSON);
                    fprintf(fid4_json,",");
                else
                    fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d,mes id = 1, TS==%d , toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                    fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 1, TS==%d, toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                    disp(["Alert3 : TS was not reserved by the ship mmsi =",mmsi," mes id = 1, TS=",TS," toa = ",toa," slot_timeout ",slot_timeout,"slot_offset = ",slot_offset,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3)]);
                end
            end
        elseif id==3
            if repeat_indicator==1
%                 %                 RATDMA access scheme was applied
            elseif mano==0
                %                 Ship starts just to maneuvring
            else
                if (nav_status==1||nav_status==5)
                    %ship in moored or at anchor
                    %The TS was not booked
                    list_nb_err_3(idx_mov_av)=list_nb_err_3(idx_mov_av)+1;
                    fprintf(fid4,"Alert3 : TS was not reserved by the ship (in moored or at anchor) mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, \n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3)]);
                    fprintf(fid3,"Alert3 : TS was not reserved by the ship (in moored or at anchor) mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, \n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3)]);
                    disp(["Alert3 : TS was not reserved by the ship (in moored or at anchor) mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3)]);
                else
                    %ship in mooving
                    %The TS was not booked
                    list_nb_err_3(idx_mov_av)=list_nb_err_3(idx_mov_av)+1;
                    if sog<=14-threshold_sog
                        RI=10;
                        if(sum(list_nb_r3)>(60*nb_frame_stead/RI))
                            fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                            fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                            disp(["Alert3 : TS was not reserved by the ship mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3),"perc.=",sum(list_nb_err_3)/sum(list_nb_r3)]);
                            encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_3),'nb_r',sum(list_nb_r3),'perc',sum(list_nb_err_3)/sum(list_nb_r3)));
                            fprintf(fid3_json, encodedJSON);
                            fprintf(fid3_json,",");
                            fprintf(fid4_json,encodedJSON);
                            fprintf(fid4_json,",");
                        else
                            fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d,mes id = 1, TS==%d , toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                            fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 1, TS==%d, toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                            disp(["Alert3 : TS was not reserved by the ship mmsi =",mmsi," mes id = 1, TS=",TS," toa = ",toa," slot_timeout ",slot_timeout,"slot_offset = ",slot_offset,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3)]);
                        end
                    elseif 14-threshold_sog<=sog && sog<=23-threshold_sog
                        RI=6;
                        if(sum(list_nb_r3)>(60*nb_frame_stead/RI))
                            fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                            fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                            disp(["Alert3 : TS was not reserved by the ship mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3),"perc.=",sum(list_nb_err_3)/sum(list_nb_r3)]);
                            encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_3),'nb_r',sum(list_nb_r3),'perc',sum(list_nb_err_3)/sum(list_nb_r3)));
                            fprintf(fid3_json, encodedJSON);
                            fprintf(fid3_json,",");
                            fprintf(fid4_json,encodedJSON);
                            fprintf(fid4_json,",");
                        else
                            fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d,mes id = 1, TS==%d , toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                            fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 1, TS==%d, toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                            disp(["Alert3 : TS was not reserved by the ship mmsi =",mmsi," mes id = 1, TS=",TS," toa = ",toa," slot_timeout ",slot_timeout,"slot_offset = ",slot_offset,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3)]);
                        end
                    else
                        RI=2;
                        if(sum(list_nb_r3)>(60*nb_frame_stead/RI))
                            fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                            fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 3, TS=%d , toa=%f, slot_increment = %d, keep_flag = %d, nb_error= %d, nb_r=%d, perc.=%f\n",[mmsi;TS;toa;slot_increment;keep_flag;sum(list_nb_err_3);sum(list_nb_r3);sum(list_nb_err_3)/sum(list_nb_r3)]);
                            disp(["Alert3 : TS was not reserved by the ship mmsi=",mmsi," mes id = 3, TS=",TS," toa = ",toa,"slot_increment =",slot_increment,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3),"perc.=",sum(list_nb_err_3)/sum(list_nb_r3)]);
                            encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_3),'nb_r',sum(list_nb_r3),'perc',sum(list_nb_err_3)/sum(list_nb_r3)));
                            fprintf(fid3_json, encodedJSON);
                            fprintf(fid3_json,",");
                            fprintf(fid4_json,encodedJSON);
                            fprintf(fid4_json,",");
                        else
                            fprintf(fid4,"Alert3 : TS was not reserved by the ship mmsi=%d,mes id = 1, TS==%d , toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                            fprintf(fid3,"Alert3 : TS was not reserved by the ship mmsi=%d, mes id = 1, TS==%d, toa=%f, slot_timeout =%d , slot_offset = %d, nb_error= %d, nb_r=%d \n",[mmsi;TS;toa;slot_timeout;slot_offset;sum(list_nb_err_3);sum(list_nb_r3)]);
                            disp(["Alert3 : TS was not reserved by the ship mmsi =",mmsi," mes id = 1, TS=",TS," toa = ",toa," slot_timeout ",slot_timeout,"slot_offset = ",slot_offset,"nb_error=",sum(list_nb_err_3),"nb_r =",sum(list_nb_r3)]);
                        end
                    end
                end
            end
        end
    end
end
mano_algo=boat.mano;

% The TS booked is put non_booked
if channel==1
    boat.mano_channel_A=mano_algo;
else
    boat.mano_channel_B=mano_algo;
end
% we increment the number of message received by the boat
boat.list_nb_r3(idx_mov_av)=list_nb_r3(idx_mov_av)+1;

boat.list_nb_err_3=list_nb_err_3;
Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=boat;
Algorithm_out=Algorithm_in;

end
