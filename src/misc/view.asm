.386
.model flat,stdcall
option casemap:none

include acllib.inc
include public_var.inc

.data
srcBg byte "..\src\img\background.bmp", 0
srcTitle byte "..\src\img\title.bmp", 0
srcStart byte "..\src\img\start.bmp", 0
srcExit byte "..\src\img\exit.bmp", 0

imgBg ACL_Image <>
imgTitle ACL_Image <>
imgStart ACL_Image <>
imgExit ACL_Image <>

.code
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

initGameWindow proc C
	ret
initGameWindow endp
end