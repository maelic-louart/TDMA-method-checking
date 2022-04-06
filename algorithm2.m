function Algorithm_out=algorithm2(Algorithm_in,fid4,fid21,fid22,sog,id,toa,repeat_indicator,channel)

boat=Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat);
NTR=boat.NTR;
mmsi=boat.mmsi;
id_last=boat.id_last;
toa_last=boat.toa_last;
delta_t=toa-toa_last;
% sog computed by the algorithm 1
% sog threshold fixes to 1nd
threshold_sog=1;
mano=1;


% Initialisation phase finished?
if toa-boat.toa_init>60
    if NTR==1
        if id_last==1 && id==1
            %  non-maneuvering action
            mano=0;
            if sog<14-threshold_sog
                % we verify that the delta_t corresponds to the RI=10s
                RI=10;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                if RI_min<delta_t && delta_t<RI_max
                    % the sog measured respect the RI specified by the AIS
                    % standard
                elseif rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8
                    disp(["Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid21,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                end
            elseif 14-threshold_sog<=sog && sog<=14+threshold_sog
                % we verify that the delta_t corresponds to the two RI
                % possible values (10s and 6s)
                RI1=10;
                RI1_min=RI1-0.2*RI1;
                RI1_max=RI1+0.2*RI1;
                RI2=6;
                RI2_min=RI2-0.2*RI2;
                RI2_max=RI2+0.2*RI2;
                if (RI1_min<delta_t && delta_t<RI1_max) || (RI2_min<delta_t && delta_t<RI2_max)
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                elseif (rem(delta_t,RI1)/RI1<=0.2 || rem(delta_t,RI1)/RI1<=0.8) || (rem(delta_t,RI2)/RI2<=0.2 || rem(delta_t,RI2)/RI2<=0.8)
                    disp(["Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid21,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                end
            elseif 14+threshold_sog < sog && sog<23-threshold_sog
                % we verify that the delta_t corresponds to the RI=6s
                RI=6;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                if RI_min<delta_t && delta_t<RI_max
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                elseif rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8
                    disp(["Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid21,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                end
            elseif 23-threshold_sog<=sog && sog<=23+threshold_sog
                % we verify that the delta_t corresponds to the two RI
                % possible values (6s and 2s)
                RI1=6;
                RI1_min=RI1-0.2*RI1;
                RI1_max=RI1+0.2*RI1;
                RI2=2;
                RI2_min=RI2-0.2*RI2;
                RI2_max=RI2+0.2*RI2;
                if (RI1_min<delta_t && delta_t<RI1_max) || (RI2_min<delta_t && delta_t<RI2_max)
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                elseif (rem(delta_t,RI1)/RI1<=0.2 || rem(delta_t,RI1)/RI1<=0.8) || (rem(delta_t,RI2)/RI2<=0.2 || rem(delta_t,RI2)/RI2<=0.8)
                    disp(["Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid21,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                end
            elseif 23+threshold_sog<sog
                % we verify that the delta_t corresponds to the RI=2s
                RI=2;
                RI_min=RI-0.2*RI;
                RI_max=RI+0.2*RI;
                if RI_min<delta_t && delta_t<RI_max
                    %                 the sog measured respect the RI specified by the AIS
                    %                 standard
                elseif rem(delta_t,RI)/RI<=0.2 || rem(delta_t,RI)/RI>=0.8
                    disp(["Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid21,"Alert21: RI does not respect the vessel velocity specified by the AIS but the RI is a multiple of the RI specified by standard, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                else
                    disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                    fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                    fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS, channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                end
            else
                disp(["Alert22: RI does not respect the vessel velocity specified by the AIS, channel=",channel,"mmsi=",mmsi,"delta t =",delta_t,"sog_mes =",sog,"toa =", toa,"id =",id]);
                fprintf(fid4,"Alert22: RI does not respect the vessel velocity specified by the AIS,channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
                fprintf(fid22,"Alert22: RI does not respect the vessel velocity specified by the AIS,channel=%d, mmsi=%d, delta t=%f, sog_mes=%f, toa=%f, id=%d \n",[channel;mmsi;delta_t;sog;toa;id]);
            end
        else
            mano=1;
        end
    else
        if id_last==1 && id==1
            %         non-maneuvering action
            mano=0;
        else
            mano=1;
        end
    end
    
end

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

Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=boat;
Algorithm_out=Algorithm_in;
end
