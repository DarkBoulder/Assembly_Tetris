.386
.model flat,stdcall
option casemap:none

include acllib.inc
include public_var.inc
include model.inc
include msvcrt.inc

;includelib msvcrt.lib
printf PROTO C:ptr sbyte,:VARARG

.data

menu_start_game_left dword 155
menu_start_game_right dword 395
menu_start_game_up dword 310
menu_start_game_bottom dword 410

menu_exit_game_left dword 155
menu_exit_game_right dword 396
menu_exit_game_up dword 460
menu_exit_game_bottom dword 560

modelMusicBackground byte "..\src\se\background.mp3", 0
modelMusicMove byte "..\src\se\move.mp3", 0
modelMusicLose byte "..\src\se\lose.mp3", 0
modelMusicClear byte "..\src\se\clear.mp3", 0
modelMusicBackgroundP dd 0
modelMusicMoveP dd 1
modelMusicLoseP dd 2
modelMusicClearP dd 3

srcBg byte "..\src\img\background.bmp", 0
srcTitle byte "..\src\img\title.bmp", 0
srcStart byte "..\src\img\start.bmp", 0
srcExit byte "..\src\img\exit.bmp", 0
srcPause byte "..\src\img\pause.bmp", 0
srcGameOver byte "..\src\img\Gameover.bmp", 0
srcBg1 byte "..\src\img\background1.bmp", 0
srcRed byte "..\src\img\red.bmp", 0
srcBlue byte "..\src\img\blue.bmp", 0
srcPink byte "..\src\img\pink.bmp", 0
srcYellow byte "..\src\img\yellow.bmp", 0
srcGreen byte "..\src\img\green.bmp", 0
srcPurple byte "..\src\img\purple.bmp", 0

imgBg ACL_Image <>
imgTitle ACL_Image <>
imgStart ACL_Image <>
imgExit ACL_Image <>
imgPause ACL_Image <>
imgGameOver ACL_Image <>
imgBg1 ACL_Image <>
imgCube ACL_Image <>
imgRed ACL_Image <>
imgBlue ACL_Image <>
imgPink ACL_Image <>
imgYellow ACL_Image <>
imgGreen ACL_Image <>
imgPurple ACL_Image <>

coord sbyte "%d,%d",10,0
now_window sbyte "current Window: %d",10,0
score_text byte 40 DUP(0)
score_len dword 1;用于确定数字放在屏幕的什么位置上
sint byte "%d", 10, 0
cnt dword 0
cur_timer dword 50

.code
;判断点击的坐标是否在矩形框内，是返回1，不是则返回0
is_inside_the_rect proc C uses ebx x:dword,y:dword,left:dword,right:dword,up:dword,bottom:dword
	mov eax,x
	mov ebx,y
	.if	eax <= left
		mov eax,0
	.elseif	eax >= right
		mov eax,0
	.elseif ebx >= bottom
		mov eax,0
	.elseif ebx <= up
		mov eax,0
	.else	
		mov eax,1
	.endif	
	ret
is_inside_the_rect endp
;返回SHAPE[num].shape[i][j]，即当前Cube所在正方形空间中的第i行j列是否有方块
getShape proc c uses ebx ecx i: dword, j: dword
	local four: dword
	mov four, 4
	mov eax, type SHAPE
	mul num
	mov ebx, eax
	mov eax, i
	mul four
	add eax, j
	mov ecx, eax
	xor eax, eax
	mov al, SHAPE[ebx].shape[ecx]
	ret
getShape endp
;返回第i块变化后下个形状的序号，即旋转后对应方块的序号
getNext proc c uses ebx i:dword
	mov eax, type SHAPE
	mul i
	mov bl, SHAPE[eax].next
	xor eax, eax
	mov al, bl
	ret
getNext endp
;Window的第i行第j列
getWindow proc c uses ecx edx i: dword, j: dword
	mov eax, i
	mov ecx, j
	.if eax < 0 || eax >= boundaryH || ecx < 0 || ecx >= boundaryW
		xor eax, eax
		mov al, -1
		ret
	.endif
	mov eax, boundaryW
	mul i
	add eax, j
	mov ecx, eax
	xor eax, eax
	mov al, WINDOW[ecx]
	ret
getWindow endp
;设置WINDOW[i][j]的值
setWindow proc c uses eax ebx ecx edx i: dword, j: dword, val: byte
	mov eax, 10
	mul i
	add eax, j
	mov bl, val
	mov WINDOW[eax], bl
	ret
