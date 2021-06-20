.386
.model flat,stdcall
option casemap:none

include msvcrt.inc

.data
vara dword 3

.code
gg proc c
	mov eax, 9

	ret
gg endp
end