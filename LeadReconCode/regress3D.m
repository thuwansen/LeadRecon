function [loc,direction,contactCoordinate]=regress3D(sliceThick,dOfLead,leadImg)

% This function is to regress the line of lead artifact
% input : 
%   sliceThick is slice thickness
%   dOfLead: the length of the lead to be regress
%   leadImg: the lead artifact image to be regress
%   contactCoordinate: the coordinate of contacts
% output:
%   loc: the coordinate of lead artifact
%   direction: the direction of the regressed line

%selcet the voxels to be regressed
slices=round(dOfLead/sliceThick);
temImg=leadImg;
[b1,b2,b3]=size(leadImg);
for i=1:b3
    if max(max(temImg(:,:,i)))~=0
        break;
    end
end

temImg(:,:,i+slices:b3)=0;
e=find(temImg~=0);
loc=zeros(length(e),3);
num=1;
for k1=1:b1
    for k2=1:b2
        for k3=i:i+slices
            if(temImg(k1,k2,k3)~=0)
                loc(num,1)=k1;
                loc(num,2)=k2;
                loc(num,3)=k3;
                num=num+1;
            end
        end
    end
end


%appling the voxels to regress a line 

lineData=loc;
figure;
scatter3(lineData(:,1), lineData(:,2), lineData(:,3),'filled')
hold on;
%cal the average point as the fixed point of the line
xyz0=mean(lineData,1);

% the direction of the line is the direction of the maximun 
% singular value
centeredLine=bsxfun(@minus,lineData,xyz0);
[U,S,V]=svd(centeredLine);
direction=V(:,1);
if direction(3)<0
    direction=-direction;
end


% plot the line 
lengthOfZmax=round((max(loc(:,3))-xyz0(3))/direction(3));
lengthOfZmin=round((min(loc(:,3))-xyz0(3))/direction(3));

t=lengthOfZmin:0.1:lengthOfZmax;
xx=xyz0(1)+direction(1)*t;
yy=xyz0(2)+direction(2)*t;
zz=xyz0(3)+direction(3)*t;
plot3(xx,yy,zz);
hold on;

contactCoordinate=zeros(4,3);

% calculate the contact of the electrode
% coordinate of the first contact
contactCoordinate(1,1)=xyz0(1)+direction(1)*lengthOfZmin;
contactCoordinate(1,2)=xyz0(2)+direction(2)*lengthOfZmin;
contactCoordinate(1,3)=xyz0(3)+direction(3)*lengthOfZmin;
% coordinate of the other contact
for j=2:4
    for k=1:3
    contactCoordinate(j,k)=contactCoordinate(j-1,k)+direction(k)*2; %direct of Z is negative
    end
end

scatter3(contactCoordinate(:,1),contactCoordinate(:,2),contactCoordinate(:,3),'o');