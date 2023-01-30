%% Autre Algorithm simplified
clear all;
close all;

% filenamedata can vary from data1 to data9. We made 9 data acquisition
% compaign
filenamedata="data_hackathon";

table = table2array(readtable(filenamedata+"/sorted_table_100000.csv",'delimiter',';'));

% File that contains every alarm detected
filename_a_f='alerts_strategy.dat';
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

% Earth polar radius
Rn=6356752;
% Earth equatorial radius
Re=6378137;
% Kalman parameters
sigma_v_gps=5.3;
% latitude of the receiver that received the messages
y_re=48.359029;
x_re=-4.566914;

% longitude parameters
a_max=1; % acceleration maximal is 1nd.s^-2
sigma_v_x=sigma_v_gps/((Re*pi/180)*cos(y_re*pi/180));
sigma_w_x=0.5*a_max*0.514444/((Re*pi/180)*cos(y_re*pi/180))*0.8;
% latitude parameters
a_max=1; % acceleration maximal is 1nd.s^-2
sigma_v_y=sigma_v_gps/(Rn*pi/180);
sigma_w_y=0.5*a_max*0.514444/(Rn*pi/180)*0.8;

% number of consecutive frames in which the moving average is computed 
nb_frame_av=15;
% number of frames to consider the percentage error 
nb_frame_stead=3;

% Boat structure
Boat=struct('mmsi',0,'list_nb_r',zeros(1,nb_frame_av),'toa_init',0,'toa_last',0,'TS_last',0,'id_last',0,'NTR',0,'ListNTS_A',[],'ListNTS_B',[],'X_y_est',zeros(2,1),'X_y_pred',zeros(2,1),'X_x_est',zeros(2,1),'X_x_pred',zeros(2,1),'P_y_pred',zeros(2,2),'P_y_est',zeros(2,2),'P_x_pred',zeros(2,2),'P_x_est',zeros(2,2),'list_toa_mes',zeros(1,1),'mano',0,'mano_channel_A',0,'mano_channel_B',0,'nb_error_1_y',0,'nb_error_1_x',0,'list_nb_err_21',zeros(1,nb_frame_av),'list_nb_err_22',zeros(1,nb_frame_av),'list_nb_err_3',zeros(1,nb_frame_av));
% Structure that contain every boat controlled by the final algorithm
Struct_list_boat=struct('list_mmsi',[],'list_boat',[Boat],'nb_boat',0,'idx_new_boat',0,'idx_mov_av',1);
% Structure that contains the fix parameters of the Kalman filter
Kalman=struct('R_x',sigma_v_x^2,'R_y',sigma_v_y^2,'sigma_v_x',sigma_v_x,'sigma_v_y',sigma_v_y,'sigma_w_x',sigma_w_x,'sigma_w_y',sigma_w_y,'Rn',Rn,'Re',Re);
% Structure that contains every data received on a message
Data=struct('toa',[],'mmsi',[],'id',[],'slot_timeout',[],'rot',[],'sog',[],'x',[],'y',[],'cog',[],'true_heading',[],'timestamp',[],'slot_number',[],'slot_offset',[],'slot_increment',[],'keep_flag',[],'repeat_indicator',[],'nav_status',[],'nb_elements',0,'channel',[]);
% Structure of the algorithm
Algorithm=struct('Struct_list_boat',Struct_list_boat,'Kalman',Kalman,'idx_boat',0,'Data',Data,'x_re',x_re,'y_re',y_re,'R',6371000,'i',0,'toa_recal_past',0,'toa_recal_pres',0,'TS',0,'dec',0,'nb_frame_av',nb_frame_av,'nb_frame_stead',nb_frame_stead,'list_delta_t',[]);

% Creation of Algorithm_AIS
Algorithm_AIS=Algorithm;

