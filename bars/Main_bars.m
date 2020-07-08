clear;
clc;
%step 1: input data
InputData_bars;
 
%step 2:construction of element stiffness materix
for i = 1: El_number
     A= AD(i,4)*10^-6;
     E= AD(i,5);
     
     xi=CO(AD(i,2),2);  yi=CO(AD(i,2),3);
     xj=CO(AD(i,3),2);  yj=CO(AD(i,3),3);
     
     L= sqrt((xj-xi)^2 + (yj-yi)^2)*10^-3;
     
     alfa=E*A/L;
     ke=[ 1  -1;...
         -1  1];
     
    k(:,:,i)=alfa*ke;
end
%step 3:construction of stiffness matrix of whole structure

K = zeros(Node_number,Node_number);

for i = 1: El_number
    address =[AD(i,2) ,AD(i,3)];
    K(address,address) =  K(address,address) + k(:,:,i);
end
Kred =K;

%step 4: force vactor , Displacment vactor , solve
F= zeros (Node_number,1);
     fNodes = f(:,1)';
     F(fNodes) = f(:,2);

 
U= zeros (Node_number,1);
    uNodes = u(:,1)';
    U(uNodes) = u(:,2)*10^-3;
 
for i=uNodes
    for  j=1:Node_number
        F(j)=F(j) - Kred(j,i)*U(i);
        Kred(j,i)=0;
        Kred(i,j)=0;
    end
   Kred(i,i)=1;
   F(i)= U(i);
end
U = Kred \ F;

% step 5: post-processing
F = K * U ;

%outputData
Fid = fopen('OutputData_bars.m','w');
% Fid = fopen('OutputData_bars.txt','w');
% Fid = fopen('OutputData_bars.pdf','w');

fprintf(Fid,'*********************************************\n');
fprintf(Fid,'******************* my answer ***************\n');
fprintf(Fid,'*********************************************\n');
fprintf(Fid,'*********************************************\n');
fprintf(Fid,'*** table of nodal displacemant and force ***\n');
fprintf(Fid,'*********************************************\n');
fprintf(Fid,'Node             u(mm)            f(kN)');
for i=1:Node_number
    fprintf(Fid,'\n %d          %+10.4f          %+10.4f\n',i,U(i)*10^3,F(i)*10^-3);
end
fprintf(Fid,'\n**********************************************');
fprintf(Fid,'\n****************** The end *******************');
fprintf(Fid,'\n**********************************************');