setWindow endp
;清空Window内的信息，用于重新开始
clearWindow proc c uses eax ebx
	local i: dword, j: dword
	mov eax, boundaryH
	mov ebx, boundaryW
	mov i, 0
	.while i < eax
		mov j, 0
		.while j < ebx
			invoke setWindow, i, j, 0
			inc j
		.endw
		inc i
	.endw
	ret
clearWindow endp
;获取一个0~rand_num - 1范围的数字
getRand proc c uses ecx edx rand_num: dword
	;设置随机种子
	push 0
	call crt_time
	add esp,4
	push eax
	call crt_srand
	add esp,4

	invoke crt_rand
	mov edx, 0
	mov ecx, rand_num
	div ecx
	mov eax, edx;返回余数
	ret
getRand endp
;判断方块下方是否有东西
getIsReachDown proc c uses ebx ecx
	local i: dword, j: dword
	mov i, 0
	.while i < 4
		mov j, 0
		.while j < 4
			invoke getShape, i, j
			.if al == 1
				mov ebx, posi.y
				add ebx, i
				add ebx, 1
				mov ecx, posi.x
				add ecx, j
				invoke getWindow, ebx, ecx
				;sub ebx, boundaryH
				.if al != 0
					mov al, 1
					ret
				.endif
			.endif
			inc j
		.endw
		inc i
	.endw
	mov al, 0
	ret
getIsReachDown endp
;判断方块右方是否有东西
getIsReachRight proc c uses ebx ecx
	local i: dword, j: dword
	mov i, 0
	.while i < 4
		mov j, 0
		.while j < 4
			invoke getShape, i, j
			.if al == 1
				mov ebx, posi.y
				add ebx, i
				mov ecx, posi.x
				add ecx, j
				inc ecx
				invoke getWindow, ebx, ecx
				;sub ebx, boundaryH
				.if al != 0
					mov al, 1
					ret
				.endif
			.endif
			inc j
		.endw
		inc i
	.endw
	mov al, 0
	ret
getIsReachRight endp
;判断当前方块左边有墙或块
getIsReachLeft proc c uses ebx ecx
	local i: dword, j: dword
	mov i, 0
	.while i < 4
		mov j, 0
		.while j < 4
			invoke getShape, i, j
			.if al == 1
				mov ebx, posi.y
				add ebx, i
				mov ecx, posi.x
				add ecx, j
				dec ecx
				invoke getWindow, ebx, ecx
				;sub ebx, boundaryH
				.if al != 0
					mov al, 1
					ret
				.endif
			.endif
			inc j
		.endw
		inc i
	.endw
	mov al, 0
	ret
getIsReachLeft endp
;检测是否碰到下、左、右三个方向，用于检测能否旋转
getIsReachRound proc c uses ebx ecx
	local i: dword, j: dword
	mov i, 0
	.while i < 4
		mov j, 0
		.while j < 4
			invoke getShape, i, j
			.if al == 1
				mov ebx, posi.y
				add ebx, i
				mov ecx, posi.x
				add ecx, j
				invoke getWindow, ebx, ecx
				;下方
				.if al != 0
					mov al, 1
					ret
				.endif

			.endif
			inc j
		.endw
		inc i
	.endw
	mov al, 0
	ret
getIsReachRound endp
;方块落地后存储到WINDOW中
settleCube proc c uses eax ebx edx
	local i: dword, j: dword, c_n: byte
	mov i, 0
	.while i < 4
		mov j, 0
		.while j < 4
			invoke getShape, i, j
			.if al == 1
				;WINDOW[posi.y + i][posi.x + j] = color_num;
				mov ecx, posi.y
				add ecx, i
				mov ebx, posi.x
				add ebx, j
				invoke setWindow, ecx, ebx, color_num;这里如果使用eax会被覆盖掉，因此换成ecx
			.endif
			inc j
		.endw
		inc i
	.endw
	ret
settleCube endp
;数字转字符串，用于输出分数信息
num2str proc c n: dword, string: ptr byte;score -> score_text
	;初始化
	local i: sdword, j: dword, nnum: dword, str_tmp[40]: byte
	local ten: dword
	mov ten, 10
	mov i, 0
	mov j, 0
	mov eax, n
	mov nnum, eax
