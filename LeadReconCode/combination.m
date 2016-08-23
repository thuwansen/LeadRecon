function combination(P,referImg)
% 本函数基于SPM8，用于融合不同方向的脑图，并重采样。在术后或者术前扫描PD患者
% STN部位时为了节省时间，通常在轴状位、冠状位、矢状位分别进行少量层的扫描。
% 本函数用于将三者融合。
% 输入：P是一个元组，内容为需要组合的不同位置的图像，referImg是参考图像，
%       是重采样的模板，最终图像输出的分辨率与referImg的相同。
% 输出：最终输出fusion_*.nii文件，是重建后的图像
% 使用示范：
%   P={'postop_T2_axis.nii';'postop_T2_sag.nii';'postop_T2_cor.nii'};
%   referImg='T2MNI_2mm.nii';
%   A=combination(P,referImg);
% 作者：万森20160823

%% 首先将参考图片分割为参考图像referImg相同的体素
resliceName{1}=referImg;
resliceName(2:length(P)+1)=P(1:length(P));
flags = struct('interp',1,'mask',0,'mean',0,'which',1,'wrap',[0 0 0]',...
                   'prefix','r');
spm_reslice(resliceName,flags);

%% 将三个位置的图像进行realign校准
realignName={['r',P{1}];['r',P{2}];['r',P{3}]};
flags = struct('quality',1,'fwhm',5,'sep',4,'interp',2,'wrap',[0 0 0],'rtm',0,'PW','','graphics',1,'lkp',1:6);
deformationMat=spm_realign(realignName,flags);
for i=2:length(realignName)
    V=spm_vol(realignName{i});
    Y=spm_read_vols(V);
    V.mat=deformationMat{1,i}.mat;
    spm_write_vol(V,Y);
end

%% 将三个图像进行融合，以第一个图像为基准
fusionName=realignName;
V_base=spm_vol(fusionName{1});
Y_base=spm_read_vols(V_base);
Y_mask=Y_base;
for i=2:length(fusionName)
    V_temp=spm_vol(fusionName{i});
    Y_temp=spm_read_vols(V_temp);
    mask1=Y_mask;
    mask1(mask1~=0)=1;
    mask1(mask1~=1)=0;
    mask2=Y_temp;
    mask2(mask2~=0)=1;
    mask2(mask2~=1)=0;
    mask=mask2-mask2.*mask1;
    Y_mask=Y_mask+Y_temp.*mask;
end
copyfile(fusionName{1},['fusion_',fusionName{1}]);
V=spm_vol(['fusion_',fusionName{1}]);
spm_write_vol(V,Y_mask);