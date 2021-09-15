function [K,F]=stiff_load(nele,nguass,coord,connect,xivec,wvec,E,Ie,q_load)
% STIFFNESS
kele=zeros(4,4,nele);
for el=1:nele
    nd1=connect(el,2);
    nd2=connect(el,3);
        for gp=1:nguass
        xi=xivec(gp);w=wvec(gp);
        %shape functions
        N1=(1-xi)^2*(2+xi)/4;   N2=(1-xi)^2*(1+xi)/4;
        N3=(2+3*xi-xi^3)/4;     N4=(xi^3+xi^2-xi-1)/4;
        Le=coord(nd2,2)-coord(nd1,2);
        N=[N1,Le*N2/2,N3,Le*N4/2];
        B=(4/Le^2)*[3*xi/2, Le*(3*xi-1)/4, -3*xi/2, Le*(3*xi+1)/4];
        %% element stiffness calculation
        kele(1:4,1:4,el)=kele(1:4,1:4,el)+E(el)*Ie(el)*(B'*B)*Le*.5*w;
        end
end
%%assembly of stiffness matrix
K=zeros(2*(nele+1),2*(nele+1));
for el=1:nele
    nd1=connect(el,2);
    nd2=connect(el,3);
    vec=[2*nd1-1,2*nd1,2*nd2-1,2*nd2];
    for i=1:4
        for j=1:4
            K(vec(i),vec(j))= K(vec(i),vec(j))+kele(i,j,el);
        end
    end
end
%% LOAD VECTOR DUE TO DISTRIBUTED LOAD
% storing load element nos in different vector
for i=1:size(q_load,1)
    q_ele(i)=q_load(i,1);
end
fele=zeros(4,nele);
for el=1:nele
    nd1=connect(el,2);
    nd2=connect(el,3);
        for gp=1:nguass
        xi=xivec(gp);w=wvec(gp);
        %% shape functions
        N1=(1-xi)^2*(2+xi)/4;   N2=(1-xi)^2*(1+xi)/4;
        N3=(2+3*xi-xi^3)/4;     N4=(xi^3+xi^2-xi-1)/4;
        Le=coord(nd2,2)-coord(nd1,2);
        N=[N1,Le*N2/2,N3,Le*N4/2];
        xvec=[coord(nd1,2),coord(nd2,2)];
        x=[(1-xi)/2,(1+xi)/2]*xvec';
        s=ismember(el,q_ele);
        if s==1
            q=q_load(el,2)+q_load(el,3)*x+q_load(el,4)*x^2;
        end
        %% element wise load calculation
        fele(1:4,el)=fele(1:4,el)+N'*q*w*Le/2;
        end
end
%Assembly of element load vectors
F=zeros(2*(nele+1),1);
for el=1:nele
    nd1=connect(el,2);
    nd2=connect(el,3);
    vec=[2*nd1-1,2*nd1,2*nd2-1,2*nd2];
    for i=1:4
            F(vec(i))= F(vec(i))+fele(i,el); 
    end
end
