%El_number is the total number of elements
El_number = 4;
%Node_number is the total number of node
Node_number = 5;
%   Element    1st    2nd      Ari(mm^2)     yang(pa)    Lengeh 
%   number     node   node        A             E          L
AD =[1          1      2         250        200*10^9      150    ;...
     2          2      3         250        200*10^9      150    ;...
     3          3      4         400        200*10^9      150    ;...
     4          4      5         400        200*10^9      150    ];                                    


%Node_cordinates
%    Node     x       y
%    Num     (mm)     (mm)
CO=[ 1       0      604.5  ;...
     2       0      454.5  ;...
     3       0      304.5  ;...
     4       0      154.5  ;...
     5       0      4.5   ];

 %known_displacements 
 %     node    u
 %     num    (mm)   
 u = [  1      0;...
        5      4.5];
    
 %known_force 
 %     node    fy
 %     num    (N) 
 f = [2     300*10^3
      4     600*10^3];