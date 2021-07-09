close all;clear all;
k=3;
L=100;
P=16;
alpha=0.3;
size=k*L;  
EsNoVec=0:1:15;
tem=0;
Nsim=10000;
load srrcFilter_v2.mat;
average=zeros(1,length(EsNoVec));
for EsNodB=0:1:15
    tem=tem+1;
    er=0;
for ksim=1:Nsim
Es=1;
%QPSK
%MODULATION
X=randi([0,1],1,size);

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


Sin=conv(Sinew,srrcImpulseResponse_alpha03_P16);
Sqn=conv(Sqnew,srrcImpulseResponse_alpha03_P16);
tp=1;
for i=49:(length(Sin)-48)
    Sin2(tp)=Sin(i);
    Sqn2(tp)=Sqn(i);
    tp=tp+1;
end
       
Snew=Sin2+1j*Sqn2;
Sin2=Sin2(:);
Sqn2=Sqn2(:);
s_tx_inphase=Sin2;
s_tx_quadphase=Sqn2;

s_tx = s_tx_inphase + 1i*s_tx_quadphase;
Rs = 50e3; % Symbol rate in symbols/sec (arbitrarily set)
Ts = 1/Rs; % Symbol duration in seconds
Lpacket = 100; % Packet length in symbols
P_sampPerSym = 16; % SRRC oversample rate in samples/symbol
Lsamp = Lpacket*P_sampPerSym; % Number of samples in the packet
Fsamp = Rs*P_sampPerSym;  %samples/seconds
Tsamp = 1/Fsamp;
t0 = (0:Lsamp-1)*Tsamp; 
t0 = t0(:); % Packet duration in seconds
fc = 3*Rs; % Carrier frequency in Hz (150 kHz in this case)
cosineSignal =cos(2*pi*fc*t0); % Electromagnetic signals
sineSignal =sin(2*pi*fc*t0); % Electromagnetic signals    
s_tx_RF = sqrt(2)*(s_tx_inphase.*cosineSignal - s_tx_quadphase.*sineSignal);

EsNolin=10^(0.1*EsNodB);
sigma2=P*((0.5*Es)/EsNolin);
sigma=sqrt(sigma2);
    nsig_RF = sigma*randn(P*L,1);
    r_RF =s_tx_RF+nsig_RF;
  
    r_inphase = r_RF.*cosineSignal;
    r_quadphase = r_RF.*sineSignal;
    
    r = r_inphase - 1i*r_quadphase;
   r_inphase=r_inphase(:);
   r_quadphase=r_quadphase(:);
   
rin2=conv(r_inphase,srrcImpulseResponse_alpha03_P16);
rqn2=conv(r_quadphase,srrcImpulseResponse_alpha03_P16);

tp=1;
for i=49:(length(rin2)-48)
    rinnew(tp)=rin2(i);
    rqnnew(tp)=rqn2(i);
    tp=tp+1;
end

% figure(4);
% eyediagram(Sin2,P);
 
% figure(5);
% plot(Sin2);
temp=1;
for i=1:P:1600
    rinnew2(temp)=rinnew(i);
    rqnnew2(temp)=rqnnew(i);
    temp=temp+1;
end
re=rinnew2-1i*rqnnew2;
trans=[cosd(45)+1j*sind(45);cosd(135)+1j*sind(135);cosd(-45)+1j*sind(-45);cosd(-135)+1j*sind(-135);cosd(0)+1j*sind(0);cosd(90)+1j*sind(90);cosd(180)+1j*sind(180);cosd(-90)+1j*sind(-90)];

distance=zeros(1,4);
detect=[];
for i=1:length(re)
    for j=1:length(trans)
        a=(real(re(i))-real(trans(j)))^2;
        b=(imag(re(i))-imag(trans(j)))^2;
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
title('[Radio Frequency]Symbol Error Probability Evaluation for 8-PSK Modulation');
    ylabel('Probability of Symbol Error'); xlabel('E_s/N_0 in dB'); grid 


    
