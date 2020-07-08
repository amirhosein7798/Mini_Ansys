clear;
clc;
%step 1: input data
InputData_beams;

%step 2:construction of element stiffness materix 
for i = 1: El_number
    I= AD(i,5)*10^-12;
    E= AD(i,6);
    
     xi=CO(AD(i,2),2);  yi=CO(AD(i,2),3);
     xj=CO(AD(i,3),2);  yj=CO(AD(i,3),3);
     
     L= sqrt((xj-xi)^2 + (yj-yi)^2)*10^-3;
    
    beta=E*I/L^3;
    ke=[12    6*L    -12   6*L  ;...
        6*L   4*L^2  -6*L  2*L^2;...
        -12  -6*L    12   -6*L  ;...
        6*L   2*L^2 -6*L   4*L^2];
    k(:,:,i)=beta*ke;
end
%step 3:construction of stiffness matrix of whole structure

K = zeros(2*Node_number,2*Node_number);
for i = 1: El_number
    address =[2*AD(i,2)-1 2*AD(i,2) ,2*AD(i,3)-1 2*AD(i,3)];
    K(address,address) =  K(address,address) + k(:,:,i);
end
Knew = K ;
%step 4: force vactor , Displacment vactor , solve

F= zeros (2*Node_number,1);
if size(fy) ~= 0
    fNodes = fy(:,1)';
    F(2*fNodes-1) = fy(:,2)*10^-3;
end

if size(m) ~= 0
    mNodes = m(:,1)';
    F(2*mNodes) = m(:,2)*10^-3;
end


U= zeros (2*Node_number,1);
if size(uy) ~= 0
    uNodes = uy(:,1)';
    U(2*uNodes-1) = uy(:,2)*10^-3;
end

if size(t) ~= 0
    tNodes = t(:,1)';
    U(2*tNodes) = t(:,2);
    UNodes = [2*uNodes-1 , 2*tNodes];
else
    UNodes = 2*uNodes-1;
end

for i= UNodes
    for  j=1: 2*Node_number
        F(j)=F(j) - Knew(j,i)*U(i);
        Knew(j,i)=0;
        Knew(i,j)=0;
    end
   Knew(i,i)=1;
   F(i)= U(i);
end
U = Knew \ F;

% step 5: post-processing

F = K * U ;

for  Deg =1:2*Node_number
     if mod(Deg,2)==0
        U(Deg,:) = U(Deg,:)*180/pi*10^-3;
     end
 end

%outputData
Fid = fopen('OutputData_beams.m','w');
% Fid = fopen('OutputDat_abeams.txt','w');
% Fid = fopen('OutputDat_abeams.pdf','w');

fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'**************************** my answer ************************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'***************** table of nodal displacemant *****************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'Node             uy(mm)            teta(deg)');
for i=1:Node_number
    fprintf(Fid,'\n %d          %+10.4f          %+10.4f\n',i,U(2*i-1)*10^6,U(2*i)*10^6);
end

fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'********************* table of nodal Forces *******************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'Node            fy(KN)             moment(KN.m)');
for i=1:Node_number
    fprintf(Fid,'\n %d          %+10.4f          %+10.4f\n',i,F(2*i-1),F(2*i));
end
fprintf(Fid,'\n****************************************************************');
fprintf(Fid,'\n*************************** The end ****************************');
fprintf(Fid,'\n****************************************************************');
