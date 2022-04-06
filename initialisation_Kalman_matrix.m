function Boat_update=initialisation_Kalman_matrix(Algorithm_in)
Boat_update=Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat);
j=Algorithm_in.i;
sigma_v=Algorithm_in.Kalman.sigma_v;

toa_last=Boat_update.toa_last;
last_lat_mes=Boat_update.X_lat_est(1);
last_lon_mes=Boat_update.X_lon_est(1);

toa=Algorithm_in.Data.toa(j);
lat_mes=Algorithm_in.Data.x(j);
lon_mes=Algorithm_in.Data.y(j);
delta_t=toa-toa_last;
lat_speed_mes=(lat_mes-last_lat_mes)/delta_t;
lon_speed_mes=(lon_mes-last_lon_mes)/delta_t;
Boat_update.TS_last=Algorithm_in.TS;
Boat_update.X_lat_pred=[lat_mes;lat_speed_mes];
Boat_update.X_lat_est=[lat_mes;lat_speed_mes];
Boat_update.X_lon_pred=[lon_mes;lon_speed_mes];
Boat_update.X_lon_est=[lon_mes;lon_speed_mes];
Boat_update.P_lat_pred=[sigma_v^2,sigma_v^2/delta_t;sigma_v^2/delta_t,2*sigma_v^2/delta_t^2];
Boat_update.P_lon_pred=[sigma_v^2,sigma_v^2/delta_t;sigma_v^2/delta_t,2*sigma_v^2/delta_t^2];
Boat_update.P_lat_est=[sigma_v^2,sigma_v^2/delta_t;sigma_v^2/delta_t,2*sigma_v^2/delta_t^2];
Boat_update.P_lon_est=[sigma_v^2,sigma_v^2/delta_t;sigma_v^2/delta_t,2*sigma_v^2/delta_t^2];
Boat_update.num_mes=2;
end

