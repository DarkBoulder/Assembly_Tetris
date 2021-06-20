.386
.model flat,stdcall
option casemap:none

include acllib.inc
include msvcrt.inc
include public_var.inc
include model.inc

;includelib msvcrt.lib

printf PROTO C:ptr sbyte,:VARARG

.data
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

imgBg ACL_Image <>
imgTitle ACL_Image <>
imgStart ACL_Image <>
imgExit ACL_Image <>

score_text byte 40 DUP(0)
score_len dword 1;����ȷ�����ַ�����Ļ��ʲôλ����

type_info sbyte "%d,%d",10,0
sstring byte "%s", 0

.code
;������귵�ص���Ϣ���ò�ͬ���¼�
mouseEvent proc C windowType:dword
	pushad
	.if currWindow == 0 && windowType == 0;��ʼ��Ϸ
		;invoke printf, offset type_info, currWindow, windowType
		invoke loadMenu, 1
	.elseif currWindow == 0 && windowType == 1;�˳���Ϸ
		invoke crt_exit, 0
	.endif
	popad
	ret
mouseEvent endp
;����ҳ����Ϣ
loadMenu proc c uses ebx win_num: dword
	mov ebx, win_num
	mov currWindow, ebx	
	
	cmp ebx, 0  
	jz mainwindow	

mainwindow:
	invoke loadImage, offset srcBg, offset imgBg
	invoke loadImage, offset srcTitle, offset imgTitle
	invoke loadImage, offset srcStart, offset imgStart
	invoke loadImage, offset srcExit, offset imgExit

	invoke beginPaint
	invoke putImageScale, offset imgBg, 0, 0, 550, 700
	invoke putImageScale, offset imgTitle, 100, 110, 380, 100
	invoke putImageScale, offset imgStart, 145, 310, 260, 90
	invoke putImageScale, offset imgExit, 145, 460, 260, 90
	invoke endPaint
	ret
loadMenu endp

end