function Algorithm_out=data_update(Algorithm_in,fid4,nb_frame)
Algorithm_out=Algorithm_in;
nb_frame_av=Algorithm_in.nb_frame_av;

Struct_list_boat=Algorithm_in.Struct_list_boat;
% indice of the moving average
idx_mov_av=rem(Struct_list_boat.idx_mov_av+nb_frame,nb_frame_av);
if (idx_mov_av==0)
    idx_mov_av=nb_frame_av;
end
Struct_list_boat.idx_mov_av=idx_mov_av;

nb_boat=Struct_list_boat.nb_boat;
for i=1:nb_boat
    boat=Struct_list_boat.list_boat(i);
    if (nb_frame>=nb_frame_av)
        %  We do not received messages during more than nb_frame_av frames (nb_frame_av min)
        % So we initialize every variable
        boat.list_nb_err_21=zeros(1,nb_frame_av);
        boat.list_nb_err_22=zeros(1,nb_frame_av);
        boat.list_nb_err_3=zeros(1,nb_frame_av);
        boat.list_nb_r21=zeros(1,nb_frame_av);
        boat.list_nb_r22=zeros(1,nb_frame_av);
        boat.list_nb_r3=zeros(1,nb_frame_av);
        ListNTS_A=[-1];
        ListNTS_B=[-1];
        boat.ListNTS_A=ListNTS_A;
        boat.ListNTS_B=ListNTS_B;
    else
        for j=1:nb_frame
            idx=rem(idx_mov_av+nb_frame_av+1-j,nb_frame_av);
            if (idx==0)
                idx=nb_frame_av;
            end
            % nb_err_update
            boat.list_nb_err_21(idx)=0;
            boat.list_nb_err_22(idx)=0;
            boat.list_nb_err_3(idx)=0;
            boat.list_nb_r21(idx)=0;
            boat.list_nb_r22(idx)=0;
            boat.list_nb_r3(idx)=0;
            % frame update
            % Channel A
            ListNTS_A=boat.ListNTS_A;
            ListNTS_A=ListNTS_A-2250.*ones(1,length(ListNTS_A));
            idx=find(ListNTS_A>=0);
            % We prevent the list from being null
            if isempty(idx)
                boat.ListNTS_A=[-1];
            else
                boat.ListNTS_A=ListNTS_A(idx);
            end
            % Channel B
            ListNTS_B=boat.ListNTS_B;
            ListNTS_B=ListNTS_B-2250.*ones(1,length(ListNTS_B));
            idx=find(ListNTS_B>=0);
            % We prevent the list from being null
            if isempty(idx)
                boat.ListNTS_B=[-1];
            else
                boat.ListNTS_B=ListNTS_B(idx);
            end
        end
    end
    Struct_list_boat.list_boat(i)=boat;
end
disp("new frame");
fprintf(fid4,"new frame \n");
Algorithm_out.Struct_list_boat=Struct_list_boat;

end