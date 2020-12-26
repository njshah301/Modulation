%8-PSK
close all;
clear all;
k=4;  %QPSK
Es=10;   %QPSK
Nsim=10000;
tem=0;

EsNoVec=0:1:15;
average=zeros(1,length(EsNoVec));
for EsNodB=0:1:15
    tem=tem+1;
    er=0;
for ksim=1:Nsim
    k=4;
L=100;
size=k*L;      %QPSK
%MODULATION
X=randi([0,1],1,size);

S=[];

trans=[complex(1,1);complex(-1,1);complex(1,-1);complex(-1,-1);complex(3,1);complex(1,3);complex(-1,3);complex(-3,1);complex(3,-1);complex(1,-3);complex(-1,-3);complex(-3,-1);complex(3,3);complex(-3,3);complex(3,-3);complex(-3,-3)];
for i=1:4:size          %QPSK
    if(X(i)==1 && X(i+1)==0 && X(i+2)==1  && X(i+3)==0)
        y=trans(1);
    elseif(X(i)==1 && X(i+1)==0  && X(i+2)==0 && X(i+3)==1)
        y=trans(2);
    elseif(X(i)==0 && X(i+1)==1  && X(i+2)==1 && X(i+3)==0)
       y=trans(3);
    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==0 && X(i+3)==1)
        y=trans(4);
        
    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==1 && X(i+3)==1)
        y=trans(5);
    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1 && X(i+3)==0)
        y=trans(6);
    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==0 && X(i+3)==1)
        y=trans(7);
    elseif(X(i)==1 && X(i+1)==0 && X(i+2)==0 && X(i+3)==0)
       y=trans(8);
       
            elseif(X(i)==0 && X(i+1)==1 && X(i+2)==1 && X(i+3)==1)
        y=trans(9);
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==1 && X(i+3)==0)
        y=trans(10);
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0 && X(i+3)==1)
        y=trans(11);
    elseif(X(i)==0 && X(i+1)==1 && X(i+2)==0 && X(i+3)==0)
       y=trans(12);
        
    elseif(X(i)==1 && X(i+1)==1 && X(i+2)==1  && X(i+3)==1)
     y=trans(13);
    elseif(X(i)==1 && X(i+1)==1  && X(i+2)==0 && X(i+3)==0)
        y=trans(14);
    elseif(X(i)==0 && X(i+1)==0  && X(i+2)==1 && X(i+3)==1)
      y=trans(15);
    elseif(X(i)==0 && X(i+1)==0 && X(i+2)==0 && X(i+3)==0)
        y=trans(16);
        
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

%hold on;
%plot(S);

%hold off;


%Minimum-distance detection
trans=[complex(1,1);complex(-1,1);complex(1,-1);complex(-1,-1);complex(3,1);complex(1,3);complex(-1,3);complex(-3,1);complex(3,-1);complex(1,-3);complex(-1,-3);complex(-3,-1);complex(3,3);complex(-3,3);complex(3,-3);complex(-3,-3)];

%trans=[cosd(45)+1j*sind(45);cosd(135)+1j*sind(135);cosd(-45)+1j*sind(-45);cosd(-135)+1j*sind(-135);3*cos(atan(1/3))+1j*3*sin(atan(1/3));3*cos(atan(3))+1j*3*sin(atan(3));3*cosd(90+rad2deg(atan(1/3)))+1j*3*sind(90+rad2deg(atan(1/3)));3*cosd(-rad2deg(atan(1/3)))+1j*3*sind(-rad2deg(atan(1/3)));3*cosd(90+rad2deg(atan(3)))+1j*3*sind(90+rad2deg(atan(3)));3*cosd(-rad2deg(atan(1/3)))+1j*3*sind(-rad2deg(atan(1/3)));3*cosd(-(rad2deg(atan(3))))+1j*3*sind(-(rad2deg(atan(3))));3*cosd(-(90+rad2deg(atan(1/3))))+1j*3*sind(-(90+rad2deg(atan(1/3))));3*cosd(-(90+rad2deg(atan(3))))+1j*3*sind(-(90+(rad2deg(atan(3)))));5*cosd(45)+1j*5*sind(45);5*cosd(135)+1j*5*sind(135);5*cosd(-45)+1j*5*sind(-45);5*cosd(-135)+1j*5*sind(-135)];
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
% 
% temp=1;
% for i=1:L
%  
%     if(real(detect(i))==1 && imag(detect(i))==1)
%       h(temp:temp+3)=[1 0 1 0];
%       temp=temp+k;
%     elseif(real(detect(i))==-1 && imag(detect(i))==1)
%         h(temp:temp+3)=[1 0 0 1];
%         temp=temp+k;
%     elseif(real(detect(i))==1 && imag(detect(i))==-1)
%         h(temp:temp+3)=[0 1 1 0];
%         temp=temp+k;
%     elseif(real(detect(i))==-1 && imag(detect(i))==-1)
%         h(temp:temp+3)=[0 1 0 1];
%         temp=temp+k;
%         
%         elseif(real(detect(i))==3 && imag(detect(i))==1)
%         h(temp:temp+3)=[1 0 1 1];
%         temp=temp+k;
%     elseif(real(detect(i))==1 && imag(detect(i))==3)
%         h(temp:temp+3)=[1 1 1 0];
%         temp=temp+k;
%     elseif(real(detect(i))==-1 && imag(detect(i))==3)
%         h(temp:temp+3)=[1 1 0 1];
%         temp=temp+k;
%     elseif(real(detect(i))==-3 && imag(detect(i))==1)
%         h(temp:temp+3)=[1 0 0 0];
%         temp=temp+k;
%   
%     elseif(real(detect(i))==3 && imag(detect(i))==-1)
%         h(temp:temp+3)=[0 1 1 1];
%         temp=temp+k;
%   
%     elseif(real(detect(i))==1 && imag(detect(i))==-3)
%         h(temp:temp+3)=[0 0 1 0];
%         temp=temp+k;
%   
%     elseif(real(detect(i))==-1 && imag(detect(i))==-3)
%         h(temp:temp+3)=[0 0 0 1];
%         temp=temp+k;
%   
%     elseif(real(detect(i))==-3 && imag(detect(i))==-1)
%         h(temp:temp+3)=[0 1 0 0];
%         temp=temp+k;
%   
%     elseif(real(detect(i))==3 && imag(detect(i))==4)
%         h(temp:temp+3)=[1 1 1 1];
%         temp=temp+k;
%         
%     elseif(real(detect(i))==-3 && imag(detect(i))==3)
%         h(temp:temp+3)=[1 1 0 0];
%         temp=temp+k;
%   
%     elseif(real(detect(i))==3 && imag(detect(i))==-3)
%         h(temp:temp+3)=[0 0 1 1];
%         temp=temp+k;
%   
%     elseif(real(detect(i))==-3 && imag(detect(i))==-3)
%         h(temp:temp+3)=[0 0 0 0];
%         temp=temp+k;
%  
%     end   
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
UUB(temp)=4*qfunc(1/(sigma));
end
semilogy(EsNoVec,average,'bo:','linewidth',2,'markerfacecolor','b');
hold on; 
semilogy(EsNoVec2,UUB,'r','linewidth',2); 
legend('Simulatation','Theory');
title('Symbol Error Probability Evaluation for 16-APSK Modulation');
    ylabel('Probability of Symbol Error'); xlabel('E_s/N_0 in dB'); grid 
