clear;
clc;
%step 1: input data
InputData_frames;
 
%step 2:construction of element stiffness materix

for i = 1: El_number
     A= AD(i,4)*10^-6;
     I= AD(i,5)*10^-12;
     E= AD(i,6);
     
     xi=CO(AD(i,2),2);  yi=CO(AD(i,2),3);
     xj=CO(AD(i,3),2);  yj=CO(AD(i,3),3);
     
     L= sqrt((xj-xi)^2 + (yj-yi)^2)*10^-3;
     T= atan2 (yj-yi,xj-xi);
     
     beta=E*I/L^3;
     alfa=E*A/L;
     
     c=cos(T) ; s=sin(T);
%    ka = Stiffness matrix for axial   loading
%    kb = Stiffness matrix for bending loading
    ka=[c^2  c*s  0  -c^2  -c*s  0;...
        c*s  s^2  0  -c*s  -s^2  0;...
        0    0    0    0    0    0;...
        -c^2  -c*s  0  c^2  c*s  0;...
        -c*s  -s^2  0  c*s  s^2  0;...
        0    0    0    0    0    0];
    
    kb=[12*s^2   -12*c*s  -6*L*s  -12*s^2   12*c*s   -6*L*s;...
       -12*c*s    12*c^2   6*L*c   12*c*s  -12*c^2    6*L*c;...
        -6*L*s     6*L*c   4*L^2    6*L*s   -6*L*c    2*L^2;...
       -12*s^2   12*c*s    6*L*s   12*s^2  -12*c*s    6*L*s;...
        12*c*s  -12*c^2   -6*L*c  -12*c*s   12*c^2   -6*L*c;...
        -6*L*s    6*L*c    2*L^2    6*L*s   -6*L*c    4*L^2];

     
    k(:,:,i)=alfa*ka+beta*kb;
end
%step 3:construction of stiffness matrix of whole structure
K = zeros(3*Node_number,3*Node_number);

for i = 1: El_number
    address =[3*AD(i,2)-2 3*AD(i,2)-1 3*AD(i,2) ,3*AD(i,3)-2 3*AD(i,3)-1 3*AD(i,3)];
    K(address,address) =  K(address,address) + k(:,:,i);
end
Kred =K;

%step 4: force vactor , Displacment vactor , solve
F= zeros (3*Node_number,1);
    if size(fx) ~= 0
         fxNodes = fx(:,1)';
         F(3*fxNodes-2) = fx(:,2)*10^-3;
    end
    if size(fy) ~= 0
         fyNodes = fy(:,1)';
         F(3*fyNodes-1) = fy(:,2)*10^-3;
    end

     if size(m) ~= 0
         mNodes = m(:,1)';
        F(3*mNodes) = m(:,2)*10^-3;
     end

 
 
U= zeros (3*Node_number,1);
    if size(ux) ~= 0
         uxNodes = ux(:,1)';
         U(3*uxNodes-2) = ux(:,2)*10^-3;
    end
     if size(uy) ~= 0
         uyNodes = uy(:,1)';
         U(3*uyNodes-1) = uy(:,2)*10^-3;
    end
     if size(t) ~= 0
        tNodes = t(:,1)';
        U(3*tNodes) = t(:,2);
        UNodes = [3*uxNodes-2,3*uyNodes-1,3*tNodes];
     else
        UNodes = [3*uxNodes-2,3*uyNodes-1];
     end
 
for i= UNodes
    for  j=1: 3*Node_number
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

for  Deg =1:3*Node_number
     if mod(Deg,3)==0
        U(Deg,:) = U(Deg,:)*180/pi*10^-3;
     end
 end


%outputData
Fid = fopen('OutputData_frames.m','w');
% Fid = fopen('OutputData_frames.txt','w');
% Fid = fopen('OutputData_frames.PDF','w');

fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'**************************** my answer ************************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'********** table of nodal displacemant and rotations **********\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'Node             ux(mm)            uy(mm)            theta(deg)');
for i=1:Node_number
    fprintf(Fid,'\n %d          %+10.4f          %+10.4f          %+10.4f\n',i,U(3*i-2)*10^6,U(3*i-1)*10^6,U(3*i)*10^6);
end
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'*************** table of nodal Forces and Moments *************\n');
fprintf(Fid,'***************************************************************\n');
fprintf(Fid,'Node            fx(KN)             fy(kN)          moment(KN.m)');
for i=1:Node_number
    fprintf(Fid,'\n %d          %+10.4f          %+10.4f          %+10.4f\n',i,F(3*i-2),F(3*i-1),F(3*i));
end
fprintf(Fid,'\n****************************************************************');
fprintf(Fid,'\n*************************** The end ****************************');
fprintf(Fid,'\n****************************************************************');
