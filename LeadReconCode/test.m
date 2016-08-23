function [locX,locY,ledImg,num]=voxelsOfLead(img)

%This function is to calculate the distict of Lead in 2-D district.
%input: the axis image of MR or CT
%funciton: apply gray level as the standard line
%output: locX and locY is the location of center
%        ledImg is a binary map of lead,
%        num is the threshhold of voxels of the lead.
% writen by wansen 2016.07.25

temp=mean(mean(img));
A=img;
for i=1:10
    A(A<temp*0.5)=0;
    A(A~=0)=1;
    num=sum(sum(A));
    if num<2500
        break;
    end
end
ledImg=1-A;
% cal the connet district and wipe off the isolated small group voxels
[L,num]=bwlabel(ledImg,8);
max=0;
indMax=0;
for k=1:num
    [y,x]=find(L==k);
    nSize=length(y);
    if (nSize>max)
        max=nSize;
        indMax=k;
    end
end
[y,x]=find(L==indMax);
temImg=zeros(size(ledImg));
for i=1:length(y)
    temImg(y(i),x(i))=1;
end
ledImg=ledImg.*temImg;
[tempX,tempY]=find(ledImg==1);
locY=round(mean(tempX));
locX=round(mean(tempY));