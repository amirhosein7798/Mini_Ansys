
%El_number is the total number of elements
El_number = 7;
%Node_number is the total number of node
Node_number = 5;
%   Element    1st    2nd      Ari(mm^2)      yang(pa)
%   number  node(i)  node(j)      A             E
AD =[1          2      1        500         200*10^9;...
     2          1      3        500         200*10^9;...
     3          4      1        500         200*10^9;...
     4          2      4        1000        200*10^9;...
     5          4      3        1000        200*10^9;...
     6          3      5        500         200*10^9;...
     7          4      5        1000        200*10^9];
%  If you don't know anything about ux,uy leave the matrix blank

%Node_cordinates
%    Node     x       y
%    Num     (mm)     (mm)
CO=[ 1       0        800    ;...
     2       0         0     ;...
     3       600      800    ;...
     4       600       0     ;...
     5       2100     800    ];
 
 %known_x.displacements
 %     node    ux 
 %     num    (mm)
 ux = [ 1      0;...
        2      0];
 
 %known_y.displacements
 %     node    uy 
 %     num    (mm)
 uy = [ 1      0];
  
 
 %known_x.force  
 %     node    Fx 
 %     num    (N)
 fx = [2       0;...
       3       0;...
       4       0;...
       5       0];
   
%known_y.force  
 %     node    Fy 
 %     num    (N)
 fy = [2       0;...
       3       0;...
       4       0;...
       5      -40000];