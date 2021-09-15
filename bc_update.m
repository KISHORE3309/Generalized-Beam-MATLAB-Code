function [un] = bc_update(ureduce,BC_data)
nele=size(ureduce,1)*0.5+size(BC_data)*0.5-1;
for i=1:size(BC_data,1)
    node(i)=BC_data(i,1);
    dof(i)=BC_data(i,2);
    val(i)=BC_data(i,3);
end
for i=1:size(BC_data,1)
    gdof(i)=2*node(i)+dof(i)-2;
end
for j=1:size(BC_data,1)
    y=gdof(j);
    if y==1
        un(y)=val(j);
        for i=y+1:length(ureduce)+1
            un(i)=ureduce(i-1);
        end
    elseif y==2*(nele+1)
        for i=1:y
            un(i)=ureduce(i);
        end
        un(y+1)=val(j);
    else
        for i=1:y-1
            un(i)=ureduce(i);
        end
        un(y)=val(j);
        for i=y+1:length(ureduce)+1
            un(i)=ureduce(i-1);
        end
    end
    ureduce=un;
end
un=un';
