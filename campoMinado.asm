.data
	Array:
		.align 2
		.space 400
		
	nw_line: .asciiz"\n" 
	space_line: .asciiz "  "
	option: .asciiz "Precione 1 para marcar um local ou 2 para selecionar um local: "
	menu: .asciiz "====================Minesweeper=================="
	u_line: .asciiz "Insira a linha: "
	u_column: .asciiz "Insira a coluna: "
	
	Grid: #Este sera o grid mostrado ao usuário para a intereração
		.align 0
		.space 100	
		
	defeat_msg_1: .asciiz "==========================================="
	defeat_msg_2: .asciiz "===============VOCÊ PERDEU================="
	invalid_op: .asciiz "Opção Inválida!"
	marks: .asciiz "Numero de marcadores disponíveis: "
	marks_error: .asciiz "Marque um local coberto!"
	
	
	win_msg_1: .asciiz "===============VITÓRIA================="
	win_msg_2: .asciiz "Você marcou todos os locais com bombas, Parabéns!"
.text

	.main:
		jal init_G
		jal init_M
		jal place_bombs
		jal printArray_M
		li $v0, 4
		la $a0, nw_line
		syscall
		jal init_bombs_idicators
		jal printArray_M
		li $v0, 4
		la $a0, nw_line
		syscall
			
		game_menu:		
			li $s1, ' '
			li $s2, '0'
			li $s3, 'B' # marcador de bombas
			move $s6, $zero # Contador de marcações corretas
			li $s7, 10 # numero de marcadores disponíveis
			loop_game_menu:
				li $v0, 4
				la $a0, nw_line
				syscall
				jal printGrid
				move $t0,$zero #$t0 será a flag para o fim do jogo
			
				li $v0, 4
				la $a0, nw_line
				syscall
				
				li $v0, 4
				la $a0, option
				syscall
				
				li $v0, 5
				syscall
				beq $v0, 1, mark_op
				
				beq $v0, 2, selec_op
				
				li $v0, 4
				la $a0, nw_line
				syscall
				
				li $v0, 4
				la $a0, invalid_op
				syscall
				
				li $v0, 10
				syscall
				
						
				
				mark_op:
				
				li $v0, 4
				la $a0, menu
				syscall
			
				li $v0, 4
				la $a0, nw_line
				syscall
				
				li $v0, 4
				la $a0, marks
				syscall
				
				li $v0,1
				move $a0, $s7
				syscall
				
				li $v0, 4
				la $a0, nw_line
				syscall
			
				li $v0, 4
				la $a0, u_line
				syscall  
			
				li $v0, 5
				syscall 
				move $t1, $v0 #Valor da linha inserida ficará no registrador $t1
			
				li $v0, 4
				la $a0, nw_line
				syscall
		
				li $v0, 4
				la $a0, u_column
				syscall
			
				li $v0, 5
				syscall 
				move $t2, $v0 #Valor da coluna inserida ficará no registrador $t2
			
				li $v0, 4
				la $a0, nw_line
				syscall
				
				mul $t1, $t1, 10
				add $t1, $t1, $t2
				
				lb $t2, Grid($t1)
				beq $t2, 'X', print_B
				li $v0, 4
				la $a0, nw_line
				syscall
				li $v0, 4
				la $a0, marks_error
				syscall
				j loop_game_menu
				
				print_B: 
				sb $s3, Grid($t1)
				mul $t1, $t1, 4
				lw $t2, Array($t1)
				subi $s7, $s7, 1
				beq $t2, 9, got_bomb
				beq $s7, 0, verify_win	
				j loop_game_menu
			
				
				got_bomb:
				addi $s6, $s6, 1
				beq $s7, 0, verify_win
				j loop_game_menu
				
				
				
				
				
				
				selec_op:
				
				li $v0, 4
				la $a0, menu
				syscall
			
				li $v0, 4
				la $a0, nw_line
				syscall
			
				li $v0, 4
				la $a0, u_line
				syscall  
			
				li $v0, 5
				syscall 
				move $t1, $v0 #Valor da linha inserida ficará no registrador $t1
			
				li $v0, 4
				la $a0, nw_line
				syscall
		
				li $v0, 4
				la $a0, u_column
				syscall
			
				li $v0, 5
				syscall 
				move $t2, $v0 #Valor da coluna inserida ficará no registrador $t2
			
				li $v0, 4
				la $a0, nw_line
				syscall
				#linha esta no $t1
				#coluna esta no $t2
				#Acesso ao indice informado pelo usuário - Formula: 10.linha +coluna
				#o indice ficará em $t1
				mul $t1, $t1, 10
				add $t1, $t1, $t2
				mul $t6, $t1, 4 #Multiplicar por 4bytes
				
				move $a0, $t6 #argumento do indice da matriz de inteiros para a função
				move $a1, $t1 #argumento do indice da matriz de x para a função
				
				lw $s4, Array($t6)
				beq $s4, 9, end_game
				jal verify_bombs
				
				#$t6 é o indice para a matriz de inteiros
				#$t1 é o indice para a matriz de X
				 
			
				j loop_game_menu
				
			end_game:
				
				sb $s2, Grid($t1)
				jal printGrid_uncovered
				
				li $v0, 4
				la $a0, nw_line
				syscall
				
				li $v0, 4
				la $a0, nw_line
				syscall
				
				li $v0, 4
				la $a0, defeat_msg_1
				syscall
				
				li $v0, 4
				la $a0, nw_line
				syscall
				
				li $v0, 4
				la $a0, defeat_msg_2
				syscall
				
				li $v0, 4
				la $a0, nw_line
				syscall
				
				li $v0, 4
				la $a0, defeat_msg_1
				syscall			
				
			
				li $v0, 10
				syscall 



			verify_win:
			bne  $s6,10, end_game
			li $v0, 4
			la $a0, nw_line
			syscall
			li $v0, 4
			la $a0, defeat_msg_1
			syscall
			li $v0, 4
			la $a0, nw_line
			syscall
			li $v0, 4
			la $a0, win_msg_1
			syscall
			li $v0, 4
			la $a0, nw_line
			syscall
			li $v0, 4
			la $a0, win_msg_2			
			syscall
			li $v0, 4
			la $a0, nw_line
			syscall
			li $v0, 4
			la $a0, defeat_msg_1
			syscall	
			
			li $v0, 10
			syscall 
			
		


	printGrid_uncovered:
	move $t0, $zero #indice
		li $t2, 100 #tamanho matriz completa de char
		li $t3, 10 #tamanho linha char
		li $t4, 0 #contador de linhas
		li $t5, '0'
		loop_printArray_G_u:
				beq $t0, $t2, out_print_G # se chegar em 100, vai para out_print
				beq $t0, $t3, print_line_G # se chegar em $t3, vai para print_line
				mul $t6, $t0, 4
				lw $t6, Array($t6)
				beq $t6, 9, print_0
				
				lb $a0, Grid($t0)
				li $v0, 11
				syscall
				
				li $v0,4
				la $a0,space_line
				syscall
				 
				addi $t0, $t0, 1
				
				j loop_printArray_G_u
			print_0:
				sb $t5, Grid($t0)
				lb $a0, Grid($t0)
				li $v0, 11
				syscall
				
				li $v0,4
				la $a0,space_line
				syscall
				 
				addi $t0, $t0, 1
				
				j loop_printArray_G_u
				
			print_line_G_u:
				
				li $v0,4
				la $a0,space_line
				syscall
				li $v0,4
				la $a0,space_line
				syscall
				
				li $v0,1
				move $a0, $t4
				syscall
				
				addi $t4, $t4, 1 
				
				li $v0, 4
				la $a0, nw_line
				syscall
				
				mul $t6, $t0, 4
				lw $t6, Array($t6)
				beq $t6, 9, print_0_line
				
				lb $a0, Grid($t0)
				li $v0, 11
				syscall
				addi $t0, $t0, 1
			
				
				li $v0,4
				la $a0,space_line
				syscall
				
				addi $t3, $t3, 10
				j loop_printArray_G_u
				
			print_0_line:
				sb $t5, Grid($t0)
				lb $a0, Grid($t0)
				li $v0, 11
				syscall
				
				li $v0,4
				la $a0,space_line
				syscall
				 
				addi $t0, $t0, 1
				li $v0,4
				la $a0,space_line
				syscall
				
				addi $t3, $t3, 10
				
				j loop_printArray_G_u
				
			out_print_G_u:
				
				li $v0,4
				la $a0,space_line
				syscall
				li $v0,4
				la $a0,space_line
				syscall
				li $v0,1
				move $a0, $t4
				syscall
				li $t4, 0 #indice de colunas
				li $t5,10
				li $v0, 4
				la $a0, nw_line
				syscall
				li $v0, 4
				la $a0, nw_line
				syscall
				print_column_u:
					beq $t4, $t5, out_print_column_u
					li $v0,1
					move $a0, $t4
					syscall
					li $v0,4
					la $a0,space_line
					syscall
					addi $t4, $t4, 1 
					j print_column_u
				out_print_column_u:
					jr $ra
	

	verify_bombs:
		#$a0 indice da matriz de inteiros
		#$a1 indice da matriz de chars
		#a2 esta o char da matriz de chars
		#quando o usuário digitar o valor da linha e da coluna, ira abrir se um espaço de 3x3 em volta do indice
		li $t2, '1'
		li $t3, '2'
		li $t5, '3'	
		li $t7, '4'
		li $t8, '5'
		li $t9, '6'
		li $s0, '7'
		move $s5, $zero #contador
		
		lw $t4, Array($a0)
		move $t0, $a1
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_
		
		#verifica qual numero do indice selecionado
		
		
		#Caso Geral
		
		continue_verify_0:	
		#1: ira verificar na esquerda horizontal
		subi $t4, $a0, 4
		subi $t0, $a1,1
		lw $t4, Array($t4) 
		beq $t4, 9, found_bomb
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_
		
		continue_verify_1:
		#2: ira verificar na esquerda inclinada para cima
		
		subi $t4, $a0, 44
		subi $t0, $a1, 11
		lw $t4, Array($t4) 
		beq $t4, 9, found_bomb
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_
		
		continue_verify_2:
		#3: ira verificar na vertical para cima
		subi $t4, $a0, 40
		subi $t0, $a1, 10 
		lw $t4, Array($t4)
		beq $t4, 9, found_bomb
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_
		
		continue_verify_3:
		#4: ira verificar na direita inclinada para cima
		subi $t4, $a0, 36
		subi $t0, $a1, 9 
		lw $t4, Array($t4)
		beq $t4, 9, found_bomb
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_		
		
		continue_verify_4:
		#5: ira verificar na direita horizontal
		addi $t4, $a0,4
		addi $t0, $a1, 1  
		lw $t4, Array($t4)
		beq $t4, 9, found_bomb
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_
		
		continue_verify_5:
		#6: ira verificar na vertical para baixo
		addi $t4, $a0, 40
		addi $t0, $a1, 10 
		lw $t4, Array($t4)
		beq $t4, 9, found_bomb
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_

		continue_verify_6:
		#6: ira verificar na esquerda inclinada para baixo
		addi $t4, $a0, 36
		addi $t0, $a1,9 
		lw $t4, Array($t4)
		beq $t4, 9, found_bomb
		beq $t4, 7, print_7
		beq $t4, 6, print_6
		beq $t4, 5, print_5
		beq $t4, 4, print_4
		beq $t4, 3, print_3
		beq $t4, 2, print_2
		beq $t4, 1, print_1
		beq $t4, 0, print_
			
		print_7:
		addi $s5, $s5, 1
		lb $t4, Grid($t0)
		beq $t4, $s3, no_print 
		sb $s0,Grid($t0) 
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		print_6:
		lb $t4, Grid($t0)
		addi $s5, $s5, 1
		beq $t4, $s3, no_print 
		sb $t9,Grid($t0)
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		print_5:
		lb $t4, Grid($t0)
		addi $s5, $s5, 1
		beq $t4, $s3, no_print
		sb $t8,Grid($t0)
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		print_4:
		lb $t4, Grid($t0)
		addi $s5, $s5, 1
		beq $t4, $s3, no_print
		sb $t7,Grid($t0)
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		print_3:
		lb $t4, Grid($t0)
		addi $s5, $s5, 1
		beq $t4, $s3, no_print
		sb $t5,Grid($t0) 
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		print_2:
		lb $t4, Grid($t0)
		addi $s5, $s5, 1
		beq $t4, $s3, no_print
		sb $t3,Grid($t0)
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		print_1:
		lb $t4, Grid($t0)
		addi $s5, $s5, 1
		beq $t4, $s3, no_print
		sb $t2,Grid($t0) 
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		print_:
		lb $t4, Grid($t0)
		addi $s5, $s5, 1
		beq $t4, $s3, no_print
		sb $s1,Grid($t0)
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		no_print:
		beq $s5, 1, jump_1
		beq $s5, 2, jump_2
		beq $s5, 3, jump_3
		beq $s5, 4, jump_4
		beq $s5, 5, jump_5
		beq $s5, 6, jump_6
		beq $s5, 7, out_verify
		

		found_bomb:
		addi $s5, $s5, 1
		beq $s5, 1, jump_0
		beq $s5, 2, jump_1
		beq $s5, 3, jump_2
		beq $s5, 4, jump_3
		beq $s5, 5, jump_4
		beq $s5, 6, jump_5
		beq $s5, 7, jump_6
		beq $s5, 8, out_verify
		
		
		jump_0:
		j continue_verify_0
		jump_1:
		j continue_verify_1
		
		jump_2:
		j continue_verify_2 
		
		jump_3:
		j continue_verify_3
		
		jump_4:
		j continue_verify_4
		
		jump_5:
		j continue_verify_5
		
		jump_6:
		j continue_verify_6
		
		out_verify:
		jr $ra

	init_M:
		move $t0, $zero #indice
		move $t1, $zero #valor a ser colocado
		li $t2, 400 #tamanho matriz completa
		li $t3, 40 #tamanho linha
		while_M:
			beq $t2, $t0, out_M
			sw $t1, Array($t0)
			addi $t0, $t0, 4
			j while_M
			
		out_M:
			jr $ra
			
			
	printArray_M:
		move $t0, $zero #indice
		move $t1, $zero #valor a ser colocado
		li $t2, 400 #tamanho matriz completa
		li $t3, 40 #tamanho linha
		loop_printArray_M:
				beq $t0, $t2, out_print_M # se chegar em 400, vai para out_print
				beq $t0, $t3, print_line_M # se chegar em $t3, vai para print_line
				li $v0, 1
				lw $a0, Array($t0)
				syscall
				li $v0,4
				la $a0,space_line
				syscall 
				addi $t0, $t0, 4
				j loop_printArray_M
				
			print_line_M:
				li $v0, 4
				la $a0, nw_line
				syscall
				li $v0, 1
				lw $a0, Array($t0)
				syscall
				addi $t0, $t0, 4
				li $v0,4
				la $a0,space_line
				syscall
				addi $t3, $t3, 40
				j loop_printArray_M
			out_print_M:
				jr $ra
			
			
	init_G:
		move $t0, $zero #indice
		li $s1, 'X' #valor a ser colocado
		li $t2, 100 #tamanho matriz completa
		while_G:
			beq $t2, $t0, out_G
			sb $s1, Grid($t0)
			addi $t0, $t0,1
			j while_G
			
		out_G:
			jr $ra
	
	
	printGrid:
		move $t0, $zero #indice
		li $t2, 100 #tamanho matriz completa
		li $t3, 10 #tamanho linha
		li $t4, 0 #contador de linhas
		loop_printArray_G:
				beq $t0, $t2, out_print_G # se chegar em 100, vai para out_print
				beq $t0, $t3, print_line_G # se chegar em $t3, vai para print_line
				
				lb $a0, Grid($t0)
				li $v0, 11
				syscall
				
				li $v0,4
				la $a0,space_line
				syscall
				 
				addi $t0, $t0, 1
				
				j loop_printArray_G
				
			print_line_G:
				
				li $v0,4
				la $a0,space_line
				syscall
				li $v0,4
				la $a0,space_line
				syscall
				
				li $v0,1
				move $a0, $t4
				syscall
				
				addi $t4, $t4, 1 
				
				li $v0, 4
				la $a0, nw_line
				syscall
				
				lb $a0, Grid($t0)
				li $v0, 11
				syscall
				addi $t0, $t0, 1
			
				
				li $v0,4
				la $a0,space_line
				syscall
				
				addi $t3, $t3, 10
				j loop_printArray_G
			out_print_G:
				
				li $v0,4
				la $a0,space_line
				syscall
				li $v0,4
				la $a0,space_line
				syscall
				li $v0,1
				move $a0, $t4
				syscall
				li $t4, 0 #indice de colunas
				li $t5,10
				li $v0, 4
				la $a0, nw_line
				syscall
				li $v0, 4
				la $a0, nw_line
				syscall
				print_column:
					beq $t4, $t5, out_print_column
					li $v0,1
					move $a0, $t4
					syscall
					li $v0,4
					la $a0,space_line
					syscall
					addi $t4, $t4, 1 
					j print_column
				out_print_column:
					jr $ra
	
	place_bombs:
		li $t2, 10 #Limite do numero de bombas
		li $t1,9 #Registrador para guardar o numero 1
		move $t3, $zero # Inicio do indice do loop place_bombs
		loop_place_bombs:
			beq $t2,$t3,out_place_bombs #t$t2 vai ser um contador que irá realizar o loop 10x, para colocar 10 bombas
			randomInt_generator:
			li $a1, 100  #Here you set $a1 to the max bound.
    			li $v0, 42  #generates the random number.
    			syscall
			move $t0,$a0 # esse numero é movido para $t0
			sll $t0, $t0, 2 #Então é multiplicado por 4
			
			lw $t4,Array($t0) #O Valor da posição $t0 é carregado para $t4
			beq $t4,9, loop_place_bombs# Se o valor de $t4 for igual ao $t0, um novo numero aleatório é calculado 
			sw $t1, Array($t0)#
			subi $t2, $t2, 1
			j loop_place_bombs
		out_place_bombs:
			jr $ra
			
	
	init_bombs_idicators:
		li $t0, 400 #tamanho do vetor
		li $s0, 9
		move $t1, $zero #indice
		li $s1, 40 #indice para o caso especial 5
		li $s2, 360 #indice para o caso especial 4
		li $t9, 364 #indice para o caso especial 8
		li $s7, 36 #indice para o caso especial 2 e 3
		li $s3, 396 #indice para o caso especial 6
		li $s4, 76 #indice para o caso especial 7
		init_bombs_idicators_looping:
			beq $t1, $t0,init_bombs_idicators_out 
			 
			#primeiro irá verificar se tem bomba
			lw $s6, Array($t1) #Valor do indice colocado em $s6
			beq $s0, $s6, continue_looping #o inidice selecionado possui uma bomba
			#Casos Especiais
			
			beq $t1, $zero, special_case_1 #indice 0:0
			blt $t1, $s7, special_case_2 # primeira linha
			beq $t1, $s7, special_case_3 # indice 0:9
			beq $t1, $s1, special_case_5# primeira coluna
			beq $t1, $s4, special_case_7 #ultima coluna
			beq $t1, $s2, special_case_4 # indice 9:0
			beq $t1, $t9, special_case_8 #ultima linha
			beq $t1, $s3, special_case_6 #indice 9:9			
			
			#Caso Geral:
			move $s5, $zero #contador de bombas para cada indice
			
			#ira verificar se tem bomba no lado esquerdo inclinado inferior
			addi $t4, $t1, 36
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_g_1
		 	addi $s5, $s5 1
		 	
		 	no_bomb_g_1: 
		 	#ira verificar se tem bomba na vertical para baixo
		 	addi $t4, $t1, 40
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_g_2
		 	addi $s5, $s5, 1
		 	
		 	no_bomb_g_2:
		 	#ira verificar se tem bomba no lado direito inclinado inferior
		 	addi $t4, $t1, 44
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne $t5, $s0, no_bomb_g_3
		 	addi $s5, $s5, 1
			
			
			no_bomb_g_3:
			#horizontal esquerda:
			subi $t4, $t1, 4#Irá verificar se tem bomba no lado esquerdo horizontal
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_g_4
		 	addi $s5, $s5, 1
		 	
		 	no_bomb_g_4:
			
			#inclinado superior esquerdo:
			subi $t4, $t1, 44
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_g_5
		 	addi $s5, $s5, 1
			
			no_bomb_g_5:
			
			#Vertical para cima:
			subi $t4, $t1, 40
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_g_6
		 	addi $s5, $s5, 1
			
			no_bomb_g_6:
			
			#inclinado superior direito:
			subi $t4, $t1, 36
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_g_7
		 	addi $s5, $s5, 1
		 	
		 	no_bomb_g_7:
		 	
		 	#horizontal direita:
		 	addi $t4, $t1, 4
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, end_no_bomb
		 	addi $s5, $s5, 1
		 
			
			end_no_bomb:
			sw $s5, Array($t1)
			addi $t1, $t1, 4
			move $t4, $zero
			j init_bombs_idicators_looping
			
			continue_looping:
			addi $t1, $t1, 4
			move $t4, $zero
			j init_bombs_idicators_looping
			
			init_bombs_idicators_out:
			jr $ra
			
			
			
			
		 special_case_1:
		 	li $t2, 4
		 	li $t3, 44
		 	li $t4, 40
		 	move $t8, $zero #indicador de bombas
		 	
		 	lw $t5, Array($t2)
		 	bne  $t5, $s0, special_case_1_continue_1
		 	addi $t8, $t8, 1
		 	
		 	special_case_1_continue_1:
		 	lw $t5, Array($t3)
		 	bne  $t5, $s0, special_case_1_continue_11
		 	addi $t8, $t8, 1
		 	
		 	special_case_1_continue_11:
		 	lw $t5, Array($t4)
		 	bne  $t5, $s0, special_case_1_continue_10
		 	addi $t8, $t8, 1
		 	
		 	special_case_1_continue_10:
		 	sw $t8, Array($t1)
		 	addi $t1, $t1, 4
		 	j init_bombs_idicators_looping
		 	
		 special_case_2: # primeira linha
		 
		 	
		 	special_case_2_looping:
		 	lw $t3, Array($t1) #valor do indice esta em $t3
		 	
		 	beq $t3, $s0,special_case_2_continue #caso $t3 seja uma bomba, pule
		 	move $t3, $zero
		 	
		 	subi $t4, $t1, 4#Irá verificar se tem bomba no lado esquerdo horizontal
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_1
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_1: #irá verificar se tem bomba no lado esquerdo inclinado
		 	addi $t4, $t1, 36
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_2
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_2: #ira verificar se tem bomba na vertical para baixo
		 	addi $t4, $t1, 40
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_3
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_3: #ira verificar se tem bomba no lado direito inclinado
			addi $t4, $t1, 44
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_4
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_4: #ira verificar se tem bomba no lado direito na horizontal
		 	addi $t4, $t1, 4
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_5
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_5:
		 	sw $t3, Array($t1)
		 	move $t4, $zero
		 	addi $t1, $t1, 4
			j init_bombs_idicators_looping
		 	
		 	special_case_2_continue:
		 	move $t4, $zero
		 	addi $t1, $t1, 4
		 	j init_bombs_idicators_looping
		 	
		 special_case_3:
			li $t2, 32
		 	li $t3, 72
		 	li $t4, 76
		 	move $t8, $zero #iindicador de bombas
		 	
		 	lw $t5, Array($t2)
		 	bne  $t5, $s0, special_case_3_continue_32
		 	addi $t8, $t8, 1
		 	
		 	special_case_3_continue_32:
		 	lw $t6, Array($t3)
		 	bne  $t6, $s0, special_case_3_continue_72
		 	addi $t8, $t8, 1
		 	
		 	special_case_3_continue_72:
		 	lw $t7, Array($t4)
		 	bne  $t7, $s0, special_case_3_continue_76
		 	addi $t8, $t8, 1
		 	
		 	special_case_3_continue_76:
		 	sw $t8, Array($t1)
		 	addi $t1, $t1, 4
		 	j init_bombs_idicators_looping
		 	
		 	
		 special_case_4:
		 	li $t2, 320
		 	li $t3, 324
		 	li $t4, 364
		 	move $t8, $zero #iindicador de bombas
		 	
		 	lw $t5, Array($t2)
		 	bne  $t5, $s0, special_case_4_continue_320
		 	addi $t8, $t8, 1
		 	
		 	special_case_4_continue_320:
		 	lw $t6, Array($t3)
		 	bne  $t6, $s0, special_case_4_continue_324
		 	addi $t8, $t8, 1
		 	
		 	special_case_4_continue_324:
		 	lw $t7, Array($t4)
		 	bne  $t7, $s0, special_case_4_continue_364
		 	addi $t8, $t8, 1
		 	
		 	special_case_4_continue_364:
		 	sw $t8, Array($t1)
		 	addi $t1, $t1, 4
		 	j init_bombs_idicators_looping
		 
		 
		 special_case_5:
		 	special_case_5_looping:
		 	move $t3, $zero
		 	lw $t2, Array($s1) #valor do indice esta em $t2
		 	
		 	beq $t2, $s0,special_case_5_continue #caso $t3 seja uma bomba, saia
		 	
		 	subi $t4, $s1, 40#Irá verificar se tem bomba em cima na vertical
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_5_1
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_5_1: #irá verificar se tem bomba no lado direito inclinado
		 	subi $t4, $s1, 36
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_5_2
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_5_2: #ira verificar se tem bomba na horizontal para a direita
		 	addi $t4, $s1, 4
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_5_3
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_5_3: #ira verificar se tem bomba na inclinada para baixo
		 	addi $t4, $s1, 44
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_5_4
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_5_4:
		 	addi $t4, $s1, 40
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_5_5
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_5_5:
		 	sw $t3, Array($s1)
		 	addi $s1, $s1, 40
		 	beq $s1, $s2, especial_case_4_prolem
		 	addi $t1, $t1, 4
		 	move $t4, $zero
		 	j init_bombs_idicators_looping
		 	
		 	special_case_5_continue:
		 	addi $s1, $s1, 40
		 	beq $s1, $s2, especial_case_4_prolem
		 	addi $t1, $t1, 4
		 	move $t4, $zero
		 	j init_bombs_idicators_looping
		 	
		 	especial_case_4_prolem:
		 	addi $t1, $t1, 4
		 	move $s1, $zero
		 	move $t4, $zero
			j init_bombs_idicators_looping
		 	
		 	
		 special_case_6:
		 	li $t2, 356
		 	li $t3, 352
		 	li $t4, 392
		 	move $t8, $zero #iindicador de bombas
		 	
		 	lw $t5, Array($t2)
		 	bne  $t5, $s0, special_case_6_continue_356
		 	addi $t8, $t8, 1
		 	
		 	special_case_6_continue_356:
		 	lw $t6, Array($t3)
		 	bne  $t6, $s0, special_case_6_continue_352
		 	addi $t8, $t8, 1
		 	
		 	special_case_6_continue_352:
		 	lw $t7, Array($t4)
		 	bne  $t7, $s0, special_case_6_continue_392
		 	addi $t8, $t8, 1
		 	
		 	special_case_6_continue_392:
		 	sw $t8, Array($t1)
		 	addi $t1, $t1, 4
		 	j init_bombs_idicators_looping
		 	
		 special_case_7:
		 	special_case_7_looping:
		 	lw $t3, Array($s4) #valor do indice esta em $t3
		 	
		 	beq $t3, $s0,special_case_7_continue #caso $t3 seja uma bomba, saia
		 	
		 	move $t3, $zero
		 	subi $t4, $s4, 40#Irá verificar se tem bomba em cima na vertical
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_7_1
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_7_1: #irá verificar se tem bomba no lado esquerdo inclinado
		 	subi $t4, $s4, 44
		 	lw $t5, Array($t4)
			move $t4, $zero
		 	bne  $t5, $s0, no_bomb_7_2
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_7_2: #ira verificar se tem bomba na horizontal para a esquerda
		 	subi $t4, $s4, 4
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_7_3
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_7_3: #ira verificar se tem bomba no lado esquerdo inclinado inferior
			addi $t4, $s4, 36
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_7_4
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_7_4: #ira verificar se tem bomba na vertical para baixo
		 	addi $t4, $s4, 40
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_7_5
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_7_5:
		 	sw $t3, Array($s4)
		 	addi $s4, $s4, 40
		 	move $t4, $zero
		 	addi $t1, $t1, 4
			j init_bombs_idicators_looping
		 	
		 	special_case_7_continue:
		 	addi $s4, $s4, 40
		 	addi $t1, $t1, 4
		 	move $t4, $zero
		 	j init_bombs_idicators_looping
		 	
		 	
		 special_case_8:
		 	special_case_8_looping:
		 	move $t3, $zero
		 	
		 	subi $t4, $t1, 4#Irá verificar se tem bomba no lado esquerdo horizontal
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_1_8
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_1_8: #irá verificar se tem bomba no lado esquerdo inclinado
		 	subi $t4, $t1, 44
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_2_8
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_2_8: #ira verificar se tem bomba na vertical para cima
		 	subi $t4, $t1, 40
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_3_8
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_3_8: #ira verificar se tem bomba no lado direito inclinado
			subi $t4, $t1, 36
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_4_8
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_4_8: #ira verificar se tem bomba no lado direito na horizontal
		 	addi $t4, $t1, 4
		 	lw $t5, Array($t4)
		 	move $t4, $zero
		 	bne  $t5, $s0, no_bomb_5_8
		 	addi $t3, $t3, 1
		 	
		 	no_bomb_5_8:
		 	sw $t3, Array($t1)
		 	li $t4, 396
		 	addi $t1, $t1, 4
		 	addi $t9, $t9, 4
		 	beq $t9, $t4, fix_case_8_problem 
			j init_bombs_idicators_looping
			
			fix_case_8_problem:
		 	move $t9, $zero
		 	j init_bombs_idicators_looping
		 	
