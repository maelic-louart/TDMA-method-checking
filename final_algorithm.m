%% Autre Algorithm simplified
clear all;
close all;

%First list of measurement
% filename = 'data1/sorted_table.csv';

%Second list of measurement (data used in to applied the final algorithm)
% filename='data2/sorted_table.csv';

% Third list of measurement
% filename='data3/sorted_table.csv';

% fourth list of measurement
filename='data4/sorted_table.csv';

% filename ='NMEA_frame/enreistrement_01-06-2021-11h35_sorted_table.csv';
% filename ='NMEA_frame/transrade_11h30mn_03-12-2021_sorted_table.csv';

fid0 = fopen(filename);

textLine = fgets(fid0); % Read first line.
lineCounter = 1;

while ischar(textLine)
    fprintf('\nLine #%d of text = %s\n', lineCounter, textLine);
    T = textscan(textLine, '%f', 'Delimiter', ';');
    table(lineCounter,1:length(T{1,1}))=T{1,1}';
    textLine = fgets(fid0);
    lineCounter = lineCounter + 1;
end
fclose(fid0);


% File that contains every alarm detected
filename_a_f='alerts_algorithm_final.dat';
fid4 = fopen(filename_a_f,'w');

% File that contains every alarm of the algorithm1
filename_a_1='alerts_algorithm_1.dat';
fid1=fopen(filename_a_1,'w');

% File that contains every alarm of the algorithm2
% Alert concerning a RI that is a multiple of the RI specified by the
% standard
filename_a_21='alerts_algorithm_21.dat';
fid21=fopen(filename_a_21,'w');
% Alert concerning a RI that is not a multiple of the RI specified by the
% standard
filename_a_22='alerts_algorithm_22.dat';
fid22=fopen(filename_a_22,'w');

% File that contains every alarm of the algorithm3 that detects that a
% message was received but not reserved
filename_a_3='alerts_algorithm_3.dat';
fid3=fopen(filename_a_3,'w');



% Kalman parameters
sigma_v=0.000053;
sigma_w=0.000005*1/2*0.8;

% Boat structure
Boat=struct('mmsi',0,'num_mes',0,'toa_init',0,'toa_last',0,'TS_last',0,'id_last',0,'NTR',0,'X_lat_est',zeros(2,1),'X_lat_pred',zeros(2,1),'X_lon_est',zeros(2,1),'X_lon_pred',zeros(2,1),'P_lat_pred',zeros(2,2),'P_lat_est',zeros(2,2),'P_lon_pred',zeros(2,2),'P_lon_est',zeros(2,2),'list_toa_mes',zeros(1,1),'mano',0,'mano_channel_A',0,'mano_channel_B',0,'nb_error_lat',0,'nb_error_lon',0);
% List NTS structure short
ListNTSshort=struct('mmsi',-2.*ones(1,2250),'TS',-2.*ones(1,2250),'id',-2.*ones(1,2250),'slot_timeout',-2.*ones(1,2250));
% List NTS structure long
ListNTSlong=struct('mmsi',-2.*ones(1,2250*7),'TS',-2.*ones(1,2250*7),'id',-2.*ones(1,2250*7),'slot_timeout',-2.*ones(1,2250*7));
% Structure that contain every boat controlled by the final algorithm
Struct_list_boat=struct('list_mmsi',[0],'list_boat',[Boat],'nb_boat',0,'idx_new_boat',0,'max_nb_boat',0);
% Structure that contains the fix parameters of the Kalman filter
Kalman=struct('R',sigma_v^2,'sigma_v',sigma_v,'sigma_w',sigma_w,'Rn',6356752,'Re',6378137);
% Structure that contains every data received on a message
Data=struct('toa',[],'mmsi',[],'id',[],'slot_timeout',[],'rot',[],'sog',[],'x',[],'y',[],'cog',[],'true_heading',[],'timestamp',[],'slot_number',[],'slot_offset',[],'slot_increment',[],'keep_flag',[],'repeat_indicator',[],'nb_elements',0,'channel',[]);
% Structure of the algorithm
Algorithm=struct('Struct_list_boat',Struct_list_boat,'Kalman',Kalman,'Frame_past_A',ListNTSshort,'Frame_pres_A',ListNTSshort,'Frame_next_A',ListNTSlong,'Frame_past_B',ListNTSshort,'Frame_pres_B',ListNTSshort,'Frame_next_B',ListNTSlong,'idx_boat',0,'Data',Data,'R',6371000,'i',0,'toa_recal_past',0,'toa_recal_pres',0,'TS',0,'dec',0,'list_inno_lat',[],'list_inno_lon',[],'list_inno_sog',[],'list_delta_t',[],'list_S_lat',[],'list_S_lon',[],'list_S_sog',[]);



