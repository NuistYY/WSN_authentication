function Tampering_m()  %��Ƕ���ˮӡ�����ݽ��д۸ġ�
a=fopen('em.txt','r+');
z=fopen('tam30.txt','w');
i=1;
flag=0;
m=30;
min=m/2;
max=m*3/2;
while(~feof(a))
   b=fgetl(a);
   F_2(i)=str2double(b);        %��λС��
   F(i)=floor(F_2(i)*100)/100;            %��λС��
   h = md5(num2str(F(i)));      %ȡhash��2λ���ж�����λ
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
      F_2(d)=F_2(d)+p;       % �۸����ݣ����������d�����ݽ��мӴ۸ģ��۸������
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