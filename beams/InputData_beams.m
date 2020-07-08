%El_number is the total number of elements
El_number = 3;
%Node_number is the total number of node
Node_number = 4;
%   Element    1st    2nd      Ari(mm^2)  inertia(mm^4)  yang(pa)
%   number     node   node        A             I            E
AD =[1          1      2         6580        94.9*10^6      200*10^9;...
     2          2      3         6580        94.9*10^6      200*10^9
     3          3      4         6580        94.9*10^6      200*10^9];
 
%  If you don't know anything about ux,uy,t,m,fx,fy leave the matrix blank

%Node_cordinates
%    Node     x       y
%    Num     (mm)     (mm)
CO=[ 1       0        0    ;...
     2       1200     0    ;...
     3       2400     0    ;...
     4       3600     0    ];

 %known_displacements 
 %     node    uy
 %     num    (mm)   
 uy = [  1      0;...
         4      0];
    
 %known_displacements 
 %     node    ux
 %     num    (mm)   
 ux = [         ];
  
  %known_Rotation 
 %       node   teta
 %       num    (deg)   
  t =     [        ];
 
 %known_momentom 
 %     node    M
 %     num       
 m = [  1      18;...
        2      0;...
        3      0;...
        4      27];
 %known_force
 %     node    fx
 %     num    (N)
 fx = [          ];
    
 %known_force 
 %     node    fy
 %     num    (N) 
 fy = [2     -24000
       3     -48000];