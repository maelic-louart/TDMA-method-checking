
function Algorithm_AIS_out=data_update(Algorithm_AIS_in,fid4)
Algorithm_AIS_out=Algorithm_AIS_in;

% Frame update on channel A and B
Algorithm_AIS_out.Frame_past_A=Algorithm_AIS_in.Frame_pres_A;
Algorithm_AIS_out.Frame_pres_A.TS=Algorithm_AIS_in.Frame_next_A.TS(1:2250);
Algorithm_AIS_out.Frame_pres_A.mmsi=Algorithm_AIS_in.Frame_next_A.mmsi(1:2250);
Algorithm_AIS_out.Frame_pres_A.slot_timeout=Algorithm_AIS_in.Frame_next_A.slot_timeout(1:2250);
Algorithm_AIS_out.Frame_pres_A.id=Algorithm_AIS_in.Frame_next_A.id(1:2250);
Algorithm_AIS_out.Frame_next_A.TS(1:2250*6)=Algorithm_AIS_in.Frame_next_A.TS(2251:7*2250);
Algorithm_AIS_out.Frame_next_A.mmsi(1:2250*6)=Algorithm_AIS_in.Frame_next_A.mmsi(2251:7*2250);
Algorithm_AIS_out.Frame_next_A.slot_timeout(1:2250*6)=Algorithm_AIS_in.Frame_next_A.slot_timeout(2251:7*2250);
Algorithm_AIS_out.Frame_next_A.id(1:2250*6)=Algorithm_AIS_in.Frame_next_A.id(2251:7*2250);

Algorithm_AIS_out.Frame_past_B=Algorithm_AIS_in.Frame_pres_B;
Algorithm_AIS_out.Frame_pres_B.TS=Algorithm_AIS_in.Frame_next_B.TS(1:2250);
Algorithm_AIS_out.Frame_pres_B.mmsi=Algorithm_AIS_in.Frame_next_B.mmsi(1:2250);
Algorithm_AIS_out.Frame_pres_B.slot_timeout=Algorithm_AIS_in.Frame_next_B.slot_timeout(1:2250);
Algorithm_AIS_out.Frame_pres_B.id=Algorithm_AIS_in.Frame_next_B.id(1:2250);
Algorithm_AIS_out.Frame_next_B.TS(1:2250*6)=Algorithm_AIS_in.Frame_next_B.TS(2251:7*2250);
Algorithm_AIS_out.Frame_next_B.mmsi(1:2250*6)=Algorithm_AIS_in.Frame_next_B.mmsi(2251:7*2250);
Algorithm_AIS_out.Frame_next_B.slot_timeout(1:2250*6)=Algorithm_AIS_in.Frame_next_B.slot_timeout(2251:7*2250);
Algorithm_AIS_out.Frame_next_B.id(1:2250*6)=Algorithm_AIS_in.Frame_next_B.id(2251:7*2250);

disp("new frame");

fprintf(fid4,"new frame \n");
end