function Algorithm_out=Algorithm_update(Algorithm_in,i,fid4)

Algorithm_in.i=i;
indice=i;
if indice==1
    indice_pres=1;
    indice_last=1;
else
    indice_pres=i;
    indice_last=i-1;
end
toa=Algorithm_in.Data.toa(indice_pres);
toa_last=Algorithm_in.Data.toa(indice_last);
% Synchronisation of the toa to the minute UTC
Algorithm_in.toa_recal_pres=synch_tps_frame(toa,Algorithm_in.dec);

% Test to know if we do not received messages during several frames
if (abs(toa_last-toa)>60)
    nb_frame=fix(abs(toa_last-toa)/60);
    if (Algorithm_in.toa_recal_pres-Algorithm_in.toa_recal_past<0)
        nb_frame=nb_frame+1;
    end
    % boats update
    Algorithm_in=data_update(Algorithm_in,fid4,nb_frame);
% Test to know if we start a new frame
elseif (Algorithm_in.toa_recal_pres-Algorithm_in.toa_recal_past<0) && (toa_last-toa<0)
    % boats update
    nb_frame=1;
    Algorithm_in=data_update(Algorithm_in,fid4,nb_frame);
end
Algorithm_in.toa_recal_past=Algorithm_in.toa_recal_pres;

% TS computation
Algorithm_in.TS=compute_TS(Algorithm_in);

Algorithm_out=Algorithm_in;
end