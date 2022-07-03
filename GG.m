function AAA = GG(AAA,BBB,CCC,DDD,M,S,T,m,n) 
% AAA = circshift((AAA+(BBB&DDD)|(CCC&~DDD)+M+T),[0 -1*S])+BBB; 
for i = 1:32 
    AAA_num(i) = str2num(AAA(i)); 
    BBB_num(i) = str2num(BBB(i)); 
    CCC_num(i) = str2num(CCC(i)); 
    DDD_num(i) = str2num(DDD(i)); 
end 
for i = 1:32 
    U_num(i) = (BBB_num(i)&DDD_num(i))|(CCC_num(i)&~DDD_num(i)); 
end 
for i = 1:32 
    U(i) = num2str(U_num(i)); 
end 
AAA_dec = bin2dec(AAA); 
BBB_dec = bin2dec(BBB); 
CCC_dec = bin2dec(CCC); 
DDD_dec = bin2dec(DDD); 
M_dec = bin2dec(M(m,:)); 
T_dec = bin2dec(T(n,:)); 
U_dec = bin2dec(U); 
V_dec = AAA_dec + U_dec + M_dec + T_dec; 
V = dec2bin(V_dec,32); 
l = length(V); 
if l>32 
    V = V(l-31:l); 
end 
W = circshift(V,[0 -1*S]); 
W_dec = bin2dec(W); 
AAA_dec = W_dec + BBB_dec; 
AAA = dec2bin(AAA_dec,32); 
le = length(AAA); 
if le>32 
    AAA = AAA(le-31:le); 
end 
end 