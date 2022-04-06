function Algorithm_AIS_out=NTS_booking_process(Algorithm_AIS_in,fid4)
[toa,mmsi,id,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,lat,lon,sog,cog,channel]=data_extraction(Algorithm_AIS_in);

indice=Algorithm_AIS_in.i;
if indice>1
    indice=indice-1;
end
toa_last=Algorithm_AIS_in.Data.toa(indice);


% Synchronisation of the toa to the minute UTC
Algorithm_AIS_in.toa_recal_pres=synch_tps_trame(toa,Algorithm_AIS_in.dec);

% Test to know if we start a new frame
if (Algorithm_AIS_in.toa_recal_pres-Algorithm_AIS_in.toa_recal_past<0) && (toa_last-toa<0)
%     update of the frame
    Algorithm_AIS_in=data_update(Algorithm_AIS_in,fid4);
end
Algorithm_AIS_in.toa_recal_past=Algorithm_AIS_in.toa_recal_pres;

% TS computation
Algorithm_AIS_in.TS=compute_TS(Algorithm_AIS_in,mmsi);

frame_next_A=Algorithm_AIS_in.Frame_next_A;
frame_next_B=Algorithm_AIS_in.Frame_next_B;
frame_pres_A=Algorithm_AIS_in.Frame_pres_A;
frame_pres_B=Algorithm_AIS_in.Frame_pres_B;
Algorithm_AIS_out=Algorithm_AIS_in;

if id==1 || id==2 % SOTDMA booking process
    if slot_timeout>0
        if channel==1
            frame_next_A.slot_timeout(Algorithm_AIS_in.TS)=slot_timeout-1;
            frame_next_A.TS(Algorithm_AIS_in.TS)=1;
            frame_next_A.mmsi(Algorithm_AIS_in.TS)=mmsi;
            for j=1:slot_timeout
                frame_next_A.TS(Algorithm_AIS_in.TS+(j-1)*2250)=1;
                frame_next_A.slot_timeout(Algorithm_AIS_in.TS+(j-1)*2250)=slot_timeout-1;
                frame_next_A.id(Algorithm_AIS_in.TS+(j-1)*2250)=1;
                frame_next_A.mmsi(Algorithm_AIS_in.TS+(j-1)*2250)=mmsi;
            end
        end
        if channel==2
            frame_next_B.slot_timeout(Algorithm_AIS_in.TS)=slot_timeout-1;
            frame_next_B.TS(Algorithm_AIS_in.TS)=1;
            frame_next_B.mmsi(Algorithm_AIS_in.TS)=mmsi;
            for j=1:slot_timeout
                frame_next_B.TS(Algorithm_AIS_in.TS+(j-1)*2250)=1;
                frame_next_B.slot_timeout(Algorithm_AIS_in.TS+(j-1)*2250)=slot_timeout-1;
                frame_next_B.id(Algorithm_AIS_in.TS+(j-1)*2250)=1;
                frame_next_B.mmsi(Algorithm_AIS_in.TS+(j-1)*2250)=mmsi;
            end
        end
    elseif slot_timeout==0
        if slot_offset>0
            if channel==1
                frame_next_A.TS(Algorithm_AIS_in.TS+slot_offset-2250)=1;
                frame_next_A.mmsi(Algorithm_AIS_in.TS+slot_offset-2250)=mmsi;
                frame_next_A.id(Algorithm_AIS_in.TS+slot_offset-2250)=1;
                %For the next frame with the same TS we cancel the booking
                %done for this TS
                for j=0:6
                    frame_next_A.TS(Algorithm_AIS_in.TS+j*2250)=-2;
                end
            end
            if channel==2
                frame_next_B.TS(Algorithm_AIS_in.TS+slot_offset-2250)=1;
                frame_next_B.mmsi(Algorithm_AIS_in.TS+slot_offset-2250)=mmsi;
                frame_next_B.id(Algorithm_AIS_in.TS+slot_offset-2250)=1;
                %For the next frame with the same TS we cancel the booking
                %done for this TS
                for j=0:6
                    frame_next_B.TS(Algorithm_AIS_in.TS+j*2250)=-2;
                end
            end
        end
    end
elseif id==3  % ITDMA booking process
    if keep_flag==1
        if channel==1
            frame_next_A.id(Algorithm_AIS_in.TS)=1;
            frame_next_A.TS(Algorithm_AIS_in.TS)=1;
            frame_next_A.mmsi(Algorithm_AIS_in.TS)=mmsi;
        end
        if channel==2
            frame_next_B.id(Algorithm_AIS_in.TS)=1;
            frame_next_B.TS(Algorithm_AIS_in.TS)=1;
            frame_next_B.mmsi(Algorithm_AIS_in.TS)=mmsi;
        end
    end
    if slot_increment>0
        if slot_increment+Algorithm_AIS_in.TS>2250
            if channel==1
                frame_next_A.TS(Algorithm_AIS_in.TS+slot_increment-2250)=1;
                frame_next_A.id(Algorithm_AIS_in.TS+slot_increment-2250)=3;
                frame_next_A.mmsi(Algorithm_AIS_in.TS+slot_increment-2250)=mmsi;
            end
            if channel==2
                frame_next_B.TS(Algorithm_AIS_in.TS+slot_increment-2250)=1;
                frame_next_B.id(Algorithm_AIS_in.TS+slot_increment-2250)=3;
                frame_next_B.mmsi(Algorithm_AIS_in.TS+slot_increment-2250)=mmsi;
            end
        else
            if channel==1
                frame_pres_A.TS(Algorithm_AIS_in.TS+slot_increment)=1;
                frame_pres_A.id(Algorithm_AIS_in.TS+slot_increment)=3;
                frame_pres_A.mmsi(Algorithm_AIS_in.TS+slot_increment)=mmsi;
            end
            if channel==2
                frame_pres_B.TS(Algorithm_AIS_in.TS+slot_increment)=1;
                frame_pres_B.id(Algorithm_AIS_in.TS+slot_increment)=3;
                frame_pres_B.mmsi(Algorithm_AIS_in.TS+slot_increment)=mmsi;
            end
        end
    end
end
Algorithm_AIS_out.Frame_next_A=frame_next_A;
Algorithm_AIS_out.Frame_next_B=frame_next_B;
Algorithm_AIS_out.Frame_pres_A=frame_pres_A;
Algorithm_AIS_out.Frame_pres_B=frame_pres_B;
end