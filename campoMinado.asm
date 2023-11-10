.data
	Array:
		.align 2
		.space 400
		
	nw_line: .asciiz"\n" 
	space_line: .asciiz "  "
	menu: .asciiz "====================Minesweeper=================="
	u_line: .asciiz "Insira a linha: "
	u_column: .asciiz "Insira a coluna: "
.text

	main:
		jal init_M
		
		li $t2, 20 #Limite do numero de bombas
		li $t1,1 #Registrador para guardar o numero 1
		move $t3, $zero # Inicio do indice do loop place_bombs
		loop_place_bombs:
			beq $t2,$t3,out_place_bombs #t$t2 vai ser um contador que irá realizar o loop 10x, para colocar 10 bombas
			jal randomInt_generator #gera um número aleatório
			move $t0,$a0 # esse numero é movido para $t0
			sll $t0, $t0, 2 #Então é multiplicado por 4
			
			lw $t4,Array($t0) #O Valor da posição $t0 é carregado para $t4
			beq $t4,$t0, loop_place_bombs# Se o valor de $t4 for igual ao $t0, um novo numero aleatório é calculado 
			sw $t1, Array($t0)#
			subi $t2, $t2, 1
			j loop_place_bombs
		out_place_bombs:
			

			
		game_menu:		
			loop_game_menu:
				li $s0, 1
				beq $t0, $s0, end_game	
				jal printArray
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
			
				j loop_game_menu
			end_game:
				li $v0, 10
				syscall 
		





	init_M:
		move $t0, $zero #indice
		move $t1, $zero #valor a ser colocado
		li $t2, 400 #tamanho matriz completa
		li $t3, 40 #tamanho linha
		while:
			beq $t2, $t0, out
			sw $t1, Array($t0)
			addi $t0, $t0, 4
			j while
			
		out:
			jr $ra
			
			
	printArray:
		move $t0, $zero #indice
		move $t1, $zero #valor a ser colocado
		li $t2, 400 #tamanho matriz completa
		li $t3, 40 #tamanho linha
		loop_printArray:
				beq $t0, $t2, out_print # se chegar em 400, vai para out_print
				beq $t0, $t3, print_line # se chegar em $t3, vai para print_line
				li $v0, 1
				lw $a0, Array($t0)
				syscall
				li $v0,4
				la $a0,space_line
				syscall 
				addi $t0, $t0, 4
				j loop_printArray
				
			print_line:
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
				j loop_printArray
			out_print:
				jr $ra
			
			
			
			
	randomInt_generator: 
		li $a1, 100  #Here you set $a1 to the max bound.
    		li $v0, 42  #generates the random number.
    		syscall
    		jr $ra
    		#add $a0, $a0, 100  #Here you add the lowest bound
