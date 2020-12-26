%8-PSK
close all;
clear all;
k=5;  %QPSK
Es=20;   %QPSK
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
Es=20;
%QPSK
%MODULATION
X=randi([0,1],1,size);
load srrcFilter.mat;
S=[];
Si=[];
Sq=[];


trans=[complex(-5,1);complex(-3,1);complex(-1,1);complex(1,1);complex(3,1);complex(5,1);complex(-5,3);complex(-3,3);complex(-1,3);complex(1,3);complex(3,3);complex(5,3);complex(-3,5);complex(-1,5);complex(1,5);complex(3,5);complex(-5,-1);complex(-3,-1);complex(-1,-1);complex(1,-1);complex(3,-1);complex(5,-1);complex(-5,-3);complex(-3,-3);complex(-1,-3);complex(1,-3);complex(3,-3);complex(5,-3);complex(-3,-5);complex(-1,-5);complex(1,-5);complex(3,-5)];

for i=1:k:size          %QPSK
    if(X(i)==0 && X(i+1)==1 && X(i+2)==0  && X(i+3)==1  && X(i+4)==0)
        y=trans(1);
        in=-5;
        qau=1;
    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==0  && X(i+3)==1  && X(i+4)==0)
       y=trans(2);
        in=-3;
        qau=1;
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==1  && X(i+3)==1  && X(i+4)==0)
        y=trans(3);
        in=-1;
        qau=1;
    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==1  && X(i+3)==1  && X(i+4)==0)
       y=trans(4);
       in=1;
        qau=1;

        
    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==1  && X(i+3)==1  && X(i+4)==0)
        y=trans(5);
        in=3;
        qau=1;

    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1  && X(i+3)==1  && X(i+4)==0)
        y=trans(6);
        in=5;
        qau=1;

        
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==1  && X(i+3)==0  && X(i+4)==0)
       y=trans(7);
       in=-5;
        qau=3;

    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==1  && X(i+3)==0  && X(i+4)==0)
        y=trans(8);
         in=-3;
        qau=3;

    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==1  && X(i+3)==0  && X(i+4)==0)
        y=trans(9);
         in=-1;
        qau=3;

    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1  && X(i+3)==0  && X(i+4)==0)
        y=trans(10);
         in=1;
        qau=3;

    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0  && X(i+3)==1  && X(i+4)==0)
        y=trans(11);
         in=3;
        qau=3;

    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==0  && X(i+3)==1  && X(i+4)==0)
        y=trans(12);
         in=5;
        qau=3;

        
        
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0  && X(i+3)==0  && X(i+4)==0)
        y=trans(13);
         in=-3;
        qau=5;

    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==0  && X(i+3)==0  && X(i+4)==0)
        y=trans(14);
         in=-1;
        qau=5;

    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==0  && X(i+3)==0  && X(i+4)==0)
      y=trans(15);
       in=1;
        qau=5;

    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==0  && X(i+3)==0  && X(i+4)==0)
        y=trans(16);
         in=3;
        qau=5;
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0  && X(i+3)==0  && X(i+4)==1)
        y=trans(17);
         in=-5;
        qau=-1;

    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==0  && X(i+3)==0  && X(i+4)==1)
        y=trans(18);
          in=-3;
        qau=-1;

    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==0  && X(i+3)==0  && X(i+4)==1)
        y=trans(19);
         in=-1;
        qau=-1;

    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==0  && X(i+3)==0  && X(i+4)==1)
        y=trans(20);
         in=1;
        qau=-1;
        
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==1  && X(i+3)==0  && X(i+4)==1)
        y=trans(21);
        in=3;
        qau=-1;

    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==1  && X(i+3)==0  && X(i+4)==1)
        y=trans(22);
        in=5;
        qau=-1;

        
    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==1  && X(i+3)==0  && X(i+4)==1)
        y=trans(23);
        in=-5;
        qau=-3;

    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1  && X(i+3)==0  && X(i+4)==1)
       y=trans(24);
         in=-3;
        qau=-3;

    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0  && X(i+3)==1  && X(i+4)==1)
        y=trans(25);
         in=-1;
        qau=-3;

    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==0  && X(i+3)==1  && X(i+4)==1)
        y=trans(26);
        in=1;
        qau=-3;

    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==0  && X(i+3)==1  && X(i+4)==1)
        y=trans(27);
        in=3;
        qau=-3;

    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==0  && X(i+3)==1  && X(i+4)==1)
        y=trans(28);
         in=5;
        qau=-3;

     
        
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==1  && X(i+3)==1  && X(i+4)==1)
        y=trans(29);
          in=-3;
        qau=-5;

    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==1  && X(i+3)==1  && X(i+4)==1)
        y=trans(30);
         in=-1;
        qau=-5;

    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==1  && X(i+3)==1  && X(i+4)==1)
        y=trans(31);
        in=1;
        qau=-5;

    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1  && X(i+3)==1  && X(i+4)==1)
        y=trans(32);
         in=3;
        qau=-5;
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

       
Snew=Sin+1j*Sqn;



