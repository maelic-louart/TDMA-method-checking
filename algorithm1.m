function Algorithm_out=algorithm1(Algorithm_in,fid4,fid1)
if sum(Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat).list_nb_r)==1
    % Kalman filter initialisation
    Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat)=initialisation_Kalman_matrix(Algorithm_in);
    Algorithm_out=Algorithm_in;
else
    Algorithm_out=Algorithm_in;
    % We take the index of the loop of the final algorithm
    j=Algorithm_in.i;
    Struct_list_boat=Algorithm_in.Struct_list_boat;
    boat=Struct_list_boat.list_boat(Algorithm_in.idx_boat);
    % indice of the moving average
    idx_mov_av=Struct_list_boat.idx_mov_av;
    % list of the number of messages received
    list_nb_r=boat.list_nb_r;
    toa_last=boat.toa_last;
    mmsi=boat.mmsi;
    nb_error_1_lat=boat.nb_error_1_lat;
    nb_error_1_lon=boat.nb_error_1_lon;
    TS_pres=Algorithm_in.TS;
    
    %     Data measured
    toa_mes=Algorithm_in.Data.toa(j);
    lon_mes=Algorithm_in.Data.x(j);
    lat_mes=Algorithm_in.Data.y(j);
    sog_mes=Algorithm_in.Data.sog(j);
    
    %    Rayon polaire et équatorial
    Re=Algorithm_in.Kalman.Re;
    Rn=Algorithm_in.Kalman.Rn;
    
    %     measurement noise and model noise
    R_x=Algorithm_in.Kalman.R_x;
    sigma_w_lon=Algorithm_in.Kalman.sigma_w_x;
    R_y=Algorithm_in.Kalman.R_y;
    sigma_w_lat=Algorithm_in.Kalman.sigma_w_y;
    
    %     The last values estimated by the Kalman filter is considered
    delta_t=toa_mes-toa_last;
    X_lat_est=boat.X_lat_est;
    X_lon_est=boat.X_lon_est;
    P_lat_est=boat.P_lat_est;
    P_lon_est=boat.P_lon_est;
    
    %     Kalman matrices
    A=[1 delta_t ; 0 1 ];
    C=[1 , 0];

%     K_p longitude
    X_lon_pred=A*X_lon_est;
    Q_lon=[delta_t^4/4 , delta_t^3/2 ;delta_t^3/2,delta_t^2]*sigma_w_lon^2;
    P_lon_pred=A*P_lon_est*transpose(A)+Q_lon;
    S_lon=(R_x+C*P_lon_pred*transpose(C));
    
%     K_p latitude
    X_lat_pred=A*X_lat_est;
    Q_lat=[delta_t^4/4 , delta_t^3/2 ;delta_t^3/2,delta_t^2]*sigma_w_lat^2;
    P_lat_pred=A*P_lat_est*transpose(A)+Q_lat;
    S_lat=(R_y+C*P_lat_pred*transpose(C));
    
