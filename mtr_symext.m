function [sy,s_x]=mtr_symext(sx,sh,shift)

% symext - ���ɾ��󣬶�ͼ����о�������
% ���ø�ʽ 
%   sy=symext(sx,sh,shift)
%
% ���룺
%   sx:
%       ͼ��ά����Ϣ
%   sh:
%       �˲���ά����Ϣ
%   shift:
%       �������ƫ��
%
% �����
%   sy:
%       �任����
%
%   ԭ��
% �Ծ��� AXB=C�� 
% ��  kron(B',A) * vec(X) = vec(AXB) = vec(C)





cc=floor(sh/2)-shift+1;

P=eye(sx(2));
P2=[fliplr(P(:,1:cc(1))) P  P(:,sx(2):-1:sx(2)-sh(1)-shift(1)+1)];
P=eye(sx(1));
P1=[flipud(P(1:cc(2),:));P;P(sx(1):-1:sx(1)-sh(2)-shift(2)+1,:)];


Q1=eye(sx(1)+sh(1)-1);
Q1(sx(1)+sh(1)-1,size(P1,1))=0;
Q2=eye(sx(2)+sh(2)-1);
Q2(size(P2,2),sx(2)+sh(2)-1)=0;

R1=sparse(Q1*P1);
R2=sparse(P2*Q2);

sy=kron(R2',R1);
s_x=[size(Q1,1),size(Q2,2)];




end
