%8-PSK
close all;
clear all;
k=3;  %QPSK
Es=1;   %QPSK
Nsim=10000;
tem=0;

EsNoVec=0:1:15;
average=zeros(1,length(EsNoVec));
for EsNodB=0:1:15
    tem=tem+1;
    er=0;
for ksim=1:Nsim
    k=3;
L=100;
size=k*L;      %QPSK
%MODULATION
X=randi([0,1],1,size);

S=[];
for i=1:3:size          %QPSK
    if(X(i)==1 && X(i+1)==1 && X(i+2)==0)
        y=cosd(45)+1j*sind(45);
    elseif(X(i)==0 && X(i+1)==1  && X(i+2)==1)
        y=cosd(135)+1j*sind(135);
    elseif(X(i)==1 && X(i+1)==0  && X(i+2)==1)
        y=cosd(-45)+1j*sind(-45);
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0)
        y=cosd(-135)+1j*sind(-135);
        
    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1)
        y=cosd(0)+1j*sind(0);
    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==0)
        y=cosd(90)+1j*sind(90);
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==1)
        y=cosd(180)+1j*sind(180);
    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==0)
        y=cosd(-90)+1j*sind(-90);
       
    end
    S=[S;y];
end


%AWGN

EsNolin=10^(0.1*EsNodB);
sigma2=(0.5*Es)/EsNolin;
sigma=sqrt(sigma2);
nl=sigma*randn(1,L);
nq=sigma*randn(1,L);
n=nl+1j*nq;
n=n.';

%DEMODULATOR

r=S+n;



%plot(S);

%hold off;


%Minimum-distance detection

trans=[cosd(45)+1j*sind(45);cosd(135)+1j*sind(135);cosd(-45)+1j*sind(-45);cosd(-135)+1j*sind(-135);cosd(0)+1j*sind(0);cosd(90)+1j*sind(90);cosd(180)+1j*sind(180);cosd(-90)+1j*sind(-90)];
distance=zeros(1,length(trans));
detect=[];
for i=1:length(r)
    for j=1:length(trans)
        a=(real(r(i))-real(trans(j)))^2;
        b=(imag(r(i))-imag(trans(j)))^2;
        distance(j)=sqrt(a+b);
    end
    temp=trans(find(distance==min(distance)));
    detect=[detect;temp];
end
% temp=1;
% for i=1:L
%  
%     if(real(detect(i))==cosd(45) && imag(detect(i))==sind(45))
%       h(temp:temp+2)=[1 1 0];
%       temp=temp+k;
%     elseif(real(detect(i))==cosd(135) && imag(detect(i))==sind(135))
%         h(temp:temp+2)=[0 1 1];
%         temp=temp+k;
%     elseif(real(detect(i))==cosd(-45) && imag(detect(i))==sind(-45))
%         h(temp:temp+2)=[1 0 1];
%         temp=temp+k;
%     elseif(real(detect(i))==cosd(-135) && imag(detect(i))==sind(-135))
%         h(temp:temp+2)=[0 0 0];
%         temp=temp+k;
%         
%         elseif(real(detect(i))==cosd(0) && imag(detect(i))==sind(0))
%         h(temp:temp+2)=[1 1 1];
%         temp=temp+k;
%     elseif(real(detect(i))==cosd(90) && imag(detect(i))==sind(90))
%         h(temp:temp+2)=[0 1 0];
%         temp=temp+k;
%     elseif(real(detect(i))==cosd(180) && imag(detect(i))==sind(180))
%         h(temp:temp+2)=[0 0 1];
%         temp=temp+k;
%     elseif(real(detect(i))==cosd(-90) && imag(detect(i))==sind(-90))
%         h(temp:temp+2)=[1 0 0];
%         temp=temp+k;
%   
%     end
%         
% end














error=zeros(1,ksim);
for i=1:L
    if(detect(i)~=S(i))
      error(ksim)=error(ksim)+1;  
    end
   
end
 er=er+error(ksim)/L;
end
average(tem)=er/Nsim;
end
%UUB
temp=0;
EsNoVec2=0:0.1:15;
for EsNodB=0:0.1:15
    temp=temp+1;
    
EsNolin=10^(0.1*EsNodB);
sigma2=(0.5*Es)/EsNolin;
sigma=sqrt(sigma2);
UUB(temp)=2*qfunc(1.412/(2.*sigma))+2*qfunc(0.7654/(2.*sigma))+2*qfunc(1.8478/(2.*sigma))+qfunc(1./sigma);
end
semilogy(EsNoVec,average,'bo:','linewidth',2,'markerfacecolor','b');
hold on; 
semilogy(EsNoVec2,UUB,'r','linewidth',2); 
legend('Simulatation','Theory');
title('Symbol Error Probability Evaluation for 8PSK Modulation');
    ylabel('Probability of Symbol Error'); xlabel('E_s/N_0 in dB'); grid 
