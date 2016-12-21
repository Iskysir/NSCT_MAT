function sy=mtr_nsdfbdec( sx, dfilter, clevels )
% NSDFBDEC   Nonsubsampled directional filter bank decomposition.
%   ���²��������˲�����ֽ�
%   ���ɶ�����ͼ����ж�����ʽ���²�������ֽ�ľ���
%   ��Ϊ����ͼ������²����������Ʋ�������
%  
%   ���ø�ʽ��    sy=nsdfbdec( sx, dfilter, [clevels] )
%
% ����:
%   sx:
%       ����������ͼ��ά��
%   dfilter:	
%       �ַ��������з���ֽ�ѡ����˲���
%       �������������˲����Ͱ˸�ƽ���ı����˲���
%   clevels:
%       �Ǹ���������Ӧ�ֽ⼶��
%
% OUTPUT:
%	sy:
%       ��Ԫ����
%       ����Ӵ�
%
% See also:     DFILTERS, PARAFILTERS, mtr_nssfbdec.


% Input check
if ~exist('clevels', 'var')
    clevels=0 ;
    sy{1}=sx;
    return;
end
if (clevels ~= round(clevels)) || (clevels < 0)
    error('Number of decomposition levels must be a non-negative integer');
end
if clevels == 0
    % �����зֽ⣬ֱ�����
    sy{1}=sx;    
    return;
end
if ~ischar( dfilter )
    if iscell( dfilter )
        if length( dfilter ) ~= 4
            error('You shall provide a cell of two 2D directional filters and two groups of 2D parallelogram filters!');
        end
    else
        error('You shall provide the name of directional filter or all filters!');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���������˲�����ƽ���ı����˲����ͻ�����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���������ַ��ͣ����߸���
if ischar( dfilter )
    
    % ȡ����ʯ���˲���
    [h1, h2]=dfilters(dfilter, 'd');
    % ���²����߶�Ҫ��
    h1=h1./sqrt(2) ;
    h2=h2./sqrt(2) ;
    
    % ͨ���������ɵ�һ�������˲���
    k1=modulate2(h1, 'c');
    k2=modulate2(h2, 'c'); 
    
    % ͨ����ʯ���˲�������ƽ���ı����˲���
    [f1, f2]=parafilters( h1, h2 ) ;

else

    % k1, k2 Ϊ�����˲���
    k1=dfilter{1} ;
    k2=dfilter{2} ;
    

    % f1, f2 Ϊƽ���ı����˲���
    f1=dfilter{3} ;
    f2=dfilter{4} ;    
end 


% ����������󣬽�ԭ�˲���˳ʱ����ת45��
q1=[1, -1; 1, 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��һ���ֽ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if clevels == 1
    % �ڵ�һ���ֽ��У����������˲����飬�����˲������в���
    [sy{1}, sy{2}]=mtr_nssfbdec( sx, k1, k2 ) ;        
    
else    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ڶ����ֽ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �ڵ�һ���ֽ��У����������˲����飬�����˲������в���
    [sx1, sx2]=mtr_nssfbdec( sx, k1, k2 ) ;

    % �ڵڶ����ֽ��У��������˲������������������õ������˲�����
    [sy{1}, sy{2}]=mtr_nssfbdec( sx, k1, k2, q1 ) ;
    [sy{3}, sy{4}]=mtr_nssfbdec( sx, k1, k2, q1 ) ;
    sy{1}=sy{1}*sx1;
    sy{2}=sy{2}*sx1;
    sy{3}=sy{3}*sx2;
    sy{4}=sy{4}*sx2;

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �������Լ����߼���ķֽ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
    % ���������Ϸֽ�
    for l=3:clevels
        % Ϊ���Ӵ�Ԥ����ռ�
        sy_old=sy;    
        sy=cell(1, 2^l);
	
        % �ϰ�ͨ��
        for k=1:2^(l-2)
            

            % ���㹫ʽ����Minh N. Do�Ĳ�ʿ���ģ���ʽ(3.18)
            
            slk=2*floor( (k-1) /2 ) - 2^(l-3) + 1 ;
            mkl=2*[ 2^(l-3), 0; 0, 1 ]*[1, 0; -slk, 1]; 
            i=mod(k-1, 2) + 1;
            [sy{2*k-1}, sy{2*k}]=mtr_nssfbdec( sx, f1{i}, f2{i}, mkl );
            sy{2*k-1}=sy{2*k-1}*sy_old{k};
            sy{2*k}=sy{2*k}*sy_old{k};
        end	
	
        % �°�ͨ��
        for k=2^(l-2)+1 : 2^(l-1)
            
            % ����s_{(l-1)}(k):
            slk=2 * floor( ( k-2^(l-2)-1 ) / 2 ) - 2^(l-3) + 1 ;
            % �����������
            mkl=2*[ 1, 0; 0, 2^(l-3) ]*[1, -slk; 0, 1]; 
            i=mod(k-1, 2) + 3;
            % ͨ����ͨ���˲������зֽ�
            [sy{2*k-1}, sy{2*k}]=mtr_nssfbdec( sx, f1{i}, f2{i}, mkl );
            sy{2*k-1}=sy{2*k-1}*sy_old{k};
            sy{2*k}=sy{2*k}*sy_old{k};
        end
    end
end