% Data to control all the boats
% Messages are classified to assure that the toa are in an ascending order
% and added to the Data structure
toa=table(:,1);
toa_sorted=sort(toa);
N=length(toa_sorted);
Data.toa=toa_sorted;
Data.nb_elements=N;
idx_mes=1;
while idx_mes<N+1
    idx=find(toa==toa_sorted(idx_mes));
    len_idx=length(idx);
    Data.mmsi(idx_mes)=table(idx(1),2);
    Data.id(idx_mes)=table(idx(1),3);
    Data.nav_status(idx_mes)=table(idx(1),4);
    Data.slot_timeout(idx_mes)=table(idx(1),5);
    Data.rot(idx_mes)=table(idx(1),6);
    Data.sog(idx_mes)=table(idx(1),7);
    Data.x(idx_mes)=table(idx(1),8);
    Data.y(idx_mes)=table(idx(1),9);
    Data.cog(idx_mes)=table(idx(1),10);
    Data.true_heading(idx_mes)=table(idx(1),11);
    Data.timestamp(idx_mes)=table(idx(1),12);
    Data.slot_number(idx_mes)=table(idx(1),13);
    Data.slot_offset(idx_mes)=table(idx(1),14);
    Data.slot_increment(idx_mes)=table(idx(1),15);
    Data.keep_flag(idx_mes)=table(idx(1),16);
    Data.repeat_indicator(idx_mes)=table(idx(1),17);
    Data.channel(idx_mes)=table(idx(1),18);
    idx_mes=idx_mes+1;
    for j=2:len_idx
        Data.mmsi(idx_mes)=table(idx(j),2);
        Data.id(idx_mes)=table(idx(j),3);
        Data.nav_status(idx_mes)=table(idx(j),4);
        Data.slot_timeout(idx_mes)=table(idx(j),5);
        Data.rot(idx_mes)=table(idx(j),6);
        Data.sog(idx_mes)=table(idx(j),7);
        Data.x(idx_mes)=table(idx(j),8);
        Data.y(idx_mes)=table(idx(j),9);
        Data.cog(idx_mes)=table(idx(j),10);
        Data.true_heading(idx_mes)=table(idx(j),11);
        Data.timestamp(idx_mes)=table(idx(j),12);
        Data.slot_number(idx_mes)=table(idx(j),13);
        Data.slot_offset(idx_mes)=table(idx(j),14);
        Data.slot_increment(idx_mes)=table(idx(j),15);
        Data.keep_flag(idx_mes)=table(idx(j),16);
        Data.repeat_indicator(idx_mes)=table(idx(j),17);
        Data.channel(idx_mes)=table(idx(j),18);
        idx_mes=idx_mes+1;
    end
end

% Data.mmsi(98038)=000000000;
% Data.id(98038)=Data.id(98037);
% Data.nav_status(98038)=Data.nav_status(98037);
% Data.slot_timeout(98038)=Data.slot_timeout(98037);
% Data.rot(98038)=Data.rot(98037);
% Data.sog(98038)=Data.sog(98037);
% Data.x(98038)=Data.x(98037);
% Data.y(98038)=Data.y(98037);
% Data.cog(98038)=Data.cog(98037);
% Data.true_heading(98038)=Data.true_heading(98037);
% Data.timestamp(98038)=Data.timestamp(98037);
% Data.slot_number(98038)=Data.slot_number(98037);
% Data.slot_offset(98038)=Data.slot_offset(98037);
% Data.slot_increment(98038)=Data.slot_increment(98037);
% Data.keep_flag(98038)=Data.keep_flag(98037);
% Data.repeat_indicator(98038)=Data.repeat_indicator(98037);
% Data.channel(98038)=Data.channel(98037);

% recording of AIS data in the AIS algorithm.
Algorithm_AIS.Data=Data;

% synchronisation of the recorded time to the minute utc
Algorithm_AIS=time_synchronisation(Algorithm_AIS);

% Data to inform when we start a new frame
Algorithm_AIS.toa_recal_past=0;
Algorithm_AIS.toa_recal_pres=0;

% index of the first boat controlles by the final algorithm
Algorithm_AIS.Struct_list_boat.idx_new_boat=1;

% Loop on every message
for i=1:Algorithm_AIS.Data.nb_elements
    
    % update algorithms        
    Algorithm_AIS=strategy_update(Algorithm_AIS,i,fid4);
    
    % starting Rooter
    % Condition to know if the message comes from a new boat
    if sum(find(Algorithm_AIS.Struct_list_boat.list_mmsi==Algorithm_AIS.Data.mmsi(i)))>0
        % Find the index of the boat in the list of the boats recorded
        Algorithm_AIS.idx_boat=find(Algorithm_AIS.Struct_list_boat.list_mmsi==Algorithm_AIS.Data.mmsi(i));
        % Ending Rooter
        
        % STEADY STATE
        % Algorithm 1 is applied
        Algorithm_AIS=algorithm1(Algorithm_AIS,fid4,fid1);
        
        % Algorithm 2 is applied
        Algorithm_AIS=algorithm2(Algorithm_AIS,fid4,fid21,fid22);
        
        % Booking process is applied
        Algorithm_AIS=NTS_booking_process(Algorithm_AIS);
        
        % Algorithm 3 is applied
        Algorithm_AIS=algorithm3(Algorithm_AIS,fid4,fid3);
        
    else
        % INITIALISATION
        % A new boat is added to the boat controlled by the final algorithm
        Algorithm_AIS=recording_new_boat(Algorithm_AIS,fid4);
        
        % Booking process is applied
        Algorithm_AIS=NTS_booking_process(Algorithm_AIS);
    end
end
fclose(fid1);
fclose(fid21);
fclose(fid22);
fclose(fid3);
fclose(fid4);





