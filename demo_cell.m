% demo
% ����ʾ��32*32��ͼ��������3��NSCT�任
% �����Ϊ��Ԫ���飬���Ӵ�����˳���mtr_nsctdec,��Contourlet�����Ч
%
% ��ͨ���޸�len_cut�����޸Ĳü�ͼ�����Ĵ�С�ʹ���λ��



len_cut=1:32;
sz=size(len_cut,2);
sz=[sz,sz];
x=imread('zoneplate.png');
x=im2double(x);
x=x(len_cut,len_cut);

T=mtr_nsctdec(sz,3);% ��ȡ�任����
y=getnsct(x,T);% ���ݱ任�������ɺ���ͨ�Ӵ��ʹ�ͨ�����Ӵ��ĵ�Ԫͼ�����




