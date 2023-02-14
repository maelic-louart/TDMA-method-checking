%% Autre Algorithm simplified
clear all;
close all;

% read the file that contains messages
foldernamedata="data/";
foldernamestatistical="statistical_data/";
filename="sorted_table.csv";
% filename_falified="sorted_table_228408900.csv";
table = table2array(readtable(foldernamedata+filename,'delimiter',';'));

% File that contains every message with identity and dynamic data
filename_mes_json='message_strategy.json';
fid5_json=fopen(filename_mes_json,'w');
fprintf(fid5_json,"[");

% File that contains every alarm detected
filename_a_f='alerts_strategy.dat';
filename_a_f_json='alerts_strategy.json';
fid4 = fopen(filename_a_f,'w');
fid4_json=fopen(filename_a_f_json,'w');
fprintf(fid4_json,"[");

% File that contains every alarm of the algorithm1
filename_a_1='alerts_algorithm_1.dat';
filename_a_1_json='alerts_algorithm_1.json';
fid1=fopen(filename_a_1,'w');
fid1_json=fopen(filename_a_1_json,'w');
fprintf(fid1_json,"[");

% File that contains every alarm of the algorithm2
% Alert concerning a RI that is a multiple of the RI specified by the
% standard
filename_a_21='alerts_algorithm_21.dat';
filename_a_21_json='alerts_algorithm_21.json';
fid21=fopen(filename_a_21,'w');
fid21_json=fopen(filename_a_21_json,'w');
fprintf(fid21_json,"[");

% Alert concerning a RI that is not a multiple of the RI specified by the
% standard
filename_a_22='alerts_algorithm_22.dat';
filename_a_22_json='alerts_algorithm_22.json';
fid22=fopen(filename_a_22,'w');
fid22_json=fopen(filename_a_22_json,'w');
fprintf(fid22_json,"[");

% File that contains every alarm of the algorithm3 that detects that a
% message was received but not reserved
filename_a_3='alerts_algorithm_3.dat';
filename_a_3_json='alerts_algorithm_3.json';
fid3=fopen(filename_a_3,'w');
fid3_json=fopen(filename_a_3_json,'w');
fprintf(fid3_json,"[");

% Earth polar radius
Rn=6356752;
% Earth equatorial radius
Re=6378137;
% Kalman parameters
sigma_v_gps=5.3;
% latitude of the receiver that received the messages
y_re=48.359029;
x_re=-4.566914;
% conversion meter to degre
%latitude
mtodeg_x=1/((Re*pi/180)*cos(y_re*pi/180));
%longitude
mtodeg_y=1/(Rn*pi/180);
% longitude parameters
a_max=1; % acceleration maximal is 1nd.s^-2
sigma_w_x=sigma_v_gps*mtodeg_x;
sigma_v_x=0.5*a_max*0.514444/((Re*pi/180)*cos(y_re*pi/180))*0.8;
% latitude parameters
a_max=1; % acceleration maximal is 1nd.s^-2
sigma_w_y=sigma_v_gps*mtodeg_y;
sigma_v_y=0.5*a_max*0.514444/(Rn*pi/180)*0.8;

% number of consecutive frames in which the moving average is computed 
nb_frame_av=15;
% number of frames to consider the percentage error 
nb_frame_stead=3;

% Boat structure
Boat=struct('mmsi',0,'list_nb_r1',zeros(1,nb_frame_av),'list_nb_r21',zeros(1,nb_frame_av),'list_nb_r22',zeros(1,nb_frame_av),'list_nb_r3',zeros(1,nb_frame_av),'toa_init',0,'toa_last',0,'TS_last',0,'id_last',0,'nav_status_last',0,'NTR',0,'ListNTS_A',[],'ListNTS_B',[],'X_y_est',zeros(2,1),'X_y_pred',zeros(2,1),'X_x_est',zeros(2,1),'X_x_pred',zeros(2,1),'P_y_pred',zeros(2,2),'P_y_est',zeros(2,2),'P_x_pred',zeros(2,2),'P_x_est',zeros(2,2),'list_toa_mes',zeros(1,1),'mano',0,'mano_channel_A',0,'mano_channel_B',0,'nb_error_1_y',0,'nb_error_1_x',0,'list_nb_err_21',zeros(1,nb_frame_av),'list_nb_err_22',zeros(1,nb_frame_av),'list_nb_err_3',zeros(1,nb_frame_av));
% Structure that contain every boat controlled by the final algorithm
Struct_list_boat=struct('list_mmsi',[],'list_boat',[Boat],'nb_boat',0,'idx_new_boat',0,'idx_mov_av',1);
% Structure that contains the fix parameters of the Kalman filter
Kalman=struct('R_x',sigma_w_x^2,'R_y',sigma_w_y^2,'sigma_w_x',sigma_w_x,'sigma_w_y',sigma_w_y,'sigma_v_x',sigma_v_x,'sigma_v_y',sigma_v_y,'Rn',Rn,'Re',Re);
% Structure that contains every data received on a message
Data=struct('toa',[],'mmsi',[],'id',[],'slot_timeout',[],'rot',[],'sog',[],'x',[],'y',[],'cog',[],'true_heading',[],'timestamp',[],'slot_number',[],'slot_offset',[],'slot_increment',[],'keep_flag',[],'repeat_indicator',[],'nav_status',[],'nb_elements',0,'channel',[]);
% Structure of the algorithm
Algorithm=struct('Struct_list_boat',Struct_list_boat,'Kalman',Kalman,'idx_boat',0,'Data',Data,'x_re',x_re,'y_re',y_re,'R',6371000,'i',0,'toa_recal_past',0,'toa_recal_pres',0,'TS',0,'dec',0,'nb_frame_av',nb_frame_av,'nb_frame_stead',nb_frame_stead,'list_inno_y',[],'list_inno_x',[],'list_inno_sog',[],'list_delta_t',[],'list_S_y',[],'list_S_x',[],'list_S_sog',[]);

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
% recording of AIS data in the AIS algorithm.
Algorithm_AIS.Data=Data;

