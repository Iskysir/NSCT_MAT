function [sy1, sy2]=mtr_nssfbdec( sx, f1, f2, mup )
% NSSFBDEC   Two-channel nonsubsampled filter bank decomposition with periodic extension.
%   ˫ͨ�����²����˲����������أ�
%   NSSFBDEC �����Ч����ͼ���뾭MUP�����ϲ����ķ����˲���F1��F2����ľ��� 
%   ���²������������Ϊ�Ʋ�������
%  
%   ���ø�ʽ��
%       mtr_nssfbdec( sx, f1, f2, [mup] )
%
% ����:
%   sx:
%       ͼ�����ά��
%	f1:	
%		�ϰ�ͨ���˲���
%	f2:	
%		�°�ͨ���˲���
%   mup:
%       �ϲ������������
%       ������Ӧ�ɷ����ϲ���
%
% ���:
%	sy1:
%       �ϰ��Ӵ��任���� 
%	sy2:
%       �°��Ӵ��任����
%
%
% See also:     EFILTER2, ZCONV2, ZCONV2S.

               

% Check input
if ~exist('mup', 'var')
    % �������ز����о��
    sy1=mtr_efilter2( sx, f1 );
    sy2=mtr_efilter2( sx, f2 );
    return ;
end
% �����ϲ���
if isequal(mup,1)||isequal(mup,eye(2))
    % �������ز����о��
    sy1=mtr_efilter2( sx, f1 );
    sy2=mtr_efilter2( sx, f2 );
    return ;
end

% ��mupΪ�ϲ�������
if isequal(size(mup),[2 2])
% ���ɷ����������
    
    % �������ز�ͬ���ɷ����˲������о��
    sy1=mtr_zconv2( sx, f1, mup );
    sy2=mtr_zconv2( sx, f2, mup );
    
elseif size(mup) == [1, 1]
% �ɷ����������

    % �������ز����о��
    mup=mup * eye(2) ;
    sy1=mtr_zconv2S ( sx, f1, mup );
    sy2=mtr_zconv2S ( sx, f2, mup ); 
        
else
    error('The upsampling parameter should be an integer or two-dimensional integer matrix!');
end



