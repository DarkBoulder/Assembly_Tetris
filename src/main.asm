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
	invoke init_first  ;��ʼ����ͼ����
	invoke initWindow, offset winTitle, 425, 50, 550, 700 ;���Ͻǵ����꣬����Ŀ��
	invoke registerMouseEvent,iface_mouseEvent ;ע��������¼���ע�⣬���Ҫ���尴ť������������������ڽ��к�����������
	invoke registerKeyboardEvent, iface_keyboardEvent
	invoke registerTimerEvent, iface_timerEvent
	invoke loadMenu, 0;model.asm
	invoke init_second
main endp
end main