% synchronisation of the recorded time to the minute utc
Algorithm_AIS=time_synchronisation(Algorithm_AIS);

% Data to inform when we start a new frame
Algorithm_AIS.toa_recal_past=0;
Algorithm_AIS.toa_recal_pres=0;

% index of the first boat controlles by the final algorithm
Algorithm_AIS.Struct_list_boat.idx_new_boat=1;

tic
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
        Algorithm_AIS=algorithm1(Algorithm_AIS,fid4,fid1,fid4_json,fid1_json);
        
        % Algorithm 2 is applied
        Algorithm_AIS=algorithm2(Algorithm_AIS,fid4,fid21,fid22,fid4_json,fid21_json,fid22_json,fid5_json);
        
        % Booking process is applied
        Algorithm_AIS=NTS_booking_process(Algorithm_AIS);
        
        % Algorithm 3 is applied
        Algorithm_AIS=algorithm3(Algorithm_AIS,fid4,fid3,fid4_json,fid3_json);
        
    else
        % INITIALISATION
        % A new boat is added to the boat controlled by the final algorithm
        Algorithm_AIS=recording_new_boat(Algorithm_AIS,fid4);
        
        % Booking process is applied
        Algorithm_AIS=NTS_booking_process(Algorithm_AIS);
    end
end
toc
encodedJSON=jsonencode(struct('mmsi',Data.mmsi(end),'id',Data.id(end),'lat',Data.y(end),'lon',Data.x(end),'sog',Data.sog(end),'cog',Data.cog(end),'toa',Data.toa(end),'nb_error',0,'nb_r',0,'perc',0));
fprintf(fid1_json, encodedJSON); 
fprintf(fid21_json, encodedJSON); 
fprintf(fid22_json, encodedJSON); 
fprintf(fid3_json, encodedJSON); 
fprintf(fid4_json, encodedJSON); 
fprintf(fid5_json, encodedJSON); 
fprintf(fid1_json,"]");
fprintf(fid21_json,"]");
fprintf(fid22_json,"]");
fprintf(fid3_json,"]");
fprintf(fid4_json,"]");
fprintf(fid5_json,"]");
fclose(fid1);
fclose(fid1_json);
fclose(fid21);
fclose(fid21_json);
fclose(fid22);
fclose(fid22_json);
fclose(fid3);
fclose(fid3_json);
fclose(fid4);
fclose(fid4_json);
fclose(fid5_json);

%we delete the absurd values
idx_absurd_x=find(abs(Algorithm_AIS.list_inno_x/mtodeg_x)<100);
idx_absurd_y=find(abs(Algorithm_AIS.list_inno_y/mtodeg_y)<100);

% we record data
writematrix(Algorithm_AIS.list_inno_x/mtodeg_x,foldernamestatistical+"list_inno_x.dat");
writematrix(sqrt(Algorithm_AIS.list_S_x)/mtodeg_x,foldernamestatistical+"list_S_x.dat");
writematrix(Algorithm_AIS.list_inno_y/mtodeg_y,foldernamestatistical+"list_inno_y.dat");
writematrix(sqrt(Algorithm_AIS.list_S_y)/mtodeg_y,foldernamestatistical+"list_S_y.dat");
writematrix(Algorithm_AIS.list_inno_sog,foldernamestatistical+"list_inno_sog.dat");
writematrix(sqrt(Algorithm_AIS.list_S_sog),foldernamestatistical+"list_S_sog.dat");
writematrix(Algorithm_AIS.Data.toa',foldernamestatistical+"list_toa.dat");

% we compute standard deviation
std_inno_x=std(Algorithm_AIS.list_inno_x(idx_absurd_x)/mtodeg_x);
std_inno_y=std(Algorithm_AIS.list_inno_y(idx_absurd_y)/mtodeg_y);
std_inno_sog=std(Algorithm_AIS.list_inno_sog);







