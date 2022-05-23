function Algorithm_out=NTS_booking_process(Algorithm_in)
[toa,mmsi,id,nav_status,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,lat,lon,sog,cog,channel]=data_extraction(Algorithm_in);

Struct_list_boat=Algorithm_in.Struct_list_boat;
boat=Struct_list_boat.list_boat(Algorithm_in.idx_boat);

ListNTS_A=boat.ListNTS_A;
ListNTS_B=boat.ListNTS_B;

if channel==1
    if id==1 || id==2 % SOTDMA booking process
        if slot_timeout>0
            for j=1:slot_timeout
                ListNTS_A(end+1)=Algorithm_in.TS+j*2250;
            end
        elseif slot_timeout==0
            if slot_offset>0
                ListNTS_A(end+1)=Algorithm_in.TS+slot_offset;
            end
        end
    elseif id==3  % ITDMA booking process
        if keep_flag==1
            ListNTS_A(end+1)=Algorithm_in.TS+2250;
        end
        if (nav_status==1||nav_status==5)
            ListNTS_A(end+1)=Algorithm_in.TS+slot_increment+8192;
        else
            if slot_increment>0
                ListNTS_A(end+1)=Algorithm_in.TS+slot_increment;
            end
        end
    end
else
    if id==1 || id==2 % SOTDMA booking process
        if slot_timeout>0
            for j=1:slot_timeout
                ListNTS_B(end+1)=Algorithm_in.TS+j*2250;
            end
        elseif slot_timeout==0
            if slot_offset>0
                ListNTS_B(end+1)=Algorithm_in.TS+slot_offset;
            end
        end
    elseif id==3  % ITDMA booking process
        if keep_flag==1
            ListNTS_B(end+1)=Algorithm_in.TS+2250;
        end
        if (nav_status==1||nav_status==5)
            ListNTS_B(end+1)=Algorithm_in.TS+slot_increment+8192;
        else
            if slot_increment>0
                ListNTS_B(end+1)=Algorithm_in.TS+slot_increment;
            end
        end
    end
end

%Update boat information
boat.ListNTS_A=ListNTS_A;
boat.ListNTS_B=ListNTS_B;

%Update Algorithm information
Algorithm_out=Algorithm_in;
Algorithm_out.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=boat;

end