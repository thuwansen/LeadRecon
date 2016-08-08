function leadVoxel=voxelsOfLead3D(Y,startPoint,startSlice,radius)
% This function is to recon the 3D of Lead 
% input : 
%  Y: the 3-D image to be recon 
%  startPoint: the first point to recon lead 
%  startSlice: the slice of startPoint
%  radius: the distict radius to make the lead artifact in
% output: 
%   leadVoxel:the lead artifact recon 
leadVoxel=zeros(size(Y));
tempImg=Y(startPoint(2):startPoint(2)+49,startPoint(1):startPoint(1)+49,startSlice);
baseX=startPoint(1);baseY=startPoint(2);

for i=1:startSlice-1
    [locX,locY,A,num]=voxelsOfLead(tempImg);
%     figure,imshow(tempImg,[]);
%     figure,imshow(A,[]);hold on;plot(locX,locY,'*');
    if tempImg(locY,locX)>200
        break;
    end
%     figure,imshow(tempImg,[]);
%     figure,imshow(A);hold on;plot(locX,locY,'*');
    [m,n]=size(A);
    leadVoxel(baseY:baseY+n-1,baseX:baseX+m-1,startSlice-i+1)=A;
    baseX=baseX+locX-round(radius/2);
    baseY=baseY+locY-round(radius/2);
    tempImg=Y(baseY:baseY+radius,baseX:baseX+radius,startSlice-i);    
end

% check whether there is connect between different slices
% pick up all the distict and select the first two district

[L_3D,NUM_3D] = bwlabeln(leadVoxel,26); 

max=0;
indMax=0;
for k=1:NUM_3D
    [y,x]=find(L_3D==k);
    nSize=length(y);
    if (nSize>max)
        max=nSize;
        indMax=k;
    end
end

[y,x]=find(L_3D==indMax);
temImg=zeros(size(leadVoxel));
for i=1:length(y)
    temImg(y(i),x(i))=1;
end
leadVoxel=leadVoxel.*temImg;