% Data to control all the boats
% Messages are classified to assure that the toa are in an ascending order
% and added to the Data structure
toa=table(:,1);
toa_sorted=sort(toa);
N=length(toa_sorted);
Data.toa=toa_sorted;
Data.nb_elements=N;
for i=1:N
    idx=find(toa==toa_sorted(i));
    len_idx=length(idx);
    Data.mmsi(i)=table(idx(1),2);
    Data.id(i)=table(idx(1),3);
    Data.slot_timeout(i)=table(idx(1),4);
    Data.rot(i)=table(idx(1),5);
    Data.sog(i)=table(idx(1),6);
    Data.x(i)=table(idx(1),8);
    Data.y(i)=table(idx(1),7);
    Data.cog(i)=table(idx(1),9);
    Data.true_heading(i)=table(idx(1),10);
    Data.timestamp(i)=table(idx(1),11);
    Data.slot_number(i)=table(idx(1),12);
    Data.slot_offset(i)=table(idx(1),13);
    Data.slot_increment(i)=table(idx(1),14);
    Data.keep_flag(i)=table(idx(1),15);
    Data.repeat_indicator(i)=table(idx(1),16);
    Data.channel(i)=table(idx(1),18);
    for j=2:len_idx
        i=i+1;
        Data.mmsi(i)=table(idx(j),2);
        Data.id(i)=table(idx(j),3);
        Data.slot_timeout(i)=table(idx(j),4);
        Data.rot(i)=table(idx(j),5);
        Data.sog(i)=table(idx(j),6);
        Data.x(i)=table(idx(j),7);
        Data.y(i)=table(idx(j),8);
        Data.cog(i)=table(idx(j),9);
        Data.true_heading(i)=table(idx(j),10);
        Data.timestamp(i)=table(idx(j),11);
        Data.slot_number(i)=table(idx(j),12);
        Data.slot_offset(i)=table(idx(j),13);
        Data.slot_increment(i)=table(idx(j),14);
        Data.keep_flag(i)=table(idx(j),15);
        Data.repeat_indicator(i)=table(idx(j),16);
        Data.channel(i)=table(idx(j),18);
    end
end

% synchronisation of the TS computed and the TS presented sometimes in
% messages
toa_mes_tabl=Data.toa;
time_slot_tabl=toa_mes_tabl;
for i=1:length(toa_mes_tabl(:,1))
    ligne_toa=toa_mes_tabl(i,:);
    ligne_t_s=toa_mes_tabl(i,:);
    for j=1:length(ligne_toa)
        while (ligne_toa(j)>60)
            ligne_toa(j)=ligne_toa(j)-60;
        end
        ligne_t_s(j)=round(ligne_toa(j)/0.02667);
    end
    time_slot_tabl(i,:)=ligne_t_s;
end
time_slot_comp= time_slot_tabl(:,1); %time slot computed

slot_number_mes=Data.slot_number(1,:);

slot_number_mes=Data.slot_number(1,:);
% Computation of the difference between the TS presented in messages and the
% TS computed
indice=0;
for i=1:length(slot_number_mes)
    if slot_number_mes(i)~=-1 && indice<1
        dec=slot_number_mes(i)-time_slot_comp(i);
        indice=indice+1;
    end
end

% Update of Algorithm_AIS structure
Algorithm_AIS=Algorithm;
Algorithm_AIS.Data=Data;
Algorithm_AIS.dec=dec;

%Data to inform when we start a new frame
Algorithm_AIS.toa_recal_past=0;
Algorithm_AIS.toa_recal_pres=0;

% index of the first boat controlles by the final algorithm
Algorithm_AIS.Struct_list_boat.idx_new_boat=1;

% maximum number of boat controlled
Algorithm_AIS.Struct_list_boat.max_nb_boat=30;

