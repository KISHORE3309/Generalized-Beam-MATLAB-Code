% Material properties and other inputs
%--------------------------------------
E0 = 90e6; Ie0 = 8.24e-4; q0 = 300; q2 = 200; 
L1 = 0.2; L2 = 0.24; L3 = 0.16; F0 = 5000;

nele  = 3;                       % No. of Elements

% Gauss Points and weights vector          || C H A N G E ||
% --------------------------------
ngauss = 3;                              % No. of Gauss points
xivec = [-0.774597, 0, 0.774597];       % Gauss points
wvec = [5/9, 8/9, 5/9];                 % Weights


 

% Co-ordinates for Nodes              || C H A N G E ||
% -------------------------
coord = [1,   0.0;           % First Column is Node numbers
         2,   L1;            % Second Column is Co-ordinate
         3,   L1+L2;
         4,   L1+L2+L3];


connect = [1,  1,  2;      % First Column is element number
           2,  2,  3;      % Second & Third Column are Nodes (in sequence)  
           3,  3,  4];     %       For that element.
           
% START CHANGE %         

% Boundary Condition Suppressed
% -----------------------------
BC_data = [1, 1, 0;        % First Column is Node number
           1, 2, 0;        % Second Column is the prescribed D.O.F
           3, 1, 0];       % Third Column is value of the prescribed D.O.F
           
% Material Properties and Area moment of Inertia
% ----------------------------------------------
E = E0*ones(nele,1);
Ie = Ie0*ones(nele,1);
       
       
% Point Load and Point Moment Data       
P_load = [4, F0];       % First Column is Node number
                        % Second Column is Point load value
       
P_moment = [];     % First Column is Node number
                   % Second Column is Point moment value
       
% Distributed Load data
q_load = [1, q0,            -(q0-q2)/L1,  0;  % First Column is element number
          2, q2,                      0,  0]; % For quadratic load  q = a + bx + cx^2                       
                                              % 2nd to 4th Columns are a,
                                              % b, c respectively
                                   
