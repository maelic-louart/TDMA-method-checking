function list=define_accuracy(TS,accuracy)
list=[rem(TS+2250-accuracy,2250),TS,rem(TS+2250+accuracy,2250)];
if any(list==0)
    idx=find(list==0);
    list(idx)=2250;
end
end