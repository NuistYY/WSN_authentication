function main()  %embed�ļ��������顢Ƕ��ˮӡ�������־λ��
fd= fopen('datas.txt','r');
fid=fopen('em.txt','w');
m=30;
i=1;  %ʹ��i���Ʒ��鳤�ȣ�min��max�ֱ�����鳤����Сֵ�����ֵ��
flag=0;
min=m/2;
max=3*m/2;
while (~feof(fd) )
    s = fgetl( fd );  %����1��      
    S = regexp(s, ' ', 'split') ;  %���տո��ȡ����
    sj(i,:)=S(5:8);
    F(i)=str2double(cell2mat(sj(i,1)));  % md5ֵ������λ������С��λ��ͬ��md5ֵ��Ȼ��ͬ
    hi=md5(num2str(F(i)));   % ����double�͵����ݣ���MD5��֧�����������µ�Double���ݡ�
    bs(i)=hex2dec(hi(1:12));   %ȡһ���̶���������ˮӡ���С��˴���1-12��Ϊ48bit��
    yushu=rem(hex2dec(hi),m);
    if (((yushu==0) && (flag==0)&& i>min)||(i>max&&flag==0))  %����������˴�Ϊ�����顣
        l1=i-1;
        F1=zeros(l1,1);
        for j=1:l1
            F1(j)=F(j);
        end
        wp=bs(1);siba=F1(1);
        for s=2:l1
            wp=bitxor(wp,bs(s));
             siba=round(100*((siba+F1(s))/2))/100;
             siba=str2double(num2str(siba)); %���ƵĴ�����Ϊ�˱���matlab����С������ʱ�����ֵ���֮�����ظ�ע�͡�
        end
        H=dec2bin(wp);
        for t=1:l1
             %���������
             random=floor(rem(rand(1)*10000,10));
             ran=str2double(num2str(random/1000));
             fprintf(fid,'%.3f\n',F1(t)+ran); 
        end
        fprintf(fid,'%.5f\n',F(i));
        flag=1; %flag��1�������������
        i=0;
    elseif (((yushu==0) && (flag==1)&& i>min)||(i>max&&flag==1))  %����������˴�ΪЯ���顣
        l2=i-1;
        F2=zeros(l2,1);
             for j=1:l2
                F2(j)=F(j);
             end
        [MR]= embed(F2,H,siba,l2,m);  %MR��Ϊembed������顣
        for t=1:l2
          fprintf(fid,'%.3f\n',MR(t));
        end
        fprintf(fid,'%.5f\n',F(i));  %F(i)Ϊ��β���ݼ�ͬ���㣬����5λС�����,�����ʵ�����Ĺ۲졣
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
      if (rem(hex2dec(md5(num2str(mm(i)))),mj)==0)  %�������ĳ��������αͬ����
        mm(i)=str2double(num2str(mm(i)))+0.009;  %���һλ����־λ��9���ָ�ʱ��Ϊ�ж���αͬ����ı�־��
        astr=num2str(sba);
        Mbei=num2str(ss(i));
        sba=round((str2double(astr)+str2double(Mbei))/2,2);
        sba=str2double(num2str(sba)); 
      else
       random=floor(rem(rand(1)*10000,9));
       ran= str2double(num2str(random/1000));
       mm(i)=str2double(num2str(mm(i)+ran));  %��ͨ���ݵı�־λΪ������֣�������9����
       astr=num2str(sba);
       Mbei=num2str(ss(i));
       sba=round((str2double(astr)+str2double(Mbei))/2,2);
       sba=str2double(num2str(sba));
      end
    end
    MR=mm;
    end
 