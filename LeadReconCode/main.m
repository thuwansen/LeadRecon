clc,clear,close all;
dataPath='./TestData/';
V=spm_vol([dataPath,'postop_tra.nii']);
[Y,XYZ]=spm_read_vols(V);

%copy a nii file to recon lead
copyfile([dataPath,'postop_tra.nii'],[dataPath,'myLead.nii']);
myLeadV=spm_vol([dataPath,'myLead.nii']);
[leadY,leadXYZ]=spm_read_vols(myLeadV);
myLeadY=zeros(size(leadY));

% recon the electrode and contacts
leftLeadVoxel=voxelsOfLead3D(Y,[251,201],30,25);
[leftLeadLoc,leftDirection,leftContact]=regress3D(3,30,leftLeadVoxel);

rightLeadVoxel=voxelsOfLead3D(Y,[251,251],30,25);
[rightLeadLoc,rightDirection,rightContact]=regress3D(3,30,rightLeadVoxel);

leadVoxel=leftLeadVoxel|rightLeadVoxel;
spm_write_vol(myLeadV,leadVoxel*1000);

% get the resliced STN nulcei
STNnuclei=reconSTN('./TestData/','wwgm_mask.nii','postop_tra.nii');
[a,b,c]=ind2sub(size(STNnuclei),find(STNnuclei==1));
figure,scatter3(a(:),b(:),c(:),'filled');
hold on;
scatter3(leftContact(:,1),leftContact(:,2),leftContact(:,3),'filled');
hold on;
scatter3(rightContact(:,1),rightContact(:,2),rightContact(:,3),'filled');
