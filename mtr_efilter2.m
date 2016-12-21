function sy=mtr_efilter2(sx, f, extmod, shift)
% EFILTER2   2D Filtering with edge handling (via extension)
%
%  �ܽ��б�Ե����Ķ�ά�˲���
%   ���ø�ʽ��
%       y=efilter2(x, f, [extmod], [shift])
%
% ����:
%	sx:	
%       ����ͼ��ά��
%	f:	
%        ��ά�˲���
%	extmod:	
%       �������ͣ�Ĭ��Ϊ'per'��
%	shift:	
%       ָ�������ʼ�㣬Ĭ�� [0 0]
%
% ���:
%	y:	
%       ��ͼ������˲��ľ���
%           ���ʽ Y(z1,z2)=X(z1,z2)*F(z1,z2)*z1^shift(1)*z2^shift(2)
%
%   ע�⣺
%   	shift���ô���((size(f)-1)/2)
%       �����ά����������ͬ
%
% See also:	EXTEND2, SEFILTER2

if ~exist('extmod', 'var')
    extmod='per';
end

if ~exist('shift', 'var')
    shift=[0; 0];
end

% ��������
sf=(size(f) - 1) / 2;

[sxext,sz]=mtr_extend2(sx, floor(sf(1)) + shift(1), ceil(sf(1)) - shift(1), ...
	       floor(sf(2)) + shift(2), ceil(sf(2)) - shift(2), extmod);

% ��������ü���Եʹ֮������ͼ��ߴ���ͬ
sy=mtr_conv2(sz,f);
sy=sy*sxext;