%QPSK
close all;
clear all;
k=2;  %QPSK
Es=1;   %QPSK
Nsim=10000;
tem=0;

EsNoVec=0:1:15;
average=zeros(1,length(EsNoVec));
for EsNodB=0:1:15
    tem=tem+1;
    er=0;
for ksim=1:Nsim
    k=2;
L=100;
size=k*L;      %QPSK
%MODULATION
X=randi([0,1],1,size);

S=[];
for i=1:2:size          %QPSK
    if(X(i)==1 && X(i+1)==1)
        y=cosd(45)+1j*sind(45);
    elseif(X(i)==0 && X(i+1)==1)
        y=cosd(135)+1j*sind(135);
    elseif(X(i)==1 && X(i+1)==0)
        y=cosd(-45)+1j*sind(-45);
    elseif(X(i)==0 && X(i+1)==0)
        y=cosd(-135)+1j*sind(-135);
    
    
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


%scatterplot(r);
%hold on;
%plot(S);

%hold off;


%Minimum-distance detection

trans=[cosd(45)+1j*sind(45);cosd(135)+1j*sind(135);cosd(-45)+1j*sind(-45);cosd(-135)+1j*sind(-135)];
distance=zeros(1,4);
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
UUB(temp)=2*qfunc(1.412/(2*sigma))+qfunc(1/sigma);
end
semilogy(EsNoVec,average,'bo:','linewidth',2,'markerfacecolor','b');
hold on; 
semilogy(EsNoVec2,UUB,'r','linewidth',2); 
legend('Simulatation','Theory');
title('Symbol Error Probability Evaluation for QPSK Modulation');
    ylabel('Probability of Symbol Error'); xlabel('E_s/N_0 in dB'); grid 
