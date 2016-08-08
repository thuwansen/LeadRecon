function coreg_linear(fileDir,fixImg,moveImg,newImg)
% This function is writen by Wansen based on spm8
%input: fileDir: the path of image to be processed,fixImg,moveImg,and the
%       name of newImg
%function:coregist the moveImg to fixImg in a linear way, name of new image
%         is newImg
%output:newImg that has been coregisted to fixImg
%2016.07.22 Wansen


OrigionalPath=cd;
cd (fileDir);
copyfile(moveImg,newImg);
V_newImg=spm_vol(newImg);
V_fixImg=spm_vol(fixImg);
x = spm_coreg(V_newImg,V_fixImg);
V_newImg.mat=spm_matrix(x(:)')*V_newImg.mat;
V=spm_read_vols(V_newImg);
spm_write_vol(V_newImg,V);
cd (OrigionalPath);