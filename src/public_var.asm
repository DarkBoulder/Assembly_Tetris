.386
.model flat,stdcall
option casemap:none

include msvcrt.inc

.data
;ÿ����״�ı�׼����ı�ţ����ڳ�ʼ�������������˹����ʹ��

ifndef __p_v__
__p_v__ equ <>

;��һЩ����ļ����õı���
step dword 10
public step
boundaryH dword 20;�߶ȣ�����
public boundaryH
boundaryW dword 10;���
public boundaryW
Max_Shape dword 19;�ܷ��������ת��ͬ��
public Max_Shape
WINDOW byte 20 * 10 dup(0);���ڴ�С20��*10��
public WINDOW
init_x dword 4;�����ʼxλ��
public init_x
init_y dword 0;�����ʼyλ��
public init_y

currWindow dword 0;��ǰ�������
public currWindow
isTransform dword 0;�Ƿ���ת
public isTransform
isToLeft dword 0;�Ƿ�����
public isToLeft
isToRight dword 0;�Ƿ�����
public isToRight
isGameOver dword 0;��Ϸ����
public isGameOver
isPause dword 0;��ͣ
public isPause
score dword 0;����
public score
seq byte 0, 2, 6, 10, 12, 14, 15;ÿ�������������ʼ��ţ��ֱ�ΪI L J S Z O T
public seq
num dword 0;��ǰ����������ţ���19��
public num
color_num byte 1;��ɫ��ţ���λ0 Red1 Blue2 Pink3 Yellow4 Green5 Purple6
public color_num
;�ṹ������
endif

include public_var.inc

posi Pstruct < 0, 4 >
public posi

SHAPE Sstruct < < 0, 1, 0 ,0,\
				  0, 1, 0 ,0,\ 
				  0, 1, 0 ,0,\ 
				  0, 1, 0 ,0 >, 1 >,;I
			  < < 0, 0, 0 ,0,\
				  0, 0, 0 ,0,\ 
				  1, 1, 1 ,1,\ 
				  0, 0, 0 ,0 >, 0 >,
			  < < 0, 1, 0 ,0,\
				  0, 1, 0 ,0,\ 
				  0, 1, 1 ,0,\ 
				  0, 0, 0 ,0 >, 3 >;L
	  Sstruct < < 0, 0, 0 ,0,\
				  1, 1, 1 ,0,\ 
				  1, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 4 >,
			  < < 1, 1, 0 ,0,\
				  0, 1, 0 ,0,\ 
				  0, 1, 0 ,0,\ 
				  0, 0, 0 ,0 >, 5 >,
			  < < 0, 0, 1 ,0,\
				  1, 1, 1 ,0,\ 
				  0, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 2 >
	  Sstruct < < 0, 1, 0 ,0,\
				  0, 1, 0 ,0,\ 
				  1, 1, 0 ,0,\ 
				  0, 0, 0 ,0 >, 7 >,;J
			  < < 1, 0, 0 ,0,\
				  1, 1, 1 ,0,\ 
				  0, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 8 >,
			  < < 0, 1, 1 ,0,\
				  0, 1, 0 ,0,\ 
				  0, 1, 0 ,0,\ 
				  0, 0, 0 ,0 >, 9 >
	  Sstruct < < 0, 0, 0 ,0,\
				  1, 1, 1 ,0,\ 
				  0, 0, 1 ,0,\ 
				  0, 0, 0 ,0 >, 6 >,
			  < < 1, 0, 0 ,0,\
				  1, 1, 0 ,0,\ 
				  0, 1, 0 ,0,\ 
				  0, 0, 0 ,0 >, 11 >,;S
			  < < 0, 1, 1 ,0,\
				  1, 1, 0 ,0,\ 
				  0, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 10 >
	  Sstruct < < 0, 1, 0 ,0,\
				  1, 1, 0 ,0,\ 
				  1, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 13 >,;Z
			  < < 1, 1, 0 ,0,\
				  0, 1, 1 ,0,\ 
				  0, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 12 >,
			  < < 1, 1, 0 ,0,\
				  1, 1, 0 ,0,\ 
				  0, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 14 >,;O
			  < < 0, 1, 0 ,0,\
				  1, 1, 1 ,0,\ 
				  0, 0, 0 ,0,\ 
				  0, 0, 0 ,0 >, 16 >;T
	 Sstruct  < < 0, 1, 0 ,0,\
				  0, 1, 1 ,0,\ 
				  0, 1, 0 ,0,\ 
				  0, 0, 0 ,0 >, 17 >,
			  < < 0, 0, 0 ,0,\
				  1, 1, 1 ,0,\ 
				  0, 1, 0 ,0,\ 
				  0, 0, 0 ,0 >, 18 >,
			  < < 0, 1, 0 ,0,\
				  1, 1, 0 ,0,\ 
				  0, 1, 0 ,0,\ 
				  0, 0, 0 ,0 >, 15 >
public SHAPE

end