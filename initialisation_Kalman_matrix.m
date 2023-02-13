function Algorithm_out=initialisation_Kalman_matrix(Algorithm_in,fid4,fid1)

Struct_list_boat=Algorithm_in.Struct_list_boat;
% indice of the moving average
idx_mov_av=Struct_list_boat.idx_mov_av;
% boat extraction
Boat_update=Struct_list_boat.list_boat(Algorithm_in.idx_boat);
j=Algorithm_in.i;
sigma_v_x=Algorithm_in.Kalman.sigma_v_x;
sigma_v_y=Algorithm_in.Kalman.sigma_v_y;

toa_last=Boat_update.toa_last;
last_x_mes=Boat_update.X_x_est(1);
last_y_mes=Boat_update.X_y_est(1);

toa_mes=Algorithm_in.Data.toa(j);
x_mes=Algorithm_in.Data.x(j);
y_mes=Algorithm_in.Data.y(j);
if(x_mes==181 || last_x_mes==181 || y_mes==91 || last_y_mes==91)
    fprintf(fid1,"measurment not avaiblable in position, mmsi=%d, toa=%f \n",[Boat_update.mmsi;toa_mes]);
    fprintf(fid4,"measurment not available in position, mmsi=%d, toa=%f \n",[Boat_update.mmsi,toa_mes]);
    Boat_update.list_nb_r1(idx_mov_av)=Boat_update.list_nb_r1(idx_mov_av);
else
    Boat_update.list_nb_r1(idx_mov_av)=Boat_update.list_nb_r1(idx_mov_av)+1;
end

delta_t=toa_mes-toa_last;
x_speed_mes=(x_mes-last_x_mes)/delta_t;
y_speed_mes=(y_mes-last_y_mes)/delta_t;
Boat_update.TS_last=Algorithm_in.TS;
Boat_update.X_x_pred=[x_mes;x_speed_mes];
Boat_update.X_x_est=[x_mes;x_speed_mes];
Boat_update.X_y_pred=[y_mes;y_speed_mes];
Boat_update.X_y_est=[y_mes;y_speed_mes];
Boat_update.P_x_pred=[sigma_v_x^2,sigma_v_x^2/delta_t;sigma_v_x^2/delta_t,2*sigma_v_x^2/delta_t^2];
Boat_update.P_x_est=[sigma_v_x^2,sigma_v_x^2/delta_t;sigma_v_x^2/delta_t,2*sigma_v_x^2/delta_t^2];
Boat_update.P_y_pred=[sigma_v_y^2,sigma_v_y^2/delta_t;sigma_v_y^2/delta_t,2*sigma_v_y^2/delta_t^2];
Boat_update.P_y_est=[sigma_v_y^2,sigma_v_y^2/delta_t;sigma_v_y^2/delta_t,2*sigma_v_y^2/delta_t^2];
Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=Boat_update;
Algorithm_out=Algorithm_in;

end

