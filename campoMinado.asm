.data
	Array:
		.align 2
		.space 400
		
	nw_line: .asciiz"\n" 
	space_line: .asciiz "  "
	menu: .asciiz "====================Minesweeper=================="
	u_line: .asciiz "Insira a linha: "
	u_column: .asciiz "Insira a coluna: "
	
	Grid: #Este sera o grid mostrado ao usuário para a intereração
		.align 0
		.space 100
	bomb: .byte'O'	
.text

	.main:
		jal init_G
		jal init_M
		jal place_bombs
			
		game_menu:		
			li $t4, 3
			li $t5, 1
			li $s1, ' '
			li $s2, 'o'
			loop_game_menu:
				li $s0, 1
				beq $t0, $s0, end_game	
				li $v0, 4
				la $a0, nw_line
				syscall
				jal printGrid
				move $t0,$zero #$t0 será a flag para o fim do jogo
			
				li $v0, 4
				la $a0, nw_line
				syscall
			
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
				
				#Acesso ao indice informado pelo usuário - Formula: linha + coluna + (3.linha)
				#o indice ficará em $t1
				mul $t3, $t1, $t4
				add $t1, $t1, $t2
				add $t1, $t1, $t3
				
				#registradores sendo utilizados: $t0, $t1, $t4
				lw $t2, Array($t1)
				beq $t2, $t5, end_game
				sb $s1, Grid($s0)
			
				j loop_game_menu
			end_game:
				
				sb $s2, Grid($s0)
				jal printGrid
			
				li $v0, 10
				syscall 
		





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
				addi $t0, $t0, 4
				li $v0, 1
				lw $a0, Array($t0)
				syscall
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
				
				addi $t0, $t0, 1
				
				lb $a0, Grid($t0)
				li $v0, 11
				syscall
				
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
		li $t2, 20 #Limite do numero de bombas
		li $t1,1 #Registrador para guardar o numero 1
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
			beq $t4,$t0, loop_place_bombs# Se o valor de $t4 for igual ao $t0, um novo numero aleatório é calculado 
			sw $t1, Array($t0)#
			subi $t2, $t2, 1
			j loop_place_bombs
		out_place_bombs:
			jr $ra