@@:	;除
	mov eax, nnum
	mov edx, 0
	div ten
	mov ebx, i
	add dl, '0'
	mov str_tmp[ebx], dl;余数，会改变nnum的大小
	mov nnum, eax;商
	inc i
	.while nnum != 0
		jmp @B
	.endw
	dec i
	.while i >= 0
		mov eax, i
		mov bl, str_tmp[eax]
		mov eax, j
		mov ecx, string
		mov [ecx + eax], bl
		inc j
		dec i
	.endw
	mov eax, j
	mov ebx, string
	mov cl, 0
	mov [ebx + eax], cl
	;invoke printf, offset sstring, string
	mov score_len, eax
	ret
num2str endp
;摆烂了，结构体传不进来，有时间再改
;setColorStruct proc c uses eax ebx ecx src: ptr ACL_Image, dst: ptr ACL_Image
;	mov ebx, src
;	mov ecx, dst
;	mov eax, ACL_Image ptr [ebx].width_
;	mov ACL_Image ptr [ecx].width_, eax
;	mov eax, ACL_Image ptr [ebx].height
;	mov ACL_Image ptr [ecx].height, eax
;	mov eax, ACL_Image ptr [ebx].hbitmap
;	mov ACL_Image ptr [ecx].hbitmap, eax
;	ret
;setColorStruct endp
;根据color_num信息获取具体的颜色进来，注意这里的图片信息是已经从辅存载入了，如果每次都重新载入会越玩越卡
setColor proc c uses eax i: byte
	.if i == 1
		mov eax, imgRed.hbitmap
		mov imgCube.hbitmap, eax
		mov eax, imgRed.width_
		mov imgCube.width_, eax
		mov eax, imgRed.height
		mov imgCube.height, eax
		;invoke setColorStruct, offset imgRed, offset imgCube
		;invoke loadImage, offset srcRed, offset imgCube
	.elseif i == 2
		mov eax, imgBlue.hbitmap
		mov imgCube.hbitmap, eax
		mov eax, imgBlue.width_
		mov imgCube.width_, eax
		mov eax, imgBlue.height
		mov imgCube.height, eax
		;invoke setColorStruct, offset imgBlue, offset imgCube
		;invoke loadImage, offset srcBlue, offset imgCube
	.elseif i == 3
		mov eax, imgPink.hbitmap
		mov imgCube.hbitmap, eax
		mov eax, imgPink.width_
		mov imgCube.width_, eax
		mov eax, imgPink.height
		mov imgCube.height, eax
		;invoke setColorStruct, offset imgPink, offset imgCube
		;invoke loadImage, offset srcPink, offset imgCube
	.elseif i == 4
		mov eax, imgYellow.hbitmap
		mov imgCube.hbitmap, eax
		mov eax, imgYellow.width_
		mov imgCube.width_, eax
		mov eax, imgYellow.height
		mov imgCube.height, eax
		;invoke setColorStruct, offset imgYellow, offset imgCube
		;invoke loadImage, offset srcYellow, offset imgCube
	.elseif i == 5
		mov eax, imgGreen.hbitmap
		mov imgCube.hbitmap, eax
		mov eax, imgGreen.width_
		mov imgCube.width_, eax
		mov eax, imgGreen.height
		mov imgCube.height, eax
		;invoke setColorStruct, offset imgGreen, offset imgCube
		;invoke loadImage, offset srcGreen, offset imgCube
	.elseif i == 6
		mov eax, imgPurple.hbitmap
		mov imgCube.hbitmap, eax
		mov eax, imgPurple.width_
		mov imgCube.width_, eax
		mov eax, imgPurple.height
		mov imgCube.height, eax
		;invoke setColorStruct, offset imgPurple, offset imgCube
		;invoke loadImage, offset srcPurple, offset imgCube
	.endif
	ret
setColor endp
;初始化方块
initCube proc c uses eax edx
	;设置初始坐标
	mov eax, init_x
	mov posi.x, eax
	mov eax, init_y
	mov posi.y, eax
	;设置初始块形状
	invoke getRand, 7
	mov edx, eax
	mov eax, 0
	mov al, seq[edx]
	mov num, eax
	;设置初始颜色
	invoke getRand, 6
	inc eax
	mov color_num, al
	invoke setColor, color_num
	ret
initCube endp
;根据位置信息绘制单个方块位置，输入为第i行第j列
printBlock proc c uses eax ebx ecx i: dword, j: dword
	mov ecx, 30
	mov eax, j
	mul ecx
	add eax, 50
	mov ebx, eax
	mov eax, i
	mul ecx
	add eax, 60
	invoke putImageTransparent, offset imgCube, ebx, eax, 30, 30, 0000000h
	ret
