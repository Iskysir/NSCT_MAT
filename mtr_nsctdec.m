function sy=mtr_nsctdec(sz, levels, dfilt, pfilt )
% NSSCDEC   Nonsubsampled Contourlet Transform Decomposition
% ���²����������任_�ֽⲿ��
%
% ���ø�ʽ	sy=nsctdec(sx, levels, [dfilt, pfilt] )
%
% ����:
%
%   sz:      
%       �����������άͼ������ά��
%   levels:  
%       ��������ÿ����ʽ�ֽ��Ӧ�ķ���ֽ������Ӵ��Ե���ϸ��
%       ��ֽ⼶��Ϊ0������ж�άС���ٽ����
%   dfilt:  
%       �ַ��������з���ֽ�ѡ����˲���
%       Ĭ��ѡ�� 'dmaxflat7'
%       ��� dfilters.m
%   pfilt:  
%       �ַ�����������ʽ�ֽ�ѡ����˲���
%       Ĭ��ѡ�� 'maxflat'
%       ��� 'atrousfilters.m'
%
%
% ���:
%
%   sy:  
%       ��Ԫ��������
%       ������ͼ����з��²����������ֽ�ľ���
%       y{1}Ϊ��ͨ�Ӵ����б任�ľ���
%       ������Ԫ�ֱ�Ϊ�ò���ʽ�ֽ��Ӧ�Ĵ�ͨ�����Ӵ����б任�ľ���
%
% ���з�ʽ��
%   ������ nlevs=[l_J,...,l_2, l_1]��l_j >= 2.
%   Then for ������ʽ�ֽ� j=1,...,J�Լ�ÿ����ʽ�ֽ��Ӧ�ķ���ֽ����� k=1,...,2^l_j 
%       ��Ԫ�������Ϊ��
%           y{J+2-j}{k}(n_1, n_2)
%       ��Ӧ���������ֽ�ϵ��Ϊ2^j,�������Ϊk
%       (n_1 * 2^(j+l_j-2), n_2 * 2^j) ��Ӧ k <= 2^(l_j-1), 
%       (n_1 * 2^j, n_2 * 2^(j+l_j-2)) ��Ӧ k > 2^(l_j-1).
%   ��� k ��1 �� 2^l_j��Ӧ�ķ���Ϊ��135�㿪ʼ
%   ���� k <= 2^(l_j-1)Ϊ˳ʱ����ת90��
%   ���� k > 2^(l_j-1)Ϊ��ʱ����ת90��
%   ���μ�����Fig. 3.(b)��
%
% See also:	ATROUSFILTERS, DFILTERS, NSCTREC, NSFBDEC, NSDFBDEC.



% �ж������Ƿ���Ч
%�ж����� levels �Ƿ�Ϊ��
if ~isnumeric( levels )
    error('The decomposition levels shall be integers');
end
if isnumeric( levels )
    % �ж����� levels �Ƿ�Ϊ����
    if round( levels ) ~= levels
        error('The decomposition levels shall be integers');
    end
end

% ������ʽ�ֽ��뷽��ֽ�ѡ����˲������ͣ���û�����룬ת��Ĭ��ֵ
if ~exist('dfilt', 'var')
    dfilt='dmaxflat7' ;
end;

if ~exist('pfilt', 'var')
    pfilt='maxflat' ; 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������˲�����ƽ���ı����˲�������ʽ�˲���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������Ԫ����
filters=cell(4,1) ;
% ȡ����ʯ���˲���
[h1, h2]=dfilters(dfilt, 'd');
% ���ݷ��²���Ҫ��ı�߶�
h1=h1./sqrt(2) ;
h2=h2./sqrt(2) ;

% ͨ���������������˲���
filters{1}=modulate2(h1, 'c');
filters{2}=modulate2(h2, 'c'); 
 

% ��ʯ���˲�����ͨ�����б任������ƽ���ı����˲���
[filters{3}, filters{4}]=parafilters( h1, h2 ) ;

%�� h1,h2 ���¸�ֵ
[h1, h2, ~, ~]=atrousfilters(pfilt); 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���²����������任
% ��״�˲�����
% ���²�����ʽ�ṹ���ж�߶ȷֽ�
% ���²��������˲�������ж෽��ֽ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% �ֽ⼶��
clevels=length( levels ) ;
nIndex=clevels + 1 ;
% ��ʼ�����
sy=cell(1, nIndex) ;

% ��ʼ��ÿ���ͨ�����Ա����
sxlo=speye(sz(1)*sz(2));


% ���²�����ʽ�ֽ�
for i= 1 : clevels   
    
    
    % ���²����������任
    % ���²�����ʽ�ֽ�
    [sx_lo, sx_hi]=mtr_nsfbdec(sz, h1, h2, i-1) ;
    
    sxhi=sx_hi*sxlo;
        
    if levels(nIndex-1) > 0     
        % �Դ�ͨͼ����з��²�������ֽ�
        sx_dir=mtr_nsdfbdec(sz, filters, levels(nIndex-1));
        sxhi_dir=cell(size(sx_dir));
        for i=1:size(sx_dir,2)
            sxhi_dir{i}=sx_dir{i}*sxhi;
        end
        
        sy{nIndex}=sxhi_dir ;
    else
        % ֱ�ӱ�����
        sy{nIndex}=sx_hi ;
    end
    
    % ���·��²�����������ϵ��
    nIndex=nIndex - 1 ;
    
    % ׼����һ�ε���
    sxlo=sx_lo*sxlo;
end

% ��ͨ����
sy{1}=sxlo;