%AWGN
EsNolin=10^(0.1*EsNodB);
sigma2=P*(0.5*Es)/EsNolin;
sigma=sqrt(sigma2);
nl=sigma*randn(1,P*L+96);
nq=sigma*randn(1,P*L+96);
n=nl+1j*nq;
n=n.';

%DEMODULATOR
Sin=Sin.';
Sqn=Sqn.';
rin=Sin+nl;
rqn=Sqn+nq;





Sin2=conv(rin,srrcImpulseResponse_alpha03_P16);
Sqn2=conv(rqn,srrcImpulseResponse_alpha03_P16);


% figure(4);
% eyediagram(Sin2,P);
 
% figure(5);
% plot(Sin2);
temp=1;
Sin2new=zeros(1,L);
Sqn2new=zeros(1,L);
for i=97:P:1698
    Sin2new(temp)=Sin2(i);
    Sqn2new(temp)=Sqn2(i);
    temp=temp+1;
end
r=Sin2new+1j*Sqn2new;
trans=[complex(1,1);complex(-1,1);complex(1,-1);complex(-1,-1);complex(3,1);complex(1,3);complex(-1,3);complex(-3,1);complex(3,-1);complex(1,-3);complex(-1,-3);complex(-3,-1);complex(3,4);complex(-3,3);complex(3,-3);complex(-3,-3)];

%trans=[cosd(45)+1j*sind(45);cosd(135)+1j*sind(135);cosd(-45)+1j*sind(-45);cosd(-135)+1j*sind(-135);3*cos(atan(1/3))+1j*3*sin(atan(1/3));3*cos(atan(3))+1j*3*sin(atan(3));3*cosd(90+rad2deg(atan(1/3)))+1j*3*sind(90+rad2deg(atan(1/3)));3*cosd(-rad2deg(atan(1/3)))+1j*3*sind(-rad2deg(atan(1/3)));3*cosd(90+rad2deg(atan(3)))+1j*3*sind(90+rad2deg(atan(3)));3*cosd(-rad2deg(atan(1/3)))+1j*3*sind(-rad2deg(atan(1/3)));3*cosd(-(rad2deg(atan(3))))+1j*3*sind(-(rad2deg(atan(3))));3*cosd(-(90+rad2deg(atan(1/3))))+1j*3*sind(-(90+rad2deg(atan(1/3))));3*cosd(-(90+rad2deg(atan(3))))+1j*3*sind(-(90+(rad2deg(atan(3)))));5*cosd(45)+1j*5*sind(45);5*cosd(135)+1j*5*sind(135);5*cosd(-45)+1j*5*sind(-45);5*cosd(-135)+1j*5*sind(-135)];
detect=detert(r,trans);

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
UUB(temp)=4*qfunc(1/(sigma));
end
semilogy(EsNoVec,average,'bo:','linewidth',2,'markerfacecolor','b');
hold on; 
semilogy(EsNoVec2,UUB,'r','linewidth',2); 
legend('Simulatation','Theory');
title('Symbol Error Probability Evaluation for 8PSK Modulation');
    ylabel('Probability of Symbol Error'); xlabel('E_s/N_0 in dB'); grid 

