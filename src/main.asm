.386
.model flat,stdcall
option casemap:none

includelib acllib.lib
include acllib.inc
include msvcrt.inc
include control.inc
include model.inc
include public_var.inc
printf PROTO C:ptr sbyte,:VARARG

.data
winTitle byte "Tetris", 0

.code
main proc c
	invoke init_first  ;初始化绘图环境
	invoke initWindow, offset winTitle, 425, 50, 550, 700 ;左上角的坐标，窗体的宽高
	invoke registerMouseEvent,iface_mouseEvent ;注册控制流事件，注意，如果要定义按钮动作，进入这个函数内进行函数代码的添加
	invoke registerKeyboardEvent, iface_keyboardEvent
	invoke registerTimerEvent, iface_timerEvent
	invoke loadMenu, 0;model.asm
	invoke init_second
main endp
end main