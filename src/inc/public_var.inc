;位置信息，左上角的坐标
Pstruct struct
	y dword ?;垂直位置
	x dword ?;水平位置
Pstruct ends

;形状信息结构体
Sstruct struct
	shape byte 16 dup(?)
	next byte ?
Sstruct ends

ifndef __p_v__
__p_v__ equ <>
extrn currWindow: dword
extrn isTransform: dword
extrn isToLeft: dword
extrn isToRight: dword
extrn isGameOver: dword
extrn isPause: dword
extrn score: dword
extrn seq: byte
extrn num: dword
extrn posi: Pstruct
extrn SHAPE: Sstruct
extrn WINDOW: byte
extrn boundaryH: dword
extrn boundaryW: dword
extrn step: dword
extrn Max_Shape: dword
extrn init_x: dword
extrn init_y: dword
extrn color_num: byte

endif

