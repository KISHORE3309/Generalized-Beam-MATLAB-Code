function [xnume, unume] = postprocessing_def(nele,coord,connect,un,xi)
% storing node positions in xn
for i=1:size(coord,1)
    xn(i)=coord(i,2);
end
xnume=[];unume=[];
for i=1:nele
    x_n = xn(i:i+1);
    nd1=connect(i,2);
    nd2=connect(i,3);
    u_n=un(2*nd1-1:2*nd2);
    le = x_n(2) - x_n(1);
    Nx = [(1-xi)/2, (1+xi)/2];
    N1 = (2-3.*xi+xi.^3)/4;
    N2 = (1-xi -xi.^2 +xi.^3)/4;
    N3 = (2 + 3.*xi -xi.^3)/4;
    N4 = (-1 -xi + xi.^2 + xi.^3)/4;
    Nu = [N1 le*N2/2 N3 le*N4/2];
    xnume = [xnume;Nx*x_n'];
    unume = [unume;Nu*u_n];
end
