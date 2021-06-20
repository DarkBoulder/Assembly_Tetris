.386
.model flat,stdcall
option casemap:none

include msvcrt.inc

.data
;每个形状的标准方向的编号，用于初始化生成随机俄罗斯方块使用

ifndef __p_v__
__p_v__ equ <>

;放一些多个文件共用的变量
step dword 10
public step
boundaryH dword 20;高度（块数
public boundaryH
boundaryW dword 10;宽度
public boundaryW
Max_Shape dword 19;总方块类别（旋转不同）
public Max_Shape
WINDOW byte 20 * 10 dup(0);窗口大小20块*10块
public WINDOW
init_x dword 4;方块初始x位置
public init_x
init_y dword 0;方块初始y位置
public init_y

currWindow dword 0;当前窗口类别
public currWindow
isTransform dword 0;是否旋转
public isTransform
isToLeft dword 0;是否向左
public isToLeft
isToRight dword 0;是否向右
public isToRight
isGameOver dword 0;游戏结束
public isGameOver
isPause dword 0;暂停
public isPause
score dword 0;分数
public score
seq byte 0, 2, 6, 10, 12, 14, 15;每个方块种类的起始序号，分别为I L J S Z O T
public seq
num dword 0;当前方块的种类编号，共19种
public num
color_num byte 1;颜色编号，空位0 Red1 Blue2 Pink3 Yellow4 Green5 Purple6
public color_num
;结构体数组
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