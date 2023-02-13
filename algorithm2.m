function Algorithm_out=algorithm2(Algorithm_in,fid4,fid21,fid22,fid4_json,fid21_json,fid22_json,fid5_json)

[toa,mmsi,id,nav_status,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,y,x,sog,cog,channel]=data_extraction(Algorithm_in);
nb_frame_stead=Algorithm_in.nb_frame_stead;
Struct_list_boat=Algorithm_in.Struct_list_boat;
boat=Struct_list_boat.list_boat(Algorithm_in.idx_boat);
% indice of the moving average
idx_mov_av=Struct_list_boat.idx_mov_av;
NTR=boat.NTR;
mmsi=boat.mmsi;
id_last=boat.id_last;
toa_last=boat.toa_last;
nav_status_last=boat.nav_status_last;
delta_t=toa-toa_last;
% sog computed by the algorithm 1

% number of error encountred
list_nb_err_21=boat.list_nb_err_21;
list_nb_err_22=boat.list_nb_err_22;
% number of messages received
list_nb_r21=boat.list_nb_r21;
list_nb_r22=boat.list_nb_r22;

%record message with identity and dynamic data
encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa));
fprintf(fid5_json, encodedJSON);
fprintf(fid5_json,",");

% Initialisation phase finished?
% if toa-boat.toa_init>60
if NTR==1
    if(nav_status_last==nav_status)
        if ((((id_last==1 && id==1) ||(id_last==2 && id==2)) && nav_status~=5) && nav_status~=1)
            if sog<=14
                RI=10;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                % we verify that the delta_t corresponds to the RI=10s
                if RI_min<=delta_t && delta_t<=RI_max
                    % the sog measured respect the RI specified by the AIS
                    % standard
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21),"perc.=",sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_21),'nb_r',sum(list_nb_r21),'perc',sum(list_nb_err_21)/sum(list_nb_r21)));
                        fprintf(fid21_json, encodedJSON);
                        fprintf(fid21_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                    end
                else
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22),"perc.=",sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_22),'nb_r',sum(list_nb_r22),'perc',sum(list_nb_err_22)/sum(list_nb_r22)));
                        fprintf(fid22_json, encodedJSON);
                        fprintf(fid22_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                    end
                end
            elseif 14 <= sog && sog<=23
                % we verify that the delta_t corresponds to the RI=6s
                RI=6;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                if RI_min<=delta_t && delta_t<=RI_max
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21),"perc.=",sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_21),'nb_r',sum(list_nb_r21),'perc',sum(list_nb_err_21)/sum(list_nb_r21)));
                        fprintf(fid21_json, encodedJSON);
                        fprintf(fid21_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                    end
                else
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22),"perc.=",sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_22),'nb_r',sum(list_nb_r22),'perc',sum(list_nb_err_22)/sum(list_nb_r22)));
                        fprintf(fid22_json, encodedJSON);
                        fprintf(fid22_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                    end
                end
            else
                % we verify that the delta_t corresponds to the RI=2s
                RI=2;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                if RI_min<=delta_t && delta_t<=RI_max
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21),"perc.=",sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_21),'nb_r',sum(list_nb_r21),'perc',sum(list_nb_err_21)/sum(list_nb_r21)));
                        fprintf(fid21_json, encodedJSON);
                        fprintf(fid21_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                    end
                else
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22),"perc.=",sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',1,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_22),'nb_r',sum(list_nb_r22),'perc',sum(list_nb_err_22)/sum(list_nb_r22)));
                        fprintf(fid22_json, encodedJSON);
                        fprintf(fid22_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                    end
                end
            end
        elseif (nav_status==1) || (nav_status==5)
            % we verify that the delta_t corresponds to the RI=3minutes
            % (vessel at anchor and moored)
            if sog<=3
                RI=180;
                RI_min=RI-5;% message identity is 3, so it is not limited to +-20%
                RI_max=RI+5;
                if RI_min<delta_t && delta_t<RI_max
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                elseif rem(delta_t,RI)/RI<=0.027 || rem(delta_t,RI)/RI>=0.972
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    disp(["Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21)]);
                    fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                    fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                else
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22)]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor),channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor),channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                end
            else
                RI=10;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                % we verify that the delta_t corresponds to the RI=10s
                if RI_min<delta_t && delta_t<RI_max
                    % the sog measured respect the RI specified by the AIS
                    % standard
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21),"perc.=",sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_21),'nb_r',sum(list_nb_r21),'perc',sum(list_nb_err_21)/sum(list_nb_r21)));
                        fprintf(fid21_json, encodedJSON);
                        fprintf(fid21_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                    end
                else
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22),"perc.=",sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_22),'nb_r',sum(list_nb_r22),'perc',sum(list_nb_err_22)/sum(list_nb_r22)));
                        fprintf(fid22_json, encodedJSON);
                        fprintf(fid22_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                    end
                end
            end
            
        else
            if sog<=14
                RI=3.333;
                RI_min=RI-0.5*RI;
                RI_max=RI+0.5*RI;
                % we verify that the delta_t corresponds to the RI=10s
                if RI_min<=delta_t && delta_t<=RI_max
                    % the sog measured respect the RI specified by the AIS
                    % standard
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21),"perc.=",sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_21),'nb_r',sum(list_nb_r21),'perc',sum(list_nb_err_21)/sum(list_nb_r21)));
                        fprintf(fid21_json, encodedJSON);
                        fprintf(fid21_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                    end
                else
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22),"perc.=",sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_22),'nb_r',sum(list_nb_r22),'perc',sum(list_nb_err_22)/sum(list_nb_r22)));
                        fprintf(fid22_json, encodedJSON);
                        fprintf(fid22_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                    end
                end
            else
                % we verify that the delta_t corresponds to the RI=6s
                RI=2;
                RI_min=RI-0.5*RI;
                RI_max=RI+0.5*RI;
                if RI_min<=delta_t && delta_t<=RI_max
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_r21(idx_mov_av)=list_nb_r21(idx_mov_av)+1;
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21),"perc.=",sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21);sum(list_nb_err_21)/sum(list_nb_r21)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_21),'nb_r',sum(list_nb_r21),'perc',sum(list_nb_err_21)/sum(list_nb_r21)));
                        fprintf(fid21_json, encodedJSON);
                        fprintf(fid21_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r21)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r21)]);
                    end
                else
                    list_nb_r22(idx_mov_av)=list_nb_r22(idx_mov_av)+1;
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if((sum(list_nb_r21)+sum(list_nb_r22))>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22),"perc.=",sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22);sum(list_nb_err_22)/sum(list_nb_r22)]);
                        encodedJSON=jsonencode(struct('mmsi',mmsi,'id',3,'lat',y,'lon',x,'sog',sog,'cog',cog,'toa',toa,'nb_error',sum(list_nb_err_22),'nb_r',sum(list_nb_r22),'perc',sum(list_nb_err_22)/sum(list_nb_r22)));
                        fprintf(fid22_json, encodedJSON);
                        fprintf(fid22_json,",");
                        fprintf(fid4_json,encodedJSON);
                        fprintf(fid4_json,",");
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r22)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r22)]);
                    end
                end
            end
        end
    end
end
if id_last==1 && id==1
    % non-maneuvering action
    mano=0;
else
    mano=1;
end

% end

boat.mano=mano;
if channel==1
    %     if the message has a repeat indicator equal to 1 the data are not
    %     considered
    if repeat_indicator~=1
        boat.id_last=id;
        boat.nav_status_last=nav_status;
        boat.toa_last=toa;
    end
else
    if repeat_indicator~=1
        boat.id_last=id;
        boat.nav_status_last=nav_status;
        boat.toa_last=toa;
    end
end
% we increment the number of message received by the boat
boat.list_nb_r21=list_nb_r21;
boat.list_nb_r22=list_nb_r22;
boat.list_nb_err_21=list_nb_err_21;
boat.list_nb_err_22=list_nb_err_22;
Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=boat;
Algorithm_out=Algorithm_in;
end
