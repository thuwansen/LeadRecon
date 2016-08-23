clc,clear,close all;

% 将T2MNI配准到术前T2像
normalise_nonlinear('../rawData/','../rawData/','preop_T2.nii','T2MNI_norm.nii','MNI2preop.mat');
% 将STN模板用相同的变换矩阵配准到术前T2
spm_write_sn('../rawData/MNI_STN.nii','../rawData/MNI2preop.mat');

% 将术后CT配准到术前T2
coreg_linear('../rawData/','preop_T2.nii','postop_CT.nii','rpostop_CT.nii');
% 重建电极路径
spm_reslice({'../rawData/rpostop_CT.nii';'../rawData/preop_T2.nii'});

