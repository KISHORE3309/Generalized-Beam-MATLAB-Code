function [xnume, th_nume] = postprocessing_slope(nele,coord,connect,un,xi)
% storing node positions in xn
for i=1:size(coord,1)
    xn(i)=coord(i,2);
end
xnume=[];th_nume=[];
for i=1:nele
    x_n = xn(i:i+1);
    nd1=connect(i,2);
    nd2=connect(i,3);
    u_n=un(2*nd1-1:2*nd2);
    le = x_n(2) - x_n(1);
    xi = [-1:0.2:1]';
    Nx = [(1-xi)/2, (1+xi)/2];
    N1 = (-3+3.*xi.^2)/4;
    N2 = (-1 -xi.*2+3.*xi.^2)/4;
    N3 = ( 3 -3.*xi.^2)/4;
    N4 = (-1  + xi.*2 +3.*xi.^2)/4;
    % multiply with 2/le as we calculated N' wrt xi and we want ans wrt x
    Nu = (2/le)*[N1 le*N2/2 N3 le*N4/2];    
    xnume = [xnume;Nx*x_n'];
    th_nume = [th_nume;Nu*u_n];
end
