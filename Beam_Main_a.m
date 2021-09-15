% ===================
% Reading Input File:
% ===================
fid=fopen('Output','w');
for count=1:2
    if count==1
        input_file_beam_prob_a;
    else
         input_file_beam_prob_a1;
    end
node=size(coord,1);
% Global Stiffnes Matrix and Global load vector
% ---------------------------------------------
% Function "stiff_load" calculate Global Stiffness Matrix and 
%     Global load vector due to distributed load
% ----------
% I N P U T
% = = = = = 
% nele   = No. of elements 
% ngauss = No. of gauss points for integration
% coord  = Nodal coordinates    % First Column is Node numbers
%                                 Second Column is Co-ordinate
% connect = Nodal Connectivities    % First Column is element number    
                                    % Second & Third Column are Nodes (in sequence)  
                                    % For that element. 
% xivec = Gauss points
% wvec  = weights
% E = Young's Modulus of the element
% Ie = Area Moment of inertia of the element
% q0 = Maximum distributed load (Triangular) magnitude
% L  = Length
%
% ----------
% O U T P U T
% = = = = =
% K = Global stiffness matrix
% F = Global load vector
%

[K,F] = stiff_load(nele,ngauss,coord,connect,xivec,wvec,E,Ie,q_load);

% Point load and Point moment
% ---------------------------
% This function "point_ld_mom" update Global load vector after incorporating point load 
% and point moment data
%
% ----------
% I N P U T
% = = = = = 
% F      = Global load vector before implementing point load and point moment
% P_load = Point load data  % First Column is Node number
                            % Second Column is Point load value
% P_moment = Point moment data       % First Column is Node number
                                     % Second Column is Point moment value
% -------------
% O U T P U T
% = = = = =====
% F = Global load vector after implementing point load and point moment

F = point_ld_mom(F,P_load,P_moment);


% ===========================
% Imposition of B.C.
K_glob = K;
F_glob = F;

% This function "impose_bc" update Global stiffness matrix and Global load vector 
% after incorporating boundary condition data
%
% ----------
% I N P U T
% = = = = = 
% K       = Global stiffness matrix before implementing Boundary condition data
% F       = Global load vector before implementing Boundary condition data
% BC_data = Boundary condition data        % First Column is Node number
                                           % Second Column is the prescribed D.O.F
                                           % Third Column is value of the prescribed D.O.F 
%
% -------------
% O U T P U T
% = = = = =====
% K       = Global stiffness matrix after implementing Boundary condition data
% F       = Global load vector after implementing Boundary condition data

[K,F] = impose_bc(nele,K,F,BC_data);


% Finding Solution
ureduce = inv(K)*F;

% Full Solution vector (Free + Prescribed D. O. F.)
% -------------------------------------------------
% This function "bc_update" update solution vector with values of prescribed DOFs
% 
% I N P U T
% =========
% ureduce = Solution vector just after inversion
%           It contains only free DOFs
% BC_data = Boundary condition data        % First Column is Node number
                                           % Second Column is the prescribed D.O.F
                                           % Third Column is value of the prescribed D.O.F 
% -------------
% O U T P U T
% = = = = =====
% un = Full solution vectors with Free and Prescribed DOF values
un = bc_update(ureduce,BC_data);

% Finding Reaction Force
Freac = K_glob*un;

% Post Processing: FEM displacement
xi = [-1:0.2:1]';          % Distribution of data points

% This function "postprocessing_def" calculate variable u at diffent distributed points across
% element from nodal values of u
% This function calculate variable u at diffent distributed points across
% element from nodal values of u
% ----------
% I N P U T
% = = = = = 
% nele   = No. of elements
% coord  = Nodal coordinates    % First Column is Node numbers
%                                 Second Column is Co-ordinate
% connect = Nodal Connectivities    % First Column is element number    
                                    % Second & Third Column are Nodes (in sequence)  
                                    % For that element. 
% xi = Points distributed for an element in master domain
% un = Nodal values of u
%
% ----------
% O U T P U T
% = = = = =
% xnume = x coordinates of the distributed points
% unume = values of u at distributed points

[xnume, unume] = postprocessing_def(nele,coord,connect,un,xi);
[xnume, th_nume] = postprocessing_slope(nele,coord,connect,un,xi);

% plotting of deflection and slope values
subplot(1,2,1)
if count==1
    plot(xnume,unume,'g-')
    hold on
else
    plot(xnume,unume,'r*')
end
%
subplot(1,2,2)
if count==1
    plot(xnume,th_nume,'g-')
    hold on
else
    plot(xnume,th_nume,'r*')
end

fprintf(fid,'\nGlobal stiffness matrix for %4.1d elements is\n',nele);
fprintf(fid,'===================================\n');
fprintf(fid,'K_glob\n');
fprintf(fid,'------------------------------------------------------------\n\n');
for i=1:2*node
    for j=1:2*node
        fprintf(fid,'%12.4e\t',K_glob(i,j));
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\nGlobal load vector for %4.1d elements is\n',nele);
fprintf(fid,'===================================\n');
fprintf(fid,'F_glob\n');
fprintf(fid,'------------------------------------------------------------\n\n');
for i=1:2*node
        fprintf(fid,'%12.4e\n',F_glob(i));
end
fprintf(fid,'\nDisplacement vector for %4.1d elements is\n',nele);
fprintf(fid,'===================================\n');
fprintf(fid,'un\n');
fprintf(fid,'------------------------------------------------------------\n\n');
for i=1:2*node
        fprintf(fid,'%12.4e\n',un(i));
end
fprintf(fid,'\nReaction force vector for %4.1d elements is\n',nele);
fprintf(fid,'===================================\n');
fprintf(fid,'Freac\n');
fprintf(fid,'------------------------------------------------------------\n\n');
for i=1:2*node
        fprintf(fid,'%12.4e\n',Freac(i));
end

end
h=figure(1)
subplot(1,2,1)
xlabel('x')
ylabel('deflection')
title('Deflection vs x')
legend('3 elements','6 elements')

subplot(1,2,2)
xlabel('x')
ylabel('\theta')
title('\theta vs x')
legend('3 elements','6 elements')
%Saving the plots
saveas(h,'Graph','png')
