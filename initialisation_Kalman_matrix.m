function Boat_update=initialisation_Kalman_matrix(Algorithm_in)

Struct_list_boat=Algorithm_in.Struct_list_boat;
% indice of the moving average
idx_mov_av=Struct_list_boat.idx_mov_av;
% boat extraction
Boat_update=Struct_list_boat.list_boat(Algorithm_in.idx_boat);
j=Algorithm_in.i;
sigma_v_x=Algorithm_in.Kalman.sigma_v_x;
sigma_v_y=Algorithm_in.Kalman.sigma_v_y;

toa_last=Boat_update.toa_last;
last_lon_mes=Boat_update.X_lon_est(1);
last_lat_mes=Boat_update.X_lat_est(1);

toa=Algorithm_in.Data.toa(j);
lon_mes=Algorithm_in.Data.x(j);
lat_mes=Algorithm_in.Data.y(j);
delta_t=toa-toa_last;
lon_speed_mes=(lon_mes-last_lon_mes)/delta_t;
lat_speed_mes=(lat_mes-last_lat_mes)/delta_t;
Boat_update.TS_last=Algorithm_in.TS;
Boat_update.X_lon_pred=[lon_mes;lon_speed_mes];
Boat_update.X_lon_est=[lon_mes;lon_speed_mes];
Boat_update.X_lat_pred=[lat_mes;lat_speed_mes];
Boat_update.X_lat_est=[lat_mes;lat_speed_mes];
Boat_update.P_lon_pred=[sigma_v_x^2,sigma_v_x^2/delta_t;sigma_v_x^2/delta_t,2*sigma_v_x^2/delta_t^2];
Boat_update.P_lon_est=[sigma_v_x^2,sigma_v_x^2/delta_t;sigma_v_x^2/delta_t,2*sigma_v_x^2/delta_t^2];
Boat_update.P_lat_pred=[sigma_v_y^2,sigma_v_y^2/delta_t;sigma_v_y^2/delta_t,2*sigma_v_y^2/delta_t^2];
Boat_update.P_lat_est=[sigma_v_y^2,sigma_v_y^2/delta_t;sigma_v_y^2/delta_t,2*sigma_v_y^2/delta_t^2];
Boat_update.list_nb_r(idx_mov_av)=Boat_update.list_nb_r(idx_mov_av)+1;
end

