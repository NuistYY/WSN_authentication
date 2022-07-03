function output = MD5(input_char)
% clear
clc

% 初始化链接变量
a = '67452301';
b = 'efcdab89';
c = '98badcfe';
d = '10325476';
for i = 1:8
    adec(i) = hex2dec(a(i));
    abin(i,:) = dec2bin(adec(i),4);
    bdec(i) = hex2dec(b(i));
    bbin(i,:) = dec2bin(bdec(i),4);
    cdec(i) = hex2dec(c(i));
    cbin(i,:) = dec2bin(cdec(i),4);
    ddec(i) = hex2dec(d(i));
    dbin(i,:) = dec2bin(ddec(i),4);
end
A = reshape(abin',1,32);   %B = reshape(A,m,n)  将矩阵A的元素返回到一个m×n的矩阵B。如果A中没有m×n个元素则返回一个错误。  
B = reshape(bbin',1,32);
C = reshape(cbin',1,32);
D = reshape(dbin',1,32);
AA = A;
BB = B;
CC = C;
DD = D;


% 输入字符,并转化为数字矩阵，matlab中转换方式不一样
char_num = length(input_char);
input_ascii = abs(input_char);
group = ceil((char_num+9)/64);%判断要分的组数  w=ceil(z)函数将输入z中的元素取整，值w为不小于本身的最小整数
for k = 1:group*64
    if k<=char_num
        input_ascii_1(k) = input_ascii(k);
    elseif k==char_num+1
        input_ascii_1(k) = 128;
    elseif k==group*64-7
        input_ascii_1(k) = mod(char_num*8,256);
    elseif k==group*64-6
        input_ascii_1(k) = char_num*8/256;
    else
        input_ascii_1(k) = 0;
    end
end

%开始进行分组处理
for g = 1:group
    k = 1;
    for i = 1:16
        for j = 4:-1:1
            input_change(i,j) = input_ascii_1(64*(g-1)+k);
            k = k + 1;
        end
    end
    input = reshape(dec2bin(input_change',8)',32,16)';

    % 输入字符，转换为数字矩阵，但加密结果不对
    % input_ascii = abs('abc');
    % input_bin = dec2bin(input_ascii,8);
    % input_bin = reshape(input_bin',1,[]);
    % long = length(input_bin);
    % inilong = dec2bin(long,64);
    % for i = 1:64
    %     inilong1(i) = inilong(65-i);
    % end
    % inilong = inilong1;
    % for i = 1:512
    %     if i<=long
    %         input(i) = input_bin(i);
    %     elseif i==long+1
    %         input(i) = '1';
    %     elseif i>=449
    %         input(i) = inilong(i-448);
    %     else
    %         input(i) = '0';
    %     end
    % end
    % 
    % input = reshape(input,32,16);
    % input = input';


    for i = 1:64
        T(i,:) = dec2bin(floor(2^32*abs(sin(i))),32);
    end

    M = input;

    % 对输入作4轮共64次计算
    A = FF(A,B,C,D,M,7,T,1,1);
    D = FF(D,A,B,C,M,12,T,2,2);
    C = FF(C,D,A,B,M,17,T,3,3);
    B = FF(B,C,D,A,M,22,T,4,4);
    A = FF(A,B,C,D,M,7,T,5,5);
    D = FF(D,A,B,C,M,12,T,6,6);
    C = FF(C,D,A,B,M,17,T,7,7);
    B = FF(B,C,D,A,M,22,T,8,8);
    A = FF(A,B,C,D,M,7,T,9,9);
    D = FF(D,A,B,C,M,12,T,10,10);
    C = FF(C,D,A,B,M,17,T,11,11); 
    B = FF(B,C,D,A,M,22,T,12,12);
    A = FF(A,B,C,D,M,7,T,13,13);
    D = FF(D,A,B,C,M,12,T,14,14);
    C = FF(C,D,A,B,M,17,T,15,15);
    B = FF(B,C,D,A,M,22,T,16,16);


    A = GG(A,B,C,D,M,5,T,2,17);
    D = GG(D,A,B,C,M,9,T,7,18);
    C = GG(C,D,A,B,M,14,T,12,19);
    B = GG(B,C,D,A,M,20,T,1,20);
    A = GG(A,B,C,D,M,5,T,6,21);
    D = GG(D,A,B,C,M,9,T,11,22);
    C = GG(C,D,A,B,M,14,T,16,23);
    B = GG(B,C,D,A,M,20,T,5,24);
    A = GG(A,B,C,D,M,5,T,10,25);
    D = GG(D,A,B,C,M,9,T,15,26);
    C = GG(C,D,A,B,M,14,T,4,27);
    B = GG(B,C,D,A,M,20,T,9,28);
    A = GG(A,B,C,D,M,5,T,14,29);
    D = GG(D,A,B,C,M,9,T,3,30);
    C = GG(C,D,A,B,M,14,T,8,31);
    B = GG(B,C,D,A,M,20,T,13,32);


    A = HH(A,B,C,D,M,4,T,6,33);
    D = HH(D,A,B,C,M,11,T,9,34);
    C = HH(C,D,A,B,M,16,T,12,35);
    B = HH(B,C,D,A,M,23,T,15,36);
    A = HH(A,B,C,D,M,4,T,2,37);
    D = HH(D,A,B,C,M,11,T,5,38);
    C = HH(C,D,A,B,M,16,T,8,39);
    B = HH(B,C,D,A,M,23,T,11,40);
    A = HH(A,B,C,D,M,4,T,14,41);
    D = HH(D,A,B,C,M,11,T,1,42);
    C = HH(C,D,A,B,M,16,T,4,43);
    B = HH(B,C,D,A,M,23,T,7,44);
    A = HH(A,B,C,D,M,4,T,10,45);
    D = HH(D,A,B,C,M,11,T,13,46);
    C = HH(C,D,A,B,M,16,T,16,47);
    B = HH(B,C,D,A,M,23,T,3,48);


    A = II(A,B,C,D,M,6,T,1,49);
    D = II(D,A,B,C,M,10,T,8,50);
    C = II(C,D,A,B,M,15,T,15,51);
    B = II(B,C,D,A,M,21,T,6,52);
    A = II(A,B,C,D,M,6,T,13,53);
    D = II(D,A,B,C,M,10,T,4,54);
    C = II(C,D,A,B,M,15,T,11,55);
    B = II(B,C,D,A,M,21,T,2,56);
    A = II(A,B,C,D,M,6,T,9,57);
    D = II(D,A,B,C,M,10,T,16,58);
    C = II(C,D,A,B,M,15,T,7,59);
    B = II(B,C,D,A,M,21,T,14,60);
    A = II(A,B,C,D,M,6,T,5,61);
    D = II(D,A,B,C,M,10,T,12,62);
    C = II(C,D,A,B,M,15,T,3,63);
    B = II(B,C,D,A,M,21,T,10,64);

    % 将最后一轮计算结果与初始值相加，再作级联
    A_dec = bin2dec(A);
    B_dec = bin2dec(B);
    C_dec = bin2dec(C);
    D_dec = bin2dec(D);
    AA_dec = bin2dec(AA);
    BB_dec = bin2dec(BB);
    CC_dec = bin2dec(CC);
    DD_dec = bin2dec(DD);
    A_dec = mod((A_dec + AA_dec),2^32);
    B_dec = mod((B_dec + BB_dec),2^32);
    C_dec = mod((C_dec + CC_dec),2^32);
    D_dec = mod((D_dec + DD_dec),2^32);


    % 按十六进制输出
    if g==group
        output = dec2hex([A_dec;B_dec;C_dec;D_dec],8);
        output = output(:,[7 8 5 6 3 4 1 2])';
        output = output(:)';
    else
        A = dec2bin(A_dec,32);
        B = dec2bin(B_dec,32);
        C = dec2bin(C_dec,32);
        D = dec2bin(D_dec,32);
        AA = A;
        BB = B;
        CC = C;
        DD = D;
    end

end
end






    
    
        
