function Algorithm_out=time_synchronisation(Algorithm_in)
data=Algorithm_in.Data;
toa_mes_tabl=data.toa;
time_slot_tabl=toa_mes_tabl;
for i=1:length(toa_mes_tabl(:,1))
    ligne_toa=toa_mes_tabl(i,:);
    ligne_t_s=toa_mes_tabl(i,:);
    for j=1:length(ligne_toa)
        ligne_t_s(j)=round(rem(ligne_toa(j),60)/0.0266667);
    end
    time_slot_tabl(i,:)=ligne_t_s;
end
time_slot_comp=time_slot_tabl(:,1); %time slot computed

slot_number_mes=data.slot_number(1,:);
% Computation of the difference between the TS presented in messages and the
% TS computed
indice=0;
for i=1:length(slot_number_mes)
    if slot_number_mes(i)~=-1 && indice<1
        dec=rem(slot_number_mes(i)-time_slot_comp(i)+2250,2250);
        indice=indice+1;
    end
end
Algorithm_out=Algorithm_in;
Algorithm_out.dec=dec;
end
