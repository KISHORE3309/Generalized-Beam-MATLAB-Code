function [F]=point_ld_mom(F,P_load,P_moment)
%Addition of Point Loads and Point Moments in Global Load vector
P_load;P_moment;
p=size(P_load,1);q=size(P_moment,1);
if p>0
    for i=1:p
         PL_vec(i)=P_load(i,1);       %storing of point load and point moment locations
         F(2*(PL_vec(i))-1)=F(2*(PL_vec(i))-1)+P_load(i,2);
    end
end
 if q>0
    for i=1:q
         PM_vec(i)=P_moment(i,1);
         F(2*(PM_vec(i)))=F(2*(PM_vec(i)))+P_moment(i,2);
    end
end


