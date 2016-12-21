function [sylo, syhi] = mtr_nsfbdec( sx, h0, h1, lev )

%  nsfbdec - computes the ns pyramid decomposition 
%   ����n����ʽ�ֽ�ľ���
%  ���ø�ʽ y = nsfbdec(x,h0,h1,L)
%  ����: 
%   sx: 
%       ��ϸ�߶�ͼ���ά��
%   h0, h1��
%       ͨ��'atrousfilters' ���ɵ�atrous�˲���
%  ���: 
%   sylo��
%      ���Գ߶ȵ�ͼ��
%   syhi:
%       ��ϸ�߶ȵ�ͼ��
% 

%   SEE ALSO: ATROUSREC, ATROUSFILTERS

% ͨ�����²�����ʽ�ֽ⣬�� x �ֽ�Ϊ�ȴ�С�ĸ�Ƶ�͵�Ƶ����
% ���˲��������ϲ������Ƕ�����ͼ������²���


 
if lev ~= 0 
    I2 = eye(2); 
    shift = -2^(lev-1)*[1,1] + 2; % �ӳٲ���
    L=2^lev;
    %***********************************************
    % �������ڳ߶ȣ����˲��������ϲ���
    h_0=mtr_upsample2df(h0,lev);
    h_1=mtr_upsample2df(h1,lev);
    % �����˲����ĳ�����������ݽ��жԳ�����
    sh_0=size(h_0);
    sh_1=size(h_1);
    [sy_lo,sx0]=mtr_symext(sx,sh_0,shift);
    [sy_hi,sx1]=mtr_symext(sx,sh_1,shift);
    % �Ծ����Գ����ص����ݽ��о����ȥ����Ե��ʹ���ͬ�����С��ͬ
    % ������һ��������ά����Ϣ
    sylo=mtr_atrousc(sx0,h0,I2 * L);
    syhi=mtr_atrousc(sx1,h1,I2 * L); 
else
    % ��һ���ֽ⣬���˲��������ϲ���
    % ֱ�Ӷ�����ͼ��Գ����أ�����ȫ���
    shift = [1, 1]; % �ӳٲ���
    sh0=size(h0);
    sh1=size(h1);
    [sy_lo,sx0]=mtr_symext(sx,sh0,shift);
    [sy_hi,sx1]=mtr_symext(sx,sh1,shift);
    sylo=mtr_conv2(sx0,h0);
    syhi=mtr_conv2(sx1,h1);

end
% ��ÿ�������˲����
sylo=sylo*sy_lo;
syhi=syhi*sy_hi;
  

