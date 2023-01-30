function Algorithm_out=algorithm2(Algorithm_in,fid4,fid21,fid22)

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
delta_t=toa-toa_last;
% sog computed by the algorithm 1
% sog threshold fixes to 1nd
threshold_sog=1;
mano=1;

% number of error encountred
list_nb_err_21=boat.list_nb_err_21;
list_nb_err_22=boat.list_nb_err_22;
% number of messages received
list_nb_r=boat.list_nb_r;


% Initialisation phase finished?
% if toa-boat.toa_init>60
if NTR==1
    if id_last==1 && id==1
        %  non-maneuvering action
        mano=0;
        if ((nav_status==0))
            if sog<=14
                RI=10;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                % we verify that the delta_t corresponds to the RI=10s
                if RI_min<=delta_t && delta_t<=RI_max
                    % the sog measured respect the RI specified by the AIS
                    % standard
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                    end
                else
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                    end
                end
                %             elseif 14-threshold_sog<=sog && sog<=14+threshold_sog
                %                 % we verify that the delta_t corresponds to the two RI
                %                 % possible values (10s and 6s)
                %                 RI1=10;
                %                 RI1_min=RI1-0.2*RI1;
                %                 RI1_max=RI1+0.2*RI1;
                %                 RI2=6;
                %                 RI2_min=RI2-0.2*RI2;
                %                 RI2_max=RI2+0.2*RI2;
                %                 if (RI1_min<delta_t && delta_t<RI1_max) || (RI2_min<delta_t && delta_t<RI2_max)
                %                     % the sog measured respect the RI specified by the AIS
                %                     % standard
                %                 elseif (rem(delta_t,RI1)/RI1<=0.2 || rem(delta_t,RI1)/RI1<=0.8) || (rem(delta_t,RI2)/RI2<=0.2 || rem(delta_t,RI2)/RI2<=0.8)
                %                     list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                %                     if(sum(list_nb_r)>(60*nb_frame_stead/RI2))
                %                         disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                %                         fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                %                     else
                %                         disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                %                         fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                %                     end
                %                 else
                %                     list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                %                     if(sum(list_nb_r)>(60*nb_frame_stead/RI2))
                %                         disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                %                         fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                %                     else
                %                         disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                %                         fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                %                     end
                %                 end
            elseif 14 <= sog && sog<=23
                % we verify that the delta_t corresponds to the RI=6s
                RI=6;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                if RI_min<=delta_t && delta_t<=RI_max
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                    end
                else
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                    end
                end
                %             elseif 23-threshold_sog<=sog && sog<=23+threshold_sog
                %                 % we verify that the delta_t corresponds to the two RI
                %                 % possible values (6s and 2s)
                %                 RI1=6;
                %                 RI1_min=RI1-0.2*RI1;
                %                 RI1_max=RI1+0.2*RI1;
                %                 RI2=2;
                %                 RI2_min=RI2-0.2*RI2;
                %                 RI2_max=RI2+0.2*RI2;
                %                 if (RI1_min<delta_t && delta_t<RI1_max) || (RI2_min<delta_t && delta_t<RI2_max)
                %                     %                 the sog measured respect the RI specified by the AIS
                %                     %                 standard
                %                 elseif (rem(delta_t,RI1)/RI1<=0.2 || rem(delta_t,RI1)/RI1<=0.8) || (rem(delta_t,RI2)/RI2<=0.2 || rem(delta_t,RI2)/RI2<=0.8)
                %                     list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                %                     if(sum(list_nb_r)>(60*nb_frame_stead/RI2))
                %                         disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                %                         fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                %                     else
                %                         disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                %                         fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                %                     end
                %                 else
                %                     list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                %                     if(sum(list_nb_r)>(60*nb_frame_stead/RI2))
                %                         disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                %                         fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                %                     else
                %                         disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                %                         fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                %                         fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                %                     end
                %                 end
            else
                % we verify that the delta_t corresponds to the RI=2s
                RI=2;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                if RI_min<=delta_t && delta_t<=RI_max
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                    list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                    if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                    else
                        disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                        fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                        fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                    end
                else
                    list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                    if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                    else
                        disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                        fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                        fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                    end
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
            elseif rem(delta_t,RI)/RI<=0.027 || rem(delta_t,RI)/RI>=0.972
                list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                disp(["Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
            else
                list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                disp(["Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor),channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor),channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
            end
        else
            RI=10;
            RI_min=RI-0.2*RI;
            RI_max=RI+0.2*RI;
            % we verify that the delta_t corresponds to the RI=10s
            if RI_min<delta_t && delta_t<RI_max
                % the sog measured respect the RI specified by the AIS
                % standard
            elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                    disp(["Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                    fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                    fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                else
                    disp(["Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                    fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                    fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                end
            else
                list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS (ship at anchor), channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                end
            end
        end
    else
        if sog<=14
            RI=3.333;
            RI_min=RI-0.2*RI;
            RI_max=RI+0.2*RI;
            % we verify that the delta_t corresponds to the RI=10s
            if RI_min<=delta_t && delta_t<=RI_max
                % the sog measured respect the RI specified by the AIS
                % standard
            elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                    disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                    fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                    fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                else
                    disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                    fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                    fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                end
            else
                list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                end
            end
        else
            % we verify that the delta_t corresponds to the RI=6s
            RI=2;
            RI_min=RI-0.2*RI;
            RI_max=RI+0.2*RI;
            if RI_min<=delta_t && delta_t<=RI_max
                %                 the sog measured respect the RI specified by the AIS
                %                 standard
            elseif (RI_max<delta_t) && (rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8)
                list_nb_err_21(idx_mov_av)=list_nb_err_21(idx_mov_av)+1;
                if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                    disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_21)/sum(list_nb_r)]);
                    fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                    fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r);sum(list_nb_err_21)/sum(list_nb_r)]);
                else
                    disp(["Alert21: RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_21),"nb_r =", sum(list_nb_r)]);
                    fprintf(fid4,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                    fprintf(fid21,"Alert21: RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_21);sum(list_nb_r)]);
                end
            else
                list_nb_err_22(idx_mov_av)=list_nb_err_22(idx_mov_av)+1;
                if(sum(list_nb_r)>(60*nb_frame_stead/RI))
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r),"perc.=",sum(list_nb_err_22)/sum(list_nb_r)]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d, perc.=%f \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r);sum(list_nb_err_22)/sum(list_nb_r)]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id, "nb_error =", sum(list_nb_err_22),"nb_r =", sum(list_nb_r)]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d, nb_error= %d, nb_r=%d \n",[channel;mmsi;delta_t;sog;toa;id;sum(list_nb_err_22);sum(list_nb_r)]);
                end
            end
        end
    end
else
    if id_last==1 && id==1
        % non-maneuvering action
        mano=0;
    else
        mano=1;
    end
end

% end

boat.mano=mano;
if channel==1
    %     if the message has a repeat indicator equal to 1 the data are not
    %     considered
    if repeat_indicator~=1
        boat.id_last=id;
        boat.toa_last=toa;
    end
else
    if repeat_indicator~=1
        boat.id_last=id;
        boat.toa_last=toa;
    end
end
boat.list_nb_err_21=list_nb_err_21;
boat.list_nb_err_22=list_nb_err_22;
Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=boat;
Algorithm_out=Algorithm_in;
end
