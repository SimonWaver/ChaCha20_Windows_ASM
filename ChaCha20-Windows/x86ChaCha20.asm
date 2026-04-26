format pe console
entry start
include 'win32ax.inc'

section '.text' code readable executable
start:
					CALL CHACHA20_INIT
					

					PUSH encrypts
					PUSH szFormatMsg
					CALL [printf]
					ADD ESP, 8
					
					CALL CHACHA20_20_ROUNDS_ITERATE
					
					LEA ESI, [state]
					LEA EDI, [encrypts]
					MOV ECX, 16           
				@@:
					MOV AL, [ESI]        
					XOR [EDI], AL         
					INC ESI
					INC EDI
					LOOP @b
					
					PUSH encrypts
					PUSH szFormatMsg
					CALL [printf]
					ADD ESP, 8
					
					CALL [getch]
					PUSH 0
					CALL [ExitProcess]
					
CHACHA20_QUARTEROUND:
					ADD EAX,EBX
					XOR EDX,EAX 
					ROL EDX,16
					
					ADD ECX,EDX 
					XOR EBX,ECX 
					ROL EBX,12
					
					ADD EAX,EBX 
					XOR EDX,EAX 
					ROL EDX, 8
					
					ADD ECX,EDX 
					XOR EBX,ECX 
					ROL EBX, 7
					RET 
					
CHACHA20_DOUBLEROUND:
					LEA ESI,[state]
					MOV EAX, [ESI+4*0]
					MOV EBX, [ESI+4*4]
					MOV ECX, [ESI+4*8]
					MOV EDX, [ESI+4*12]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*0], EAX 
					MOV [ESI+4*4], EBX 
					MOV [ESI+4*8], ECX 
					MOV [ESI+4*12], EDX 
					
					; ================
					MOV EAX, [ESI+4*1]
					MOV EBX, [ESI+4*5]
					MOV ECX, [ESI+4*9]
					MOV EDX, [ESI+4*13]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*1], EAX 
					MOV [ESI+4*5], EBX 
					MOV [ESI+4*9], ECX 
					MOV [ESI+4*13], EDX 
					
					; ================
					MOV EAX, [ESI+4*2]
					MOV EBX, [ESI+4*6]
					MOV ECX, [ESI+4*10]
					MOV EDX, [ESI+4*14]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*2], EAX
					MOV [ESI+4*6], EBX
					MOV [ESI+4*10], ECX
					MOV [ESI+4*14], EDX
					
					; ================
					MOV EAX, [ESI+4*3]
					MOV EBX, [ESI+4*7]
					MOV ECX, [ESI+4*11]
					MOV EDX, [ESI+4*15]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*3], EAX
					MOV [ESI+4*7], EBX
					MOV [ESI+4*11], ECX
					MOV [ESI+4*15], EDX

					; ================
					MOV EAX, [ESI+4*0]
					MOV EBX, [ESI+4*5]
					MOV ECX, [ESI+4*10]
					MOV EDX, [ESI+4*15]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*0], EAX
					MOV [ESI+4*5], EBX
					MOV [ESI+4*10], ECX
					MOV [ESI+4*15], EDX

					; ================
					MOV EAX, [ESI+4*1]
					MOV EBX, [ESI+4*6]
					MOV ECX, [ESI+4*11]
					MOV EDX, [ESI+4*12]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*1], EAX
					MOV [ESI+4*6], EBX
					MOV [ESI+4*11], ECX
					MOV [ESI+4*12], EDX

					; ================
					MOV EAX, [ESI+4*2]
					MOV EBX, [ESI+4*7]
					MOV ECX, [ESI+4*8]
					MOV EDX, [ESI+4*13]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*2], EAX
					MOV [ESI+4*7], EBX
					MOV [ESI+4*8], ECX
					MOV [ESI+4*13], EDX

					; ================
					MOV EAX, [ESI+4*3]
					MOV EBX, [ESI+4*4]
					MOV ECX, [ESI+4*9]
					MOV EDX, [ESI+4*14]
					CALL CHACHA20_QUARTEROUND
					MOV [ESI+4*3], EAX
					MOV [ESI+4*4], EBX
					MOV [ESI+4*9], ECX
					MOV [ESI+4*14], EDX
					ret


CHACHA20_20_ROUNDS_ITERATE:
					PUSH EBP
					PUSH EBX
					PUSH ESI
					PUSH EDI
					LEA ESI,[state]
					LEA EDI,[initial_state]
					MOV ECX,16
					REP MOVSD
					MOV EBX,10
.loop_round_20:
					PUSH EBX
					LEA ESI,[state]
					CALL CHACHA20_DOUBLEROUND
					POP EBX
					DEC EBX
					JNZ .loop_round_20
					LEA ESI,[state]
					LEA EDI,[initial_state]
					MOV ECX,16
@@:
					MOV EAX,[ESI]
					ADD EAX,[EDI]
					MOV [ESI],EAX
					ADD ESI,4
					ADD EDI,4
					LOOP @b
					POP EDI
					POP ESI
					POP EBX
					POP EBP
					RET
CHACHA20_INIT:
					PUSH EBX
					PUSH ESI
					
					LEA ESI,[state]
					MOV dword[ESI+4*0],'expa'
					MOV dword[ESI+4*1],'nd 3'
					MOV dword[ESI+4*2],'2-by'
					MOV dword[ESI+4*3],'te k'
					
					LEA EBX,[key]
					MOV EAX,[EBX+4*0]
					MOV [ESI+4*4],EAX
					MOV EAX,[EBX+4*1]
					MOV [ESI+4*5],EAX
					MOV EAX,[EBX+4*2]
					MOV [ESI+4*6],EAX
					MOV EAX,[EBX+4*3]
					MOV [ESI+4*7],EAX
					MOV EAX,[EBX+4*4]
					MOV [ESI+4*8],EAX
					MOV EAX,[EBX+4*5]
					MOV [ESI+4*9],EAX
					MOV EAX,[EBX+4*6]
					MOV [ESI+4*10],EAX
					MOV EAX,[EBX+4*7]
					MOV [ESI+4*11],EAX
					MOV dword[ESI+4*12],1
					LEA EBX,[nonce]
					MOV EAX,[EBX+4*0]
					MOV [ESI+4*13],EAX
					MOV EAX,[EBX+4*1]
					MOV [ESI+4*14],EAX
					MOV EAX,[EBX+4*2]
					MOV [ESI+4*15],EAX
					
					POP ESI
					POP EBX
					RET

			
section '.data' readable writeable
key db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
    db 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
    db 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17
    db 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
nonce db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02
szFormatMsg db "Message: %s", 10, 0
encrypts db "Test crypto", 0 

align 16
state dd 16 dup(?)
initial_state dd 16 dup(?)

section '.idata' import data readable

    library kernel32, 'KERNEL32.DLL', \
            user32,   'USER32.DLL', \
            msvcrt,   'MSVCRT.DLL'

    include 'API/kernel32.inc'
    include 'API/user32.inc'

    import msvcrt, \
           printf, 'printf', \
           getch,  '_getch'  
