%The code is to trans the MNI to postOp. Two steps:1.trans to the preOp
%space for the nuclei in the preOp is more clear. 2. trans to the postOp to
%reconstruct the electrode

clc,clear,close all;
% Norm the mni to the preopT2, output the wavg152T2
templatePath='./templates/';
dataPath='./TestData/';
normalise_nonlinear(dataPath,templatePath,'anat.nii','avg152T2.nii','norm.mat')
movefile([templatePath,'norm.mat'],dataPath);
movefile([templatePath,'wavg152T2.nii'],dataPath);
%Trans the STN to the preOpSpace
spm_write_sn([templatePath,'gm_mask.nii'], [dataPath,'norm.mat']);
movefile([templatePath,'wgm_mask.nii'],dataPath);
%Trans the preOp to postOp
normalise_nonlinear(dataPath,dataPath,'postop_tra.nii','anat.nii','2norm.mat');
%Trans the template to the postOpSpace
spm_write_sn([dataPath,'wgm_mask.nii'], [dataPath,'2norm.mat']);
spm_write_sn([dataPath,'wavg152T2.nii'], [dataPath,'2norm.mat']);