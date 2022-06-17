function res=compute_TS(Algorithm_in)
toa_recal_pres=Algorithm_in.toa_recal_pres;
TS=rem(round(toa_recal_pres/0.0266667),2250);
TS1=floor(rem(toa_recal_pres/0.0266667,2250));
res=TS;
end
