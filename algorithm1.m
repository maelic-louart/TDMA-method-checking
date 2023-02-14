function Algorithm_out=algorithm1(Algorithm_in,fid4,fid1,fid4_json,fid1_json)
if sum(Algorithm_in.Struct_list_boat.list_boat(Algorithm_in.idx_boat).list_nb_r1)==1
    % Kalman filter initialisation
    Algorithm_out=initialisation_Kalman_matrix(Algorithm_in,fid4,fid1);
else
    Algorithm_out=Algorithm_in;
    % We take the index of the loop of the strategy
    j=Algorithm_in.i;
    Struct_list_boat=Algorithm_in.Struct_list_boat;
    boat=Struct_list_boat.list_boat(Algorithm_in.idx_boat);
    % indice of the moving average
    idx_mov_av=Struct_list_boat.idx_mov_av;
    % list of the number of messages received
    list_nb_r1=boat.list_nb_r1;
    toa_last=boat.toa_last;
    mmsi=boat.mmsi;
    nb_error_1_y=boat.nb_error_1_y;
    nb_error_1_x=boat.nb_error_1_x;
    TS_pres=Algorithm_in.TS;
    
    % Data measured
    toa_mes=Algorithm_in.Data.toa(j);
    x_mes=Algorithm_in.Data.x(j);
    y_mes=Algorithm_in.Data.y(j);
    sog_mes=Algorithm_in.Data.sog(j);
    cog_mes=Algorithm_in.Data.cog(j);
    id_mes=Algorithm_in.Data.id(j);
    
