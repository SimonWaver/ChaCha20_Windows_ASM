; data:
align 16
state dd 16 dup(?)
initial_state dd 16 dup(?)
											CHACHA20_QUARTEROUND:		
																; ================
																ADD EAX, EBX 
																XOR EDX, EAX 
																ROL EDX, 16
																
																; ================
																ADD ECX, EDX 
																XOR EBX, ECX 
																ROL EBX, 12 
																
																; ================
																ADD EAX, EBX 
																XOR EDX, EAX 
																ROL EDX, 8
																
																; ================
																ADD ECX, EDX 
																XOR EBX, ECX 
																ROL EBX, 7
																ret
																
												CHACHA20_DOUBLEROUND:
																MOV EAX, [RSI+4*0]
																MOV EBX, [RSI+4*4]
																MOV ECX, [RSI+4*8]
																MOV EDX, [RSI+4*12]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*0], EAX 
																MOV [RSI+4*4], EBX 
																MOV [RSI+4*8], ECX 
																MOV [RSI+4*12], EDX 
																
																; ================
																MOV EAX, [RSI+4*1]
																MOV EBX, [RSI+4*5]
																MOV ECX, [RSI+4*9]
																MOV EDX, [RSI+4*13]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*1], EAX 
																MOV [RSI+4*5], EBX 
																MOV [RSI+4*9], ECX 
																MOV [RSI+4*13], EDX 
																
																; ================
																MOV EAX, [RSI+4*2]
																MOV EBX, [RSI+4*6]
																MOV ECX, [RSI+4*10]
																MOV EDX, [RSI+4*14]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*2], EAX
																MOV [RSI+4*6], EBX
																MOV [RSI+4*10], ECX
																MOV [RSI+4*14], EDX
																
																; ================
																MOV EAX, [RSI+4*3]
																MOV EBX, [RSI+4*7]
																MOV ECX, [RSI+4*11]
																MOV EDX, [RSI+4*15]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*3], EAX
																MOV [RSI+4*7], EBX
																MOV [RSI+4*11], ECX
																MOV [RSI+4*15], EDX

																; ================
																MOV EAX, [RSI+4*0]
																MOV EBX, [RSI+4*5]
																MOV ECX, [RSI+4*10]
																MOV EDX, [RSI+4*15]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*0], EAX
																MOV [RSI+4*5], EBX
																MOV [RSI+4*10], ECX
																MOV [RSI+4*15], EDX

																; ================
																MOV EAX, [RSI+4*1]
																MOV EBX, [RSI+4*6]
																MOV ECX, [RSI+4*11]
																MOV EDX, [RSI+4*12]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*1], EAX
																MOV [RSI+4*6], EBX
																MOV [RSI+4*11], ECX
																MOV [RSI+4*12], EDX

																; ================
																MOV EAX, [RSI+4*2]
																MOV EBX, [RSI+4*7]
																MOV ECX, [RSI+4*8]
																MOV EDX, [RSI+4*13]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*2], EAX
																MOV [RSI+4*7], EBX
																MOV [RSI+4*8], ECX
																MOV [RSI+4*13], EDX

																; ================
																MOV EAX, [RSI+4*3]
																MOV EBX, [RSI+4*4]
																MOV ECX, [RSI+4*9]
																MOV EDX, [RSI+4*14]
																CALL CHACHA20_QUARTEROUND
																MOV [RSI+4*3], EAX
																MOV [RSI+4*4], EBX
																MOV [RSI+4*9], ECX
																MOV [RSI+4*14], EDX
																ret
																
												CHACHA20_20_ROUNDS_ITERATE:
																LEA RSI, [state] 
																LEA RDI, [initial_state] 
																MOV ECX, 16
																REP MOVSD 
																
																MOV R10, 10
															.loop_round_20:
																PUSH R10 
																LEA RSI, [state] 
																CALL CHACHA20_DOUBLEROUND
																POP R10 
																DEC R10 
																JNZ .loop_round_20 
																
																LEA RSI, [state]
																LEA RDI, [initial_state] 
																MOV ECX, 16
															.final_add:
																MOV EAX, [RSI] 
																ADD EAX, [RDI] 
																MOV [RSI], EAX 
																ADD RSI, 4
																ADD RDI, 4
																LOOP .final_add
																ret
													
													
											CHACHA20_INIT:
																LEA RSI, [state]
																MOV dword [RSI + 4*0], 'expa' 
																MOV dword [RSI + 4*1], 'nd 3' 
																MOV dword [RSI + 4*2], '2-by' 
																MOV dword [RSI + 4*3], 'te k' 

																; ================
																
																LEA RBX, [key]         
																MOV EAX, [RBX + 4*0]
																MOV [RSI + 4*4], EAX
																MOV EAX, [RBX + 4*1]
																MOV [RSI + 4*5], EAX
																MOV EAX, [RBX + 4*2]
																MOV [RSI + 4*6], EAX
																MOV EAX, [RBX + 4*3]
																MOV [RSI + 4*7], EAX
																MOV EAX, [RBX + 4*4]
																MOV [RSI + 4*8], EAX
																MOV EAX, [RBX + 4*5]
																MOV [RSI + 4*9], EAX
																MOV EAX, [RBX + 4*6]
																MOV [RSI + 4*10], EAX
																MOV EAX, [RBX + 4*7]
																MOV [RSI + 4*11], EAX
																MOV dword [RSI + 4*12], 1

																LEA RBX, [nonce]     
																MOV EAX, [RBX + 4*0]
																MOV [RSI + 4*13], EAX
																MOV EAX, [RBX + 4*1]
																MOV [RSI + 4*14], EAX
																MOV EAX, [RBX + 4*2]
																MOV [RSI + 4*15], EAX
																ret
																
								
