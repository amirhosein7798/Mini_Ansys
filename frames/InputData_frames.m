%El_number is the total number of elements
El_number = 3;
%Node_number is the total number of node
Node_number = 4;
%   Element    1st    2nd      Ari(mm^2)  inertia(mm^4)    yang(pa)
%   number  node(i)  node(j)      A             I             E
AD =[1          1      2        7550        128*10^6      200*10^9;...
     2          2      3        7550        128*10^6      200*10^9;...
     3          3      4        7550        128*10^6      200*10^9];
%  If you don't know anything about ux,uy,t,m,f leave the matrix blank

%Node_cordinates
%    Node     x       y
%    Num     (mm)     (mm)
CO=[ 1       0        0    ;...
     2       0        10000;...
     3       10000    10000;...
     4       10000    0    ];
 
 %known_x.displacements
 %     node    ux 
 %     num    (mm)
 ux = [ 1      0];
 
 %known_y.displacements
 %     node    uy 
 %     num    (mm)
 uy = [ 1      0];
  
 
 %known_x.force  
 %     node    Fx 
 %     num    (N)
 fx = [2       0;...
       3       0;...
       4       10000];
   
%known_y.force  
 %     node    Fy 
 %     num    (N)
 fy = [2       0;...
       3       0;...
       4       0];
    
  %known_Rotation 
 %       node   teta
 %       num    (deg)   
  t =    [1       0];
 
 %known_momentom 
 %     node    M
 %     num   (N.mm)  
 m = [  2      0;...
        3      0;...
        4      0];