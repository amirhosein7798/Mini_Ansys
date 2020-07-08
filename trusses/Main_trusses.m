clear;
clc;
%step 1: input data
InputData_trusses;
 
%step 2:construction of element stiffness materix

for i = 1: El_number
     A= AD(i,4)*10^-6;
     E= AD(i,5);
     
     xi=CO(AD(i,2),2);  yi=CO(AD(i,2),3);
     xj=CO(AD(i,3),2);  yj=CO(AD(i,3),3);
     
     L= sqrt((xj-xi)^2 + (yj-yi)^2)*10^-3;
     T= atan2 (yj-yi,xj-xi);
  
     alfa=E*A/L;
     c=cos(T) ; s=sin(T);
    ke=[c^2   c*s  -c^2  -c*s;...
        c*s   s^2  -c*s  -s^2;...
        -c^2  -c*s  c^2  c*s;...
        -c*s  -s^2  c*s  s^2];

     
    k(:,:,i)=alfa*ke;
end
%step 3:construction of stiffness matrix of whole structure
K = zeros(2*Node_number,2*Node_number);

for i = 1: El_number
    address =[2*AD(i,2)-1 2*AD(i,2) ,2*AD(i,3)-1 2*AD(i,3)];
    K(address,address) =  K(address,address) + k(:,:,i);
end
Kred =K;

%step 4: force vactor , Displacment vactor , solve
F= zeros (2*Node_number,1);
    if size(fx) ~= 0
         fxNodes = fx(:,1)';
         F(2*fxNodes-1) = fx(:,2)*10^-3;
    end
    if size(fy) ~= 0
         fyNodes = fy(:,1)';
         F(2*fyNodes) = fy(:,2)*10^-3;
    end
 
 
U= zeros (2*Node_number,1);
    if size(ux) ~= 0
         uxNodes = ux(:,1)';
         U(2*uxNodes-1) = ux(:,2)*10^-3;
    end
     if size(uy) ~= 0
         uyNodes = uy(:,1)';
         U(2*uyNodes) = uy(:,2)*10^-3;
     end
    
 UNodes = [2*uxNodes-1,2*uyNodes];
for i= UNodes
    for  j=1: 2*Node_number
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
Fid = fopen('OutputData_trusses.m','w');
% Fid = fopen('OutputData_trusses.txt','w');
% Fid = fopen('OutputData_trusses.PDF','w');

fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'************************* my answer ***************************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'***************** table of nodal displacemant *****************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'Node             ux(mm)            uy(mm)');
for i=1:Node_number
    fprintf(Fid,'\n %d          %+10.4f          %+10.4f\n',i,U(2*i-1)*10^6,U(2*i)*10^6);
end

fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'********************* table of nodal Forces *******************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'Node            fx(KN)             fy(kN)');
for i=1:Node_number
    fprintf(Fid,'\n %d          %+10.4f          %+10.4f\n',i,F(2*i-1),F(2*i));
end
fprintf(Fid,'\n****************************************************************');
fprintf(Fid,'\n************************ The end *******************************');
fprintf(Fid,'\n****************************************************************');
