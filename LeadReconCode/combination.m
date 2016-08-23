function combination(P,referImg)
% ����������SPM8�������ںϲ�ͬ�������ͼ�����ز����������������ǰɨ��PD����
% STN��λʱΪ�˽�ʡʱ�䣬ͨ������״λ����״λ��ʸ״λ�ֱ�����������ɨ�衣
% ���������ڽ������ںϡ�
% ���룺P��һ��Ԫ�飬����Ϊ��Ҫ��ϵĲ�ͬλ�õ�ͼ��referImg�ǲο�ͼ��
%       ���ز�����ģ�壬����ͼ������ķֱ�����referImg����ͬ��
% ������������fusion_*.nii�ļ������ؽ����ͼ��
% ʹ��ʾ����
%   P={'postop_T2_axis.nii';'postop_T2_sag.nii';'postop_T2_cor.nii'};
%   referImg='T2MNI_2mm.nii';
%   A=combination(P,referImg);
% ���ߣ���ɭ20160823

%% ���Ƚ��ο�ͼƬ�ָ�Ϊ�ο�ͼ��referImg��ͬ������
resliceName{1}=referImg;
resliceName(2:length(P)+1)=P(1:length(P));
flags = struct('interp',1,'mask',0,'mean',0,'which',1,'wrap',[0 0 0]',...
                   'prefix','r');
spm_reslice(resliceName,flags);

%% ������λ�õ�ͼ�����realignУ׼
realignName={['r',P{1}];['r',P{2}];['r',P{3}]};
flags = struct('quality',1,'fwhm',5,'sep',4,'interp',2,'wrap',[0 0 0],'rtm',0,'PW','','graphics',1,'lkp',1:6);
deformationMat=spm_realign(realignName,flags);
for i=2:length(realignName)
    V=spm_vol(realignName{i});
    Y=spm_read_vols(V);
    V.mat=deformationMat{1,i}.mat;
    spm_write_vol(V,Y);
end

%% ������ͼ������ںϣ��Ե�һ��ͼ��Ϊ��׼
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