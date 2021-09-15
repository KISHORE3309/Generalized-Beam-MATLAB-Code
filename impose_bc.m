function [K,F] = impose_bc(nele,K,F,BC_data)
for i=1:size(BC_data,1)
    node(i)=BC_data(i,1);
    dof(i)=BC_data(i,2);
    val(i)=BC_data(i,3);
end
for i=1:size(BC_data,1)
    % Modification of load vector according to BC data
    if val(i)~=0
        for j=1:2*(nele+1)
            F(j)=F(j)-K(j,2*node(i)+dof(i)-2)*val(i);
        end
    end
end
%elimination of rows and columns from F and K
for i=1:size(BC_data,1)
    gdof(i)=2*node(i)+dof(i)-2;
end
K(gdof,:)=[];
K(:,gdof)=[];
F(gdof,:)=[];

            
        