%     Controlled of the longitude consistency
    H_lon=P_lon_pred*transpose(C)*inv((R_x+C*P_lon_pred*transpose(C)));
    inno_lon=lon_mes-C*X_lon_pred;
    if (abs(inno_lon)<5*sqrt(S_lon))
        X_lon_est=X_lon_pred+H_lon*inno_lon;
        P_lon_est=(diag(ones(1,2))-H_lon*C)*P_lon_pred;
        flag2=1;
        nb_error_1_lon=0;
    else
        X_lon_est=X_lon_pred;
        P_lon_est=(diag(ones(1,2))-H_lon*C)*P_lon_pred;
        disp(["Alert1: The distance between longitude prediced in measured is to high, toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'lon_mes',lon_mes,'lon_pred = ',X_lon_pred(1),'inno_lon = ',inno_lon,'threshold = ',5*sqrt(S_lon)]);
        fprintf(fid4,"Alert1: The distance between longitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;lon_mes;X_lon_pred(1);inno_lon;5*sqrt(S_lon)]);
        fprintf(fid1,"Alert1: The distance between longitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;lon_mes;X_lon_pred(1);inno_lon;5*sqrt(S_lon)]);
        flag2=0;
        nb_error_1_lon=nb_error_1_lon+1;
    end

%     Controlled of the latitude consistency
    H_lat=P_lat_pred*transpose(C)*inv((R_y+C*P_lat_pred*transpose(C)));
    inno_lat=lat_mes-C*X_lat_pred;
    
    if (abs(inno_lat)<5*sqrt(S_lat))
        X_lat_est=X_lat_pred+H_lat*inno_lat;
        P_lat_est=(diag(ones(1,2))-H_lat*C)*P_lat_pred;
        flag1=1;
    else
        X_lat_est=X_lat_pred;
        P_lat_est=(diag(ones(1,2))-H_lat*C)*P_lat_pred;
        disp(["Alert1: The distance between latitude prediced in measured is to high, toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'lat_mes',lat_mes,'lat_pred = ',X_lat_pred(1),'inno_lat = ',inno_lat,'threshold = ',5*sqrt(S_lat)]);
        fprintf(fid4,"Alert1: The distance between latitude prediced in measured is to high, toa=%f, TS=%d ,mmsi=%d, lat_mes=%d, lat_pred=%d, inno_lat=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;lat_mes;X_lat_pred(1);inno_lat;5*sqrt(S_lat)]);
        fprintf(fid1,"Alert1: The distance between latitude prediced in measured is to high, toa=%f, TS=%d ,mmsi=%d, lat_mes=%d, lat_pred=%d, inno_lat=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;lat_mes;X_lat_pred(1);inno_lat;5*sqrt(S_lat)]);
        flag1=0;
        nb_error_1_lat=nb_error_1_lat+1;
    end
    
    if(nb_error_1_lon>=5)
        X_lon_est(1)=lon_mes;
    end
    if(nb_error_1_lat>=5)
        X_lat_est(1)=lat_mes;
    end
    
    sog_c=sqrt(((X_lat_est(2)*Rn*pi/180))^2+(X_lon_est(2)*(Re*pi/180)*cos(X_lat_est(1)*pi/180))^2)*1.9438;
    if (sog_c==0)
        sigma_sog_est=0;
        S_sog=sigma_sog_est^2+0.3^2;
    else
        variance_sog_lat=(Rn^2*X_lat_est(2)*pi/180)^2*(P_lat_est(2,2)*(pi/180)^2);
        variance_sog_lon=(Re^2*(cos(X_lat_est(1)*pi/180))^2*X_lon_est(2)*pi/180)^2*P_lon_est(2,2)*(pi/180)^2;
        sigma_sog_est=sqrt(variance_sog_lat+variance_sog_lon)*1.9438/sog_c;
        %     std of velocity measured is 0.3 kt
        S_sog=sigma_sog_est^2+0.3^2;
    end
    threshold_sog=5*sqrt(S_sog);
    inno_sog=sog_mes-sog_c;
    if abs(inno_sog)>threshold_sog
        disp(["Alert1: The difference between sog estimated and measured is to high toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'sog_c',sog_c,'sog_mes= ',sog_mes,'inno_sog= ',inno_sog,'threshold= ',3*sigma_sog_est+1]);
        fprintf(fid4,"Alert1: The difference between sog estimated and measured is to high toa=%f TS=%d ,mmsi=%d, sog_c=%d, sog_mes=%d, inno_sog=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;sog_c;sog_mes;inno_sog;3*sigma_sog_est+1]);
        fprintf(fid1,"Alert1: The difference between sog estimated and measured is to high toa=%f TS=%d ,mmsi=%d, sog_c=%d, sog_mes=%d, inno_sog=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;sog_c;sog_mes;inno_sog;3*sigma_sog_est+1]);
        flag3=0;
    else
        flag3=1;
    end
    
    if((flag1==1 && flag2==1) && flag3==1)
        NTR=1;
    else
        NTR=0;
    end
    
    %  We recorde inno_lon and S_lon
    Algorithm_out.list_inno_lon(j)=inno_lon;
    Algorithm_out.list_S_lon(j)=S_lon;

    %  We recorde inno_lat and S_lat
    Algorithm_out.list_inno_lat(j)=inno_lat;
    Algorithm_out.list_S_lat(j)=S_lat;
    
    %  We recorde inno_sog and S_sog
    Algorithm_out.list_inno_sog(j)=inno_sog;
    Algorithm_out.list_S_sog(j)=S_sog;
    
    % we recorde the data predicted in Algorithm_out
    boat.X_lon_pred=X_lon_pred;
    boat.P_lon_pred=P_lon_pred;

    boat.X_lat_pred=X_lat_pred;
    boat.P_lat_pred=P_lat_pred;
    
    % we recorde the data estimated in Algorithm_out
    boat.X_lon_est=X_lon_est;
    boat.P_lon_est=P_lon_est;

    boat.X_lat_est=X_lat_est;
    boat.P_lat_est=P_lat_est;
    
    % we recorde parameters of the algorithm
    boat.NTR=NTR;
    boat.nb_error_1_lon=nb_error_1_lon;
    boat.nb_error_1_lat=nb_error_1_lat;
    
    % we increment the number of message received by the boat
    boat.list_nb_r(idx_mov_av)=list_nb_r(idx_mov_av)+1;
    
    
    Algorithm_out.Struct_list_boat.list_boat(Algorithm_out.idx_boat)=boat;
    Algorithm_out.list_delta_t(j)=delta_t;
    
end

end














