%8-PSK
close all;
clear all;
k=3;  %QPSK
Es=1;   %QPSK
Nsim=10000;
tem=0;
L=100;
alpha=0.3;
size=k*L;  

P=16;
EsNoVec=0:1:15;
average=zeros(1,length(EsNoVec));
for EsNodB=0:1:15
    tem=tem+1;
    er=0;
for ksim=1:Nsim
Es=1;
%QPSK
%MODULATION
X=randi([0,1],1,size);
load srrcFilter_v2.mat;
S=[];
Si=[];
Sq=[];
for i=1:3:size          %QPSK
    if(X(i)==1 && X(i+1)==1 && X(i+2)==0)
        y=cosd(45)+1j*sind(45);
        in=cosd(45);
        qau=sind(45);
    elseif(X(i)==0 && X(i+1)==1  && X(i+2)==1)
        y=cosd(135)+1j*sind(135);
        in=cosd(135);
        qau=sind(135);
    elseif(X(i)==1 && X(i+1)==0  && X(i+2)==1)
        y=cosd(-45)+1j*sind(-45);
        in=cosd(-45);
        qau=sind(-45);
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0)
        y=cosd(-135)+1j*sind(-135);
        in=cosd(-135);
        qau=sind(-135);
    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1)
        y=cosd(0)+1j*sind(0);
        in=cosd(0);
        qau=sind(0);
    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==0)
        y=cosd(90)+1j*sind(90);
        in=cosd(90);
        qau=sind(90);
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==1)
        y=cosd(180)+1j*sind(180);
        in=cosd(180);
        qau=sind(180);
    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==0)
        y=cosd(-90)+1j*sind(-90);
       in=cosd(-90);
        qau=sind(-90);
    end
    S=[S;y];
    Si=[Si;in];
    Sq=[Sq;qau];
end
add=zeros(P-1,1);
Sinew=[];
for i=1:length(Si)
    Sinew=[Sinew;Si(i);add];
end
Sqnew=[];
for i=1:length(Sq)
    Sqnew=[Sqnew;Sq(i);add];
end
 
%  subplot(2,1,1);
% figure(1);
%  plot(Sinew,'o');
%  title('zero inserted Symbol Sequence in inphase Signal');
%  subplot(2,1,2);
%  figure(1);
%  plot(Sqnew,'o');
% title('zero inserted Symbol Sequence in quadrature Signal');


Sin=conv(Sinew,srrcImpulseResponse_alpha03_P16);
Sqn=conv(Sqnew,srrcImpulseResponse_alpha03_P16);
temp=1;
for i=49:length(Sin)-48
    Sinn(temp)=Sin(i);
    Sqnn(temp)=Sqn(i);
    temp=temp+1;
end
       
Snew=Sin+1j*Sqn;



%AWGN
EsNolin=10^(0.1*EsNodB);
sigma2=P*(0.5*Es)/EsNolin;
sigma=sqrt(sigma2);
nl=sigma*randn(1,P*L);
nq=sigma*randn(1,P*L);
n=nl+1j*nq;
n=n.';

%DEMODULATOR

rin=Sinn+nl;
rqn=Sqnn+nq;





Sin2=conv(rin,srrcImpulseResponse_alpha03_P16);
Sqn2=conv(rqn,srrcImpulseResponse_alpha03_P16);
temp=1;
for i=49:length(Sin2)-48
    Sinn2(temp)=Sin2(i);
    Sqnn2(temp)=Sqn2(i);
    temp=temp+1;
end
       

% figure(4);
% eyediagram(Sin2,P);
 
% figure(5);
% plot(Sin2);
temp=1;
for i=1:P:1600
    Sin2new(temp)=Sinn2(i);
    Sqn2new(temp)=Sqnn2(i);
    temp=temp+1;
end
r=Sin2new+1j*Sqn2new;
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
title('Symbol Error Probability Evaluation for 8-PSK Modulation');
    ylabel('Probability of Symbol Error'); xlabel('E_s/N_0 in dB'); grid 