printBlock endp
;绘制当前方块
printCube proc c uses eax ebx
	local i: dword, j: dword;i行j列
	mov i, 0
	.while i < 4
		mov j, 0
		.while j < 4
			;SHAPE[num].shape[i][j] == 1 则打印 (posi.y + i, posi.x + j)
			invoke getShape, i, j
			.if eax == 1
				mov eax, posi.y
				add eax, i
				mov ebx, posi.x
				add ebx, j
				invoke printBlock, eax, ebx
			.endif
			inc j
		.endw
		inc i
	.endw
	ret
printCube endp
;根据颜色与位置信息，绘制WINDOW的所有已有块
printWindow proc c uses ebx
	local i: dword, j: dword
	mov i, 0
	mov ebx, i
	.while ebx < boundaryH
		mov j, 0
		mov ebx, j
		.while ebx < boundaryW
			invoke getWindow, i, j
			.if al != 0 && al != -1
				invoke setColor, al
				invoke printBlock, i, j
			.endif
			inc j
			mov ebx, j
		.endw
		inc i
		mov ebx, i
	.endw
	invoke setColor, color_num
	ret
printWindow endp
;处理Cube的状态信息（下落/左/右/旋转），并绘制在相应的位置上
pictureACube proc c
	local i: dword, j: dword, k: sdword
	;每次需要beginPaint
	invoke beginPaint
	invoke clearDevice;清除当前绘画好的窗口信息
	invoke putImageScale, offset imgBg1, 0, 0, 550, 700

	.if isGameOver == 0 && isPause == 0
		invoke printWindow
		.if isTransform == 1;旋转
			mov isTransform, 0
			mov ebx, num
			invoke getNext, num
			mov num, eax
			invoke getIsReachRound
			.if al != 0;碰上了，还原方块序号
				mov num, ebx
			.endif
		.endif
		.if isToLeft == 1;向左移动
			mov isToLeft, 0
			invoke getIsReachLeft
			.if al == 0
				dec posi.x
			.endif
		.endif
		.if isToRight == 1;向右移动
			mov isToRight, 0
			invoke getIsReachRight
			.if al == 0
				inc posi.x
			.endif
		.endif
		invoke printCube

		;检测是否可以消除
		mov ecx, boundaryH
		mov edx, boundaryW
		mov i, 0
		.while i < ecx
			mov j, 0
			.while j < edx;逐行查看是否满了
				invoke getWindow, i, j
				.break .if al == 0
				inc j
			.endw
			;invoke printf, offset sint, j
			mov eax, j
			.if eax == boundaryW;有一行的块满了
				add score, 10
				pushad
				invoke playSound, modelMusicClearP, 0
				popad
				
				;上面的行下移
				mov eax, i
				dec eax
				mov k, eax
				.while k >= 0
					mov j, 0
					.while j < edx
						invoke getWindow, k, j
						inc k
						invoke setWindow, k, j, al
						dec k
						inc j
					.endw
					dec k
				.endw
				mov j, 0
				.while j < edx
					invoke setWindow, 0, j, 0
					inc j
				.endw
			.endif
			inc i
		.endw
		;根据得分进行加速，提高难度
		.if score == 30 && cur_timer == 50
			mov cur_timer, 40
			invoke startTimer, 0, cur_timer
		.elseif score == 60 && cur_timer == 40
			mov cur_timer, 35
			invoke startTimer, 0, cur_timer
		.elseif score == 90 && cur_timer == 35
			mov cur_timer, 30
			invoke startTimer, 0, cur_timer
		.elseif score == 120 && cur_timer == 30
			mov cur_timer, 25
			invoke startTimer, 0, cur_timer
		.elseif score == 150 && cur_timer == 25
			mov cur_timer, 20
			invoke startTimer, 0, cur_timer
		.elseif score == 180 && cur_timer == 20
			mov cur_timer, 15
			invoke startTimer, 0, cur_timer
		.elseif score == 210 && cur_timer == 15
			mov cur_timer, 10
			invoke startTimer, 0, cur_timer
		.endif
	.elseif isGameOver == 1
		invoke putImageScale, offset imgGameOver, 0, 200, 550, 300
	.elseif isPause == 1
		invoke printWindow
		invoke printCube
		invoke putImageScale, offset imgPause, 0, 200, 550, 300
	.endif
	;绘制分数信息
	invoke num2str, score, offset score_text
	mov eax, score_len
	mov ebx, 10
	mul ebx
	mov ebx, 465
	sub ebx, eax
	invoke setTextSize, 50
	invoke setTextBkColor, EMPTY
	invoke paintText, ebx, 80, offset score_text
	invoke endPaint
	ret
