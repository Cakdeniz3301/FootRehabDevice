clear all
clc
close all

seans=input('kaçýncý seans olduðunu giriniz: ');
sure=input('seans süresini giriniz (dk cinsinden): ');
yon=input('yonu giriniz: ');  %"pfdf", "ivev"
grade=input('direnc degeri giriniz: ');

ports = seriallist
s = serialport(ports(1), 9600);

disp("...... connected")
% figure(1)
% clf
% verbose =     1;
fs = 15;

lengthOfTotal = fs * sure * 60;
timeDiv = 0:1/fs:(sure * 60)-1/fs;

data = zeros(lengthOfTotal,7);
tic
for i=1:1:lengthOfTotal
%     str = readline(s);
%     newStr=strsplit(str);
%     newStr=newStr(1);
%     newStr2 = split(newStr,",");
%     data(i,:)=str2double(newStr2);
    str = readline(s);
    newStr = split(str,",");
    if length(newStr)==7
        data(i,:)=str2double(newStr);
    end
%     if verbose>0
%         plot(data(1:i,1))
%         hold on
%         plot(data(1:i,2),'r')
%         hold on
%         plot(data(1:i,3),'g')
%         hold on
%         plot(data(1:i,4),'g')
%         hold on
%         plot(data(1:i,5),'g')
%         hold on
%         plot(data(1:i,6),'g')
%         hold on
%         plot(data(1:i,7),'g')
%         hold on
%         pause(0.01)
%     end
end
toc
figure(1);
% clf
subplot(3,1,1)
plot(timeDiv,data(:,1),'b') % normal pozisyonda:  önden basýnca yukarý arkadan basýnca aþaðý
% yan çevrimde saða bastýrýnca artma sola bastýrýnca azalma
title("Ön Arka")
subplot(3,1,2)
plot(timeDiv,data(:,2),'r') % normal pozisyonda: arkadan basýnca yukarý önden basýnca aþaðý
%yan çevrimde: 0 deðiþim
title("Sað Sol")
subplot(3,1,3)
plot(timeDiv,data(:,3),'g') % normal pozisyonda: 0 deðiþim
%yan çevrimde saða bastýrýnca artma, sola bastýrýnca azalma
title("Yukarý Aþaðý")

figure(2)
subplot(4,1,1)
plot(timeDiv,data(:,4),'k') % ARKA
title("Arka Kuvvet")
subplot(4,1,2)
plot(timeDiv,data(:,5),'m') % SAÐ
title("Sað Kuvvet")
subplot(4,1,3)
plot(timeDiv,data(:,6),'r') % SOL
title("Sol Kuvvet")
subplot(4,1,4)
plot(timeDiv,data(:,7),'b') % ÖN 
title("Ön Kuvvet")


FileName=[num2str(seans) num2str(yon) num2str(grade)]

save(FileName)