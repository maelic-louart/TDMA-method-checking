function Algorithm_out=algorithm1(Algorithm_in,fid4,fid1)
if sum(Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat).list_nb_r)==1
    % Kalman filter initialisation
    Algorithm_in=initialisation_Kalman_matrix(Algorithm_in,fid4,fid1);
    Algorithm_out=Algorithm_in;
else
    Algorithm_out=Algorithm_in;
    % We take the index of the loop of the strategy
    j=Algorithm_in.i;
    Struct_list_boat=Algorithm_in.Struct_list_boat;
    boat=Struct_list_boat.list_boat(Algorithm_in.idx_boat);
    % indice of the moving average
    idx_mov_av=Struct_list_boat.idx_mov_av;
    % list of the number of messages received
    list_nb_r=boat.list_nb_r;
    toa_last=boat.toa_last;
    mmsi=boat.mmsi;
    nb_error_1_y=boat.nb_error_1_y;
    nb_error_1_x=boat.nb_error_1_x;
    TS_pres=Algorithm_in.TS;
    
    %     Data measured
    toa_mes=Algorithm_in.Data.toa(j);
    x_mes=Algorithm_in.Data.x(j);
    y_mes=Algorithm_in.Data.y(j);
    sog_mes=Algorithm_in.Data.sog(j);
    
    %    Rayon polaire et équatorial
    Re=Algorithm_in.Kalman.Re;
    Rn=Algorithm_in.Kalman.Rn;
    
    %     measurement noise and model noise
    R_x=Algorithm_in.Kalman.R_x;
    sigma_w_x=Algorithm_in.Kalman.sigma_w_x;
    R_y=Algorithm_in.Kalman.R_y;
    sigma_w_y=Algorithm_in.Kalman.sigma_w_y;
    
    %     The last values estimated by the Kalman filter is considered
    delta_t=toa_mes-toa_last;
    X_x_est=boat.X_x_est;
    P_x_est=boat.P_x_est;
    X_y_est=boat.X_y_est;
    P_y_est=boat.P_y_est;
    
    
    % Kalman matrices
    A=[1 delta_t ; 0 1 ];
    C=[1 , 0];
    
    % LONGITUDE
    if(x_mes~=181)
        % measurment available
        % K_p longitude
        X_x_pred=A*X_x_est;
        Q_x=[delta_t^4/4 , delta_t^3/2 ;delta_t^3/2,delta_t^2]*sigma_w_x^2;
        P_x_pred=A*P_x_est*transpose(A)+Q_x;
        S_x=(R_x+C*P_x_pred*transpose(C));
        
        % Controlled of the longitude consistency
        H_x=P_x_pred*transpose(C)*inv((R_x+C*P_x_pred*transpose(C)));
        inno_x=x_mes-C*X_x_pred;
        if (abs(inno_x)<5*sqrt(S_x))
            X_x_est=X_x_pred+H_x*inno_x;
            P_x_est=(diag(ones(1,2))-H_x*C)*P_x_pred;
            flag2=1;
            nb_error_1_x=0;
        else
            X_x_est=X_x_pred;
            P_x_est=(diag(ones(1,2))-H_x*C)*P_x_pred;
            disp(["Alert1: The distance between longitude prediced in measured is to high, toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'lon_mes',x_mes,'lon_pred = ',X_x_pred(1),'inno_lon = ',inno_x,'threshold = ',5*sqrt(S_x)]);
            fprintf(fid4,"Alert1: The distance between longitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;x_mes;X_x_pred(1);inno_x;5*sqrt(S_x)]);
            fprintf(fid1,"Alert1: The distance between longitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;x_mes;X_x_pred(1);inno_x;5*sqrt(S_x)]);
            flag2=0;
            nb_error_1_x=nb_error_1_x+1;
        end
        if(nb_error_1_x>=5)
            X_x_est(1)=x_mes;
            X_x_est(2)=0;
        end
    else
        fprintf(fid1,"measurment not avaiblable in longitude, mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        fprintf(fid4,"measurment not available in longitude, mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        X_x_pred=X_x_est;
        P_x_pred=P_x_est;
        flag2=1;
    end
    
    % we record the data predicted
    boat.X_x_pred=X_x_pred;
    boat.P_x_pred=P_x_pred;
    % we record the data estimated
    boat.X_x_est=X_x_est;
    boat.P_x_est=P_x_est;
    % we record the number of error
    boat.nb_error_1_x=nb_error_1_x;
    
    % LATITUDE
    if(y_mes~=91)
        % K_p latitude
        X_y_pred=A*X_y_est;
        Q_y=[delta_t^4/4 , delta_t^3/2 ;delta_t^3/2,delta_t^2]*sigma_w_y^2;
        P_y_pred=A*P_y_est*transpose(A)+Q_y;
        S_y=(R_y+C*P_y_pred*transpose(C));
        
        % Controlled of the latitude consistency
        H_y=P_y_pred*transpose(C)*inv((R_y+C*P_y_pred*transpose(C)));
        inno_y=y_mes-C*X_y_pred;
        
        if (abs(inno_y)<5*sqrt(S_y))
            X_y_est=X_y_pred+H_y*inno_y;
            P_y_est=(diag(ones(1,2))-H_y*C)*P_y_pred;
            nb_error_1_y=0;
            flag1=1;
        else
            X_y_est=X_y_pred;
            P_y_est=(diag(ones(1,2))-H_y*C)*P_y_pred;
            disp(["Alert1: The distance between latitude prediced in measured is to high, toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'lat_mes',y_mes,'lat_pred = ',X_y_pred(1),'inno_lat = ',inno_y,'threshold = ',5*sqrt(S_y)]);
            fprintf(fid4,"Alert1: The distance between latitude prediced in measured is to high, toa=%f, TS=%d ,mmsi=%d, lat_mes=%d, lat_pred=%d, inno_lat=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;y_mes;X_y_pred(1);inno_y;5*sqrt(S_y)]);
            fprintf(fid1,"Alert1: The distance between latitude prediced in measured is to high, toa=%f, TS=%d ,mmsi=%d, lat_mes=%d, lat_pred=%d, inno_lat=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;y_mes;X_y_pred(1);inno_y;5*sqrt(S_y)]);
            flag1=0;
            nb_error_1_y=nb_error_1_y+1;
        end
        
        if(nb_error_1_y>=5)
            X_y_est(1)=y_mes;
            X_y_est(2)=0;
        end
    else
        fprintf(fid1,"measurment not avaiblable in latitude, mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        fprintf(fid4,"measurment not available in latitude, mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        X_y_pred=X_y_est;
        P_y_pred=P_y_est;
        flag1=1;
    end
    
    % we record the data predicted
    boat.X_y_pred=X_y_pred;
    boat.P_y_pred=P_y_pred;
    % we record the data estimated
    boat.X_y_est=X_y_est;
    boat.P_y_est=P_y_est;
    % we record the number of error
    boat.nb_error_1_y=nb_error_1_y;
    
    %SOG
    
    if (sog_mes<102.3)
        % sog measurment is available
        sog_c=sqrt(((X_y_est(2)*Rn*pi/180))^2+(X_x_est(2)*(Re*pi/180)*cos(X_y_est(1)*pi/180))^2)*1.9438;
        if (sog_c==0)
            sigma_sog_est=0;
            S_sog=sigma_sog_est^2+0.3^2;
        else
            variance_sog_y=(Rn^2*X_y_est(2)*pi/180)^2*(P_y_est(2,2)*(pi/180)^2);
            variance_sog_x=((Re*cos(X_y_est(1)*pi/180))^2*(X_x_est(2)*pi/180))^2*P_x_est(2,2)*(pi/180)^2;
            sigma_sog_est=sqrt(variance_sog_y+variance_sog_x)*1.9438/sog_c;
            % std of velocity measured is 0.3 kt
            S_sog=sigma_sog_est^2+0.3^2;
        end
        threshold_sog=4*sqrt(S_sog);
        inno_sog=sog_mes-sog_c;
        if abs(inno_sog)>threshold_sog
            disp(["Alert1: The difference between sog estimated and measured is to high toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'sog_c',sog_c,'sog_mes= ',sog_mes,'inno_sog= ',inno_sog,'threshold= ',3*sigma_sog_est+1]);
            fprintf(fid4,"Alert1: The difference between sog estimated and measured is to high toa=%f TS=%d ,mmsi=%d, sog_c=%d, sog_mes=%d, inno_sog=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;sog_c;sog_mes;inno_sog;3*sigma_sog_est+1]);
            fprintf(fid1,"Alert1: The difference between sog estimated and measured is to high toa=%f TS=%d ,mmsi=%d, sog_c=%d, sog_mes=%d, inno_sog=%f, threshold=%f \n",[toa_mes;TS_pres;mmsi;sog_c;sog_mes;inno_sog;3*sigma_sog_est+1]);
            flag3=0;
        else
            flag3=1;
        end
    else
        fprintf(fid1,"measurment not avaiblable in sog mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        fprintf(fid4,"measurment not available in sog mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        flag3=1;
    end
    
    if((flag1==1 && flag2==1) && flag3==1)
        NTR=1;
    else
        NTR=0;
    end

    % we record parameters of the algorithm
    boat.NTR=NTR;
    
    % we increment the number of message received by the boat
    boat.list_nb_r(idx_mov_av)=list_nb_r(idx_mov_av)+1;
    
    Algorithm_out.Struct_list_boat.list_boat(Algorithm_out.idx_boat)=boat;
    Algorithm_out.list_delta_t(j)=delta_t;
    
end

end














