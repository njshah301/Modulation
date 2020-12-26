k=2;
L=100;
P=16;
alpha=0.3;
size=k*L;  
EsNoVec=0:1:15;
tem=0;
Nsim=10000;
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
for i=1:2:size          %QPSK
    if(X(i)==1 && X(i+1)==1)
        y=cosd(45)+1j*sind(45);
        in=cosd(45);
        qau=sind(45);
    elseif(X(i)==0 && X(i+1)==1)
        y=cosd(135)+1j*sind(135);
          in=cosd(135);
        qau=sind(135);
    elseif(X(i)==1 && X(i+1)==0)
        y=cosd(-45)+1j*sind(-45);
          in=cosd(-45);
        qau=sind(-45);
    elseif(X(i)==0 && X(i+1)==0)
        y=cosd(-135)+1j*sind(-135);
          in=cosd(-135);
        qau=sind(-135);
    
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
% figure(1);
% plot(Sinew,'o');
% figure(2);
% plot(Sqnew,'o');

Sin=conv(Sinew,srrcImpulseResponse_alpha03_P16);
Sqn=conv(Sqnew,srrcImpulseResponse_alpha03_P16);
tp=1;
for i=49:(length(Sin)-48)
    Sin2(tp)=Sin(i);
    Sqn2(tp)=Sqn(i);
    tp=tp+1;
end
       
Snew=Sin2+1j*Sqn2;








% figure(3);
% eyediagram(Sin,P,4);


%AWGN
EsNolin=10^(0.1*EsNodB);
sigma2=P*((0.5*Es)/EsNolin);
sigma=sqrt(sigma2);
nl=sigma*randn(1,P*L);
nq=sigma*randn(1,P*L);
n=nl+1j*nq;
n=n.';

%DEMODULATOR

rin=Sin2+nl;
rqn=Sqn2+nq;




rin2=conv(rin,srrcImpulseResponse_alpha03_P16);
rqn2=conv(rqn,srrcImpulseResponse_alpha03_P16);

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
for i=1:L
if(rinnew2(i)>0 && rqnnew2(i)>0)
    Sdec(i)=cosd(45)+1j*sind(45);
elseif(rinnew2(i)<0 && rqnnew2(i)>0)
    Sdec(i)=cosd(135)+1j*sind(135);
   
elseif(rinnew2(i)>0 && rqnnew2(i)<0)
    Sdec(i)=cosd(-45)+1j*sind(-45);
    
elseif(rinnew2(i)<0 && rqnnew2(i)<0)
    Sdec(i)=cosd(-135)+1j*sind(-135);
end
end
error=zeros(1,ksim);
for i=1:L
    if(Sdec(i)~=S(i))
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
title('[Realistic Modem Simulator]Symbol Error Probability Evaluation for QPSK Modulation');
    ylabel('Probability of Symbol Error'); xlabel('E_s/N_0 in dB'); grid 
