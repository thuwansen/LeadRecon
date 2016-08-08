function STNnuclei=reconSTN(STNPath,STNName,postopName)

%reslice the STN nuclei to the postOp space

P={[STNPath,postopName];[STNPath,STNName]};
% flag={true;false;1;2;[0 0 0];'r'};
spm_reslice(P);

V_gm2=spm_vol([STNPath,'r',STNName]);
STNnuclei=spm_read_vols(V_gm2);
STNnuclei(STNnuclei>0.2)=1;
STNnuclei(STNnuclei~=1)=0;
spm_write_vol(V_gm2,STNnuclei);