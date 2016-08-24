function normalise_nonlinear(fixPath,movePath,fixImg,moveImg,normMat)
% This function is for nonlinear normalise. 
% input: the fixImg and the moveImg. FixImg and moveImg should be the same
%        modulity or sequence.
% function: move the moveImg to the fixImg
% output: w_moveImg is the final  image for use
% ex. normalise_nonlinear('./templates/','./TestData/','avg152T2.nii','anat.nii','norm.mat')
% 2016.08.22 Wansen

spm_normalise([fixPath,fixImg],[movePath,moveImg],normMat);
spm_write_sn([movePath,moveImg], normMat);
