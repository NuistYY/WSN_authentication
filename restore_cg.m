function restore()
ff=fopen('tam30.txt','r');
fcd=fopen('re30.txt','w');
m=30;
i=1;
min=14;
max=46;
flag=0;
tamz=0;  %�����۸ĵ�������
count=0;  %����ȫ����������
while (~feof(ff) )
    k = fgetl( ff );
    F(i)=str2double(k);
    F_2(i)=str2double(q5(k)) ; %ȡ����ǰ��λС���������жϹ�ϣֵ��
    h = md5(num2str(F_2(i)));
    b(i)=hex2dec(h(1:12));
    yushu=rem(hex2dec(h),m);
    if (((yushu==0) && (flag==0)&& i>min &&(rem(F(i)*1000,10)~=9))||(i>max&&flag==0)) %��if�е������Ƕ��ˮӡʱ�������ͬ��
        count=count+1;
        l1=i-1;
        F1=zeros(l1,1);
        for j=1:l1
            F1(j)=F_2(j);
        end
        wp=b(1);siba=F1(1);  %���ˮӡ���кͳ�ʼsiba��
        for s=2:l1
             wp=bitxor(wp,b(s));
             siba=round(100*((siba+F1(s))/2))/100;
             siba=str2double(num2str(siba));
        end
        H=dec2bin(wp);
        for t=1:i
            fprintf(fcd,'%g\n',100*(F_2(t))/100);
        end   %���������ݽ��轫��־λɾ��
        flag=1; %flag��1����ʾ������������´��������Ǹ�Я���顣
        i=0;
    elseif  (((yushu==0) && (flag==1)&& i>min &&(rem(F(i)*1000,10)~=9))||(i>max&&flag==1)) %�˴��������ɸ��αͬ���㡣
        count=count+1;
        l2=i-1;
        F2=zeros(l2,1);
        for j=1:l2
                F2(j)=F_2(j); 
        end
        [Mrr,wrong]= decode(F2,H,siba,l2);  %MR��ΪǶ�������顣
        if(wrong==0)
        for t=1:l2
          fprintf(fcd,'%g\n',100*(Mrr(t))/100); 
        end
          fprintf(fcd,'%g\n',100*(F_2(i))/100);
        flag=0; 
        i=0;
        else%�����쳣���ߴ۸�
            fprintf(fcd,'���� %d ������δ������֤\n',l1);
            tamz=tamz+1;
            F1=F2;
            l1=l2;
            wp=b(1);siba=F1(1);
            for s=2:l1
                 wp=bitxor(wp,b(s));
                 siba=round(100*((siba+F1(s))/2))/100;
                 siba=str2double(num2str(siba));
            end
             H=dec2bin(wp);
             for t=1:i
                 fprintf(fcd,'%g\n',100*(F_2(t))/100);
             end
            flag=1; 
            i=0;
        end
    end
    i=i+1;
end
fprintf(fcd,'���� %d �鱻�۸�\n',tamz);
fprintf(fcd,'������ %d ������\n',count);
fclose(ff);
fclose(fcd);
end

function [Mrr,wrong]=decode(ss,h,sba2,long)
wrong=0;
Mr=zeros(long,1);
wmr=zeros(1,long);
hh=h;
    for i=1:long
        if(strlength(h)==1)
            h=hh;
         end
        pe=str2double(num2str(ss(i)-sba2));
        if (pe<0)
        pe=abs(pe);
        flag=-1;
         else
        flag=1;
        end 
        pea=num2str(pe*100);  
         w=LSB(dec2bin(str2double(pea)));  
         W=LSB(h);                 
         wmr(i)=str2double(w);
         h=dec2bin(bin2dec(h)/2);
         if(w~=W)
             wrong=1;
             break;
         end
    s=ss(i)-floor(str2double(num2str(flag*pe/2*100)))/100-str2double(w)/100;  %floor����������ȡ��
    Mr(i)=str2double(num2str(s));
    astr=num2str(sba2);
    sbei=num2str(s);
    sba2=round((str2double(astr)+str2double(sbei))/2,2); %�ָ�һ�����ݣ�Ȼ������������ȥ��si��(siba)��
    sba2=str2double(num2str(sba2));
    end
Mrr=Mr;
end