%     % position falsifications adding
%     if((j>=1000) &&  (j<=1100))
%         x_mes=x_mes+0.005;
%     end
    
    % Rayon polaire et équatorial
    Re=Algorithm_in.Kalman.Re;
    Rn=Algorithm_in.Kalman.Rn;
    
    % measurement noise and model noise
    R_x=Algorithm_in.Kalman.R_x;
    sigma_v_x=Algorithm_in.Kalman.sigma_v_x;
    R_y=Algorithm_in.Kalman.R_y;
    sigma_v_y=Algorithm_in.Kalman.sigma_v_y;
    
    % The last values estimated by the Kalman filter is considered
    delta_t=toa_mes-toa_last;
    X_y_est=boat.X_y_est;
    X_x_est=boat.X_x_est;
    P_y_est=boat.P_y_est;
    P_x_est=boat.P_x_est;
    
    % Kalman matrices
    F=[1 delta_t ; 0 1 ];
    C=[1 , 0];

    % K_p longitude
    X_x_pred=F*X_x_est;
    Q_x=[delta_t^4/4 , delta_t^3/2 ;delta_t^3/2,delta_t^2]*sigma_v_x^2;
    P_x_pred=F*P_x_est*transpose(F)+Q_x;
    S_x=(R_x+C*P_x_pred*transpose(C));
    
    % K_p latitude
    X_y_pred=F*X_y_est;
    Q_y=[delta_t^4/4 , delta_t^3/2 ;delta_t^3/2,delta_t^2]*sigma_v_y^2;
    P_y_pred=F*P_y_est*transpose(F)+Q_y;
    S_y=(R_y+C*P_y_pred*transpose(C));
    
    % Controlled of the longitude consistency
    H_x=P_x_pred*transpose(C)*inv((R_x+C*P_x_pred*transpose(C)));
    if(x_mes~=181)
        % measurment available
        inno_x=x_mes-C*X_x_pred;
        if (abs(inno_x)<3.29*sqrt(S_x))
            X_x_est=X_x_pred+H_x*inno_x;
            P_x_est=(diag(ones(1,2))-H_x*C)*P_x_pred;
            flag1=1;
            nb_error_1_x=0;
        else
            X_x_est=X_x_pred;
            P_x_est=P_x_pred;
            disp(["Alert1: The distance between longitude prediced in measured is to high, toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'lon_mes',x_mes,'lon_pred = ',X_x_pred(1),'inno_lon = ',inno_x,'threshold = ',3.29*sqrt(S_x)]);
            fprintf(fid4,"Alert1: The distance between longitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f, value = %d \n",[toa_mes;TS_pres;mmsi;x_mes;X_x_pred(1);inno_x;3.29*sqrt(S_x);(inno_x)^2/S_x]);
            fprintf(fid1,"Alert1: The distance between longitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f, value=%d \n",[toa_mes;TS_pres;mmsi;x_mes;X_x_pred(1);inno_x;3.29*sqrt(S_x);(inno_x)^2/S_x]);
            encodedJSON=jsonencode(struct('mmsi',mmsi,'id',id_mes,'lat',y_mes,'lon',x_mes,'sog',sog_mes,'cog',cog_mes,'toa',toa_mes,'kind',1,'value',(inno_x)^2/S_x));
            fprintf(fid1_json, encodedJSON);
            fprintf(fid1_json,",");
            fprintf(fid4_json,encodedJSON);
            fprintf(fid4_json,",");
            nb_error_1_x=nb_error_1_x+1;
            flag1=0;
        end
    else
        inno_x=0;
        X_x_est=X_x_pred;
        P_x_est=P_x_pred;
        fprintf(fid1,"measurment not avaiblable in longitude mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        fprintf(fid4,"measurment not available in longitude mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        flag1=1;
    end
    if(nb_error_1_x>=5)
        X_x_est=[x_mes;0];
        nb_error_1_x=0;
    end

    % Controlled of the latitude consistency
    H_y=P_y_pred*transpose(C)*inv((R_y+C*P_y_pred*transpose(C)));
    if(y_mes~=91)
        % measurment available
        inno_y=y_mes-C*X_y_pred;
        if (abs(inno_y)<3.29*sqrt(S_y))
            X_y_est=X_y_pred+H_y*inno_y;
            P_y_est=(diag(ones(1,2))-H_y*C)*P_y_pred;
            flag2=1;
            nb_error_1_y=0;
        else
            X_y_est=X_y_pred;
            P_y_est=P_y_pred;
            disp(["Alert1: The distance between latitude prediced in measured is to high, toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'lon_mes',y_mes,'lon_pred = ',X_y_pred(1),'inno_lon = ',inno_y,'threshold = ',3.29*sqrt(S_y)]);
            fprintf(fid4,"Alert1: The distance between latitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f, value = %d \n",[toa_mes;TS_pres;mmsi;y_mes;X_y_pred(1);inno_y;3.29*sqrt(S_y);abs(inno_y)^2/(S_y)]);
            fprintf(fid1,"Alert1: The distance between latitude prediced in measured is to high toa=%f, TS=%d ,mmsi=%d, lon_mes=%d, lon_pred=%d, inno_lon=%f, threshold=%f, value=%d \n",[toa_mes;TS_pres;mmsi;y_mes;X_y_pred(1);inno_y;3.29*sqrt(S_y);abs(inno_y)^2/(S_y)]);
            encodedJSON=jsonencode(struct('mmsi',mmsi,'id',id_mes,'lat',y_mes,'lon',y_mes,'sog',sog_mes,'cog',cog_mes,'toa',toa_mes,'kind',1,'value',abs(inno_y)^2/(S_y)));
            fprintf(fid1_json, encodedJSON);
            fprintf(fid1_json,",");
            fprintf(fid4_json,encodedJSON);
            fprintf(fid4_json,",");
            nb_error_1_y=nb_error_1_y+1;
            flag2=0;
        end
    else
        inno_y=0;
        X_y_est=X_y_pred;
        P_y_est=P_y_pred;
        fprintf(fid1,"measurment not avaiblable in latitude mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        fprintf(fid4,"measurment not available in latitude mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        flag2=1;
    end

    if(nb_error_1_y>=5)
        X_y_est=[y_mes;0];
        nb_error_1_y=0;
    end
    
    if(sog_mes<102.3)
        sog_c=sqrt(((X_y_est(2)*Rn*pi/180))^2+(X_x_est(2)*(Re*pi/180)*cos(X_y_est(1)*pi/180))^2)*1.9438;
        if (sog_c==0)
            sigma_sog_est=0;
            S_sog=sigma_sog_est^2+0.3^2;
        else
            variance_sog_y=(Rn^2*X_y_est(2)*pi/180)^2*(P_y_est(2,2)*(pi/180)^2);
            variance_sog_x=((Re*cos(X_y_est(1)*pi/180))^2*(X_x_est(2)*pi/180))^2*P_x_est(2,2)*(pi/180)^2;
            sigma_sog_est=sqrt(variance_sog_y+variance_sog_x)*1.9438/sog_c;
            %     std of velocity measured is 0.3 kt
            S_sog=sigma_sog_est^2+0.3^2;
        end
        threshold_sog=2.4*sqrt(S_sog);
        inno_sog=sog_mes-sog_c;
        if abs(inno_sog)>threshold_sog
            disp(["Alert1: The difference between sog estimated and measured is to high toa=",toa_mes," TS=",TS_pres,"mmsi =",mmsi,'sog_c',sog_c,'sog_mes= ',sog_mes,'inno_sog= ',inno_sog,'threshold= ',2.4*sqrt(S_sog)]);
            fprintf(fid4,"Alert1: The difference between sog estimated and measured is to high toa=%f TS=%d ,mmsi=%d, sog_c=%d, sog_mes=%d, inno_sog=%f, threshold=%f, value=%d  \n",[toa_mes;TS_pres;mmsi;sog_c;sog_mes;inno_sog;2.4*sqrt(S_sog);abs(inno_sog)^2/(S_sog)]);
            fprintf(fid1,"Alert1: The difference between sog estimated and measured is to high toa=%f TS=%d ,mmsi=%d, sog_c=%d, sog_mes=%d, inno_sog=%f, threshold=%f, value=%d \n",[toa_mes;TS_pres;mmsi;sog_c;sog_mes;inno_sog;2.4*sqrt(S_sog);abs(inno_sog)^2/(S_sog)]);
            encodedJSON=jsonencode(struct('mmsi',mmsi,'id',id_mes,'lat',y_mes,'lon',x_mes,'sog',sog_mes,'cog',cog_mes,'toa',toa_mes,'kind',3,'value',(inno_sog)^2/S_sog));
            fprintf(fid1_json, encodedJSON);
            fprintf(fid1_json,",");
            fprintf(fid4_json,encodedJSON);
            fprintf(fid4_json,",");
            flag3=0;
        else
            flag3=1;
        end
    else
        sog_c=sqrt(((X_y_est(2)*Rn*pi/180))^2+(X_x_est(2)*(Re*pi/180)*cos(X_y_est(1)*pi/180))^2)*1.9438;
        variance_sog_y=(Rn^2*X_y_est(2)*pi/180)^2*(P_y_est(2,2)*(pi/180)^2);
        variance_sog_x=((Re*cos(X_y_est(1)*pi/180))^2*(X_x_est(2)*pi/180))^2*P_x_est(2,2)*(pi/180)^2;
        sigma_sog_est=sqrt(variance_sog_y+variance_sog_x)*1.9438/sog_c;
        %     std of velocity measured is 0.3 kt
        S_sog=sigma_sog_est^2+0.3^2;
        inno_sog=0;
        fprintf(fid1,"measurment not avaiblable in sog mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        fprintf(fid4,"measurment not available in sog mmsi=%d, toa=%f \n",[mmsi,toa_mes]);
        flag3=1;
    end
    
    if((flag1==1 && flag2==1) && flag3==1)
        NTR=1;
    else
        NTR=0;
    end
    
    %  We record inno_x and S_x
    Algorithm_out.list_S_x(j)=S_x;
    Algorithm_out.list_inno_x(j)=inno_x;
    
    % we record the X_x_pred and P_x_pred
    boat.X_x_pred=X_x_pred;
    boat.P_x_pred=P_x_pred;
    
    % we record X_x_est and P_x_est
    boat.X_x_est=X_x_est;
    boat.P_x_est=P_x_est;
    
    %  We record inno_y and S_y
    Algorithm_out.list_inno_y(j)=inno_y;
    Algorithm_out.list_S_y(j)=S_y;
    
    % we record the X_y_pred and P_y_pred
    boat.X_y_pred=X_y_pred;
    boat.P_y_pred=P_y_pred;
    
    % we record X_y_est and P_y_est
    boat.X_y_est=X_y_est;
    boat.P_y_est=P_y_est;
    
    %  We record inno_sog and S_sog
    Algorithm_out.list_inno_sog(j)=inno_sog;
    Algorithm_out.list_S_sog(j)=S_sog;
    
    % we record parameters of the algorithm
    boat.NTR=NTR;
    boat.nb_error_1_y=nb_error_1_y;
    boat.nb_error_1_x=nb_error_1_x;
    
    % we increment the number of message received by the boat
    boat.list_nb_r1(idx_mov_av)=list_nb_r1(idx_mov_av)+1;
    
    Algorithm_out.Struct_list_boat.list_boat(Algorithm_out.idx_boat)=boat;
    Algorithm_out.list_delta_t(j)=delta_t;
    
end

end