% Loop on every message
for i=1:Algorithm_AIS.Data.nb_elements
    
    Algorithm_AIS.i=i;
    %Data extraction of the AIS message
    [toa,mmsi,id,keep_flag,repeat_indicator,slot_timeout,slot_increment,slot_offset,lat,lon,sog,cog,channel]=data_extraction(Algorithm_AIS);
    
    % starting Rooter
    %Condition to know if the message comes from a new boat
    if sum(find(Algorithm_AIS.Struct_list_boat.list_mmsi==mmsi))>0
        
        %Find the index of the boat in the list of the boats recorded
        Algorithm_AIS.idx_boat=find(Algorithm_AIS.Struct_list_boat.list_mmsi==mmsi);
        
        % Ending Rooter
        
        %STEADY STATE         
        
        % Algorithm 1 is applied
        Algorithm_AIS=algorithm1(Algorithm_AIS,fid4,fid1);
        
        % Algorithm 2 is applied
        Algorithm_AIS=algorithm2(Algorithm_AIS,fid4,fid21,fid22,sog,id,toa,repeat_indicator,channel);
        
        % Booking process is applied
        Algorithm_AIS=NTS_booking_process(Algorithm_AIS,fid4);
        
        % Algorithm 3 is applied
        Algorithm_AIS=algorithm3(Algorithm_AIS,fid4,fid3);
        
    else
        %INITIALISATION
        
        %A new boat is added to the boat controlled by the final algorithm
        Algorithm_AIS.Struct_list_boat=recording_new_boat(Algorithm_AIS,mmsi,lat,lon,sog,toa,id,fid4);
        
        % Booking process is applied
        Algorithm_AIS=NTS_booking_process(Algorithm_AIS,fid4);
    end
end


fclose(fid1);
fclose(fid21);
fclose(fid22);
fclose(fid3);
fclose(fid4);



% computation of the characteristics of the thresholds and absolute values of innovation
list_inno_lat=Algorithm_AIS.list_inno_lat;
list_inno_lon=Algorithm_AIS.list_inno_lon;
list_inno_sog=Algorithm_AIS.list_inno_sog;
list_S_lat=Algorithm_AIS.list_S_lat;
list_S_lon=Algorithm_AIS.list_S_lon;
list_S_sog=Algorithm_AIS.list_S_sog;

% the values equal to 0 are removed because it corresponds to
% initialisation phase that concerns the two first messages of every ship
idx_steady_state=find(list_S_lat~=0);
% The idx of steady state are the same for latitude, longitude and sog
list_S_lat_steady_state=list_S_lat(idx_steady_state);
list_S_lon_steady_state=list_S_lon(idx_steady_state);
list_S_sog_steady_state=list_S_sog(idx_steady_state);
list_inno_lat_steady_state=list_inno_lat(idx_steady_state);
list_inno_lon_steady_state=list_inno_lon(idx_steady_state);
list_inno_sog_steady_state=list_inno_sog(idx_steady_state);
list_delta_t=Algorithm_AIS.list_delta_t;
list_delta_t_steady_state=list_delta_t(idx_steady_state);
% We remove every message with a reporting interval to high
idx_delta_t=find(list_delta_t_steady_state<15);
list_S_lat_purged=list_S_lat_steady_state(idx_delta_t);
list_S_lon_purged=list_S_lon_steady_state(idx_delta_t);
list_S_sog_purged=list_S_sog_steady_state(idx_delta_t);
list_inno_lat_purged=list_inno_lat_steady_state(idx_delta_t);
list_inno_lon_purged=list_inno_lon_steady_state(idx_delta_t);
list_inno_sog_purged=list_inno_sog_steady_state(idx_delta_t);


% data concerning latitude
mean_lat_inno=mean(abs(list_inno_lat_purged));
std_lat_inno=std(abs(list_inno_lat_purged));
mean_S_lat=mean(5*sqrt(list_S_lat_purged));
std_S_lat=std(5*sqrt(list_S_lat_purged));

% data concerning longitude
mean_lon_inno=mean(abs(list_inno_lon_purged));
std_lon_inno=std(abs(list_inno_lon_purged));
mean_S_lon=mean(5*sqrt(list_S_lon_purged));
std_S_lon=std(5*sqrt(list_S_lon_purged));

% data concerning velocity
mean_sog_inno=mean(abs(list_inno_sog_purged));
std_sog_inno=std(abs(list_inno_sog_purged));
mean_S_sog=mean(3*sqrt(list_S_sog_purged+1));
std_S_sog=std(3*sqrt(list_S_sog_purged+1));

mean_delta_t=mean(abs(list_delta_t));



