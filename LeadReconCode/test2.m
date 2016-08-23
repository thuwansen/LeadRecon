clc,clear,close all;

% ��T2MNI��׼����ǰT2��
normalise_nonlinear('../rawData/','../rawData/','preop_T2.nii','T2MNI_norm.nii','MNI2preop.mat');
% ��STNģ������ͬ�ı任������׼����ǰT2
spm_write_sn('../rawData/MNI_STN.nii','../rawData/MNI2preop.mat');

% ������CT��׼����ǰT2
coreg_linear('../rawData/','preop_T2.nii','postop_CT.nii','rpostop_CT.nii');
% �ؽ��缫·��
spm_reslice({'../rawData/rpostop_CT.nii';'../rawData/preop_T2.nii'});

