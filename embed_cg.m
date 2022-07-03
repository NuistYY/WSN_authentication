function main()  %embed文件包括分组、嵌入水印、增设标志位。
fd= fopen('datas.txt','r');
fid=fopen('em.txt','w');
m=30;
i=1;  %使用i控制分组长度，min和max分别代表组长的最小值和最大值。
flag=0;
min=m/2;
max=3*m/2;
while (~feof(fd) )
    s = fgetl( fd );  %读入1行      
    S = regexp(s, ' ', 'split') ;  %按照空格读取数据
    sj(i,:)=S(5:8);
    F(i)=str2double(cell2mat(sj(i,1)));  % md5值由整数位决定，小数位不同，md5值仍然相同
    hi=md5(num2str(F(i)));   % 对于double型的数据，此MD5仅支持两数及以下的Double数据。
    bs(i)=hex2dec(hi(1:12));   %取一个固定长度用作水印序列。此处用1-12，为48bit。
    yushu=rem(hex2dec(hi),m);
    if (((yushu==0) && (flag==0)&& i>min)||(i>max&&flag==0))  %分组操作，此处为生成组。
        l1=i-1;
        F1=zeros(l1,1);
        for j=1:l1
            F1(j)=F(j);
        end
        wp=bs(1);siba=F1(1);
        for s=2:l1
            wp=bitxor(wp,bs(s));
             siba=round(100*((siba+F1(s))/2))/100;
             siba=str2double(num2str(siba)); %类似的代码是为了避免matlab处理小数精度时而出现的误差。之后不再重复注释。
        end
        H=dec2bin(wp);
        for t=1:l1
             %生成随机数
             random=floor(rem(rand(1)*10000,10));
             ran=str2double(num2str(random/1000));
             fprintf(fid,'%.3f\n',F1(t)+ran); 
        end
        fprintf(fid,'%.5f\n',F(i));
        flag=1; %flag置1，生成组结束，
        i=0;
    elseif (((yushu==0) && (flag==1)&& i>min)||(i>max&&flag==1))  %分组操作，此处为携带组。
        l2=i-1;
        F2=zeros(l2,1);
             for j=1:l2
                F2(j)=F(j);
             end
        [MR]= embed(F2,H,siba,l2,m);  %MR作为embed后的数组。
        for t=1:l2
          fprintf(fid,'%.3f\n',MR(t));
        end
        fprintf(fid,'%.5f\n',F(i));  %F(i)为组尾数据即同步点，按照5位小数输出,方便对实验结果的观察。
        flag=0; 
        i=0;
    end
    i=i+1;
end
fclose(fd);
fclose(fid);
end

  function [MR]=embed(ss,h,sba,long,mj)
    hh=h;
    mm=zeros(long,1);
    for i=1:long
         if(strlength(h)==1)
            h=hh;
         end
    w=LSB(h);
    h=dec2bin(bin2dec(h)/2);
    Pe=str2double(num2str(ss(i)-sba));
    Pb=Pe*100;
    Pb2=Pb*2+str2double(w);
    mm(i)=sba+Pb2/100;
      if (rem(hex2dec(md5(num2str(mm(i)))),mj)==0)  %如果组内某数据满足伪同步点
        mm(i)=str2double(num2str(mm(i)))+0.009;  %最后一位即标志位置9，恢复时作为判定是伪同步点的标志。
        astr=num2str(sba);
        Mbei=num2str(ss(i));
        sba=round((str2double(astr)+str2double(Mbei))/2,2);
        sba=str2double(num2str(sba)); 
      else
       random=floor(rem(rand(1)*10000,9));
       ran= str2double(num2str(random/1000));
       mm(i)=str2double(num2str(mm(i)+ran));  %普通数据的标志位为随机数字（不等于9）。
       astr=num2str(sba);
       Mbei=num2str(ss(i));
       sba=round((str2double(astr)+str2double(Mbei))/2,2);
       sba=str2double(num2str(sba));
      end
    end
    MR=mm;
    end
 