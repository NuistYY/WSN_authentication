function Tampering_m()  %对嵌入后水印的数据进行篡改。
a=fopen('em.txt','r+');
z=fopen('tam30.txt','w');
i=1;
flag=0;
m=30;
min=m/2;
max=m*3/2;
while(~feof(a))
   b=fgetl(a);
   F_2(i)=str2double(b);        %三位小数
   F(i)=floor(F_2(i)*100)/100;            %两位小数
   h = md5(num2str(F(i)));      %取hash用2位，判断用三位
   %c(i)=hex2dec(h(1:12));
   if ((mod(hex2dec(h),m)==0 && (flag==0)&& i>min)||(i>max&&flag==0))
      for t=1:i
        fprintf(z,'%.3f\n',100*(F_2(t))/100);
      end
      flag=1;
      i=0;
   elseif (((mod(hex2dec(h),m)==0) && (flag==1)&& i>min) && (rem(F_2(i)*1000,10)~=9)||(i>max&&flag==1))
      d=round(rand()*10)+1;
      p=rand();
      F_2(d)=F_2(d)+p;       % 篡改数据，对生成组第d个数据进行加篡改，篡改随机。
      for t=1:i
        fprintf(z,'%.3f\n',100*(F_2(t))/100);
      end
      flag=0;
      i=0;
   end
   i=i+1;
end
fclose(a);
fclose(z);
end