pictureACube endp

iface_mouseEvent proc C x:dword,y:dword,button:dword,event:dword
	.if event != BUTTON_DOWN
		ret
	.endif
	.if	currWindow == 0;开始菜单
		;开始菜单的开始键
		invoke is_inside_the_rect,x,y,menu_start_game_left,menu_start_game_right,menu_start_game_up,menu_start_game_bottom
			.if eax == 1
				;invoke printf,offset coord,x,y
				mov currWindow, 1
				mov score, 0
				invoke initCube
				invoke clearWindow
				mov cur_timer, 50
				invoke startTimer, 0, cur_timer
				invoke loadSound, addr modelMusicBackground, addr modelMusicBackgroundP
				invoke loadSound, addr modelMusicMove, addr modelMusicMoveP
				invoke loadSound, addr modelMusicLose, addr modelMusicLoseP
				invoke loadSound, addr modelMusicClear, addr modelMusicClearP
				invoke playSound, modelMusicBackgroundP, 1
				
				invoke loadImage, offset srcBg1, offset imgBg1
				invoke loadImage, offset srcPause, offset imgPause
				invoke loadImage, offset srcGameOver, offset imgGameOver
				invoke loadImage, offset srcRed, offset imgRed
				invoke loadImage, offset srcBlue, offset imgBlue
				invoke loadImage, offset srcPink, offset imgPink
				invoke loadImage, offset srcYellow, offset imgYellow
				invoke loadImage, offset srcGreen, offset imgGreen
				invoke loadImage, offset srcPurple, offset imgPurple

			.endif
		invoke is_inside_the_rect,x,y,menu_exit_game_left,menu_exit_game_right,menu_exit_game_up,menu_exit_game_bottom
			.if eax == 1
				invoke mouseEvent, 1
			.endif
	.endif
	ret
iface_mouseEvent endp

iface_keyboardEvent proc C key:dword,event:dword
	.if currWindow == 1
		.if key == VK_UP
			.if event == KEY_UP
				mov isTransform, 1
			.endif
		.endif
		.if key == VK_LEFT
			.if event == KEY_DOWN
				mov isToLeft, 1
			.endif
		.endif
		.if key == VK_RIGHT
			.if event == KEY_DOWN
				mov isToRight, 1
			.endif
		.endif
		.if key == VK_DOWN
			.if event == KEY_DOWN
				invoke startTimer, 0, 10
			.elseif event == KEY_UP
				invoke startTimer, 0, cur_timer
			.endif
		.endif
		.if key == VK_SPACE
			.if event == KEY_DOWN
				.if isGameOver == 1
					invoke initCube
					mov score, 0
					invoke clearWindow
					mov cur_timer, 50
					invoke startTimer, 0, cur_timer
					pushad
					invoke playSound, modelMusicBackgroundP, 1
					popad
					mov isGameOver, 0
				.elseif isPause == 1
					invoke playSound,modelMusicBackgroundP, 1
					mov isPause, 0
				.elseif isPause == 0
					invoke stopSound, modelMusicBackgroundP
					mov isPause, 1
				.endif
			.endif
		.endif
		.if key == VK_RETURN;回车键
			.if event == KEY_DOWN
				.if isGameOver == 1
					invoke cancelTimer, 0
					invoke stopSound, modelMusicBackgroundP
					mov currWindow, 0
					mov isGameOver, 0
					invoke loadMenu, 0
				.elseif isPause == 1
					invoke cancelTimer, 0
					invoke stopSound, modelMusicBackgroundP
					mov currWindow, 0
					mov isPause, 0
					invoke loadMenu, 0
				.endif
			.endif
		.endif
	.endif
	ret
iface_keyboardEvent endp

iface_timerEvent proc c tid: dword
	.if currWindow != 1
		ret
	.endif
	.if isPause == 0
		inc cnt
	.endif
	.if cnt >= 5
		mov cnt, 0
		invoke getIsReachDown
		;mov al, 0
		.if al == 0
			inc posi.y
		.else
			invoke settleCube
			.if posi.y == 0
				mov isGameOver, 1
				invoke clearWindow
				invoke stopSound, modelMusicBackgroundP
				pushad
				invoke playSound, modelMusicLoseP, 0
				popad
			.endif
			invoke initCube
		.endif
	.endif
	invoke pictureACube
	ret
iface_timerEvent endp

end