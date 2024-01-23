.data
integer: .asciiz "Please enter an integer: "
operator: .asciiz "Please enter an operation (+,-,*,/): "
error: .asciiz "I'm sorry, you cannot divide by zero."
overflow: .asciiz "I'm sorry, that would overflow."
remainder: .asciiz " r "
thank: .asciiz "Thank you. "

.text

	main:
	
	# prompt the user for two integers and an operator
	# read the inputs and store them
	
	li $v0, 4
	la $a0, integer
	syscall					# ask for the first integer
	li $v0, 5
	syscall 				# read the first integer
	move $s0, $v0				# store it in $s0
	
	li $v0, 4
	la $a0, operator
	syscall					# ask for the operator
	li $v0, 12
	syscall 				# read the operator
	move $s1, $v0				# store the operator in $s1
	
	li $v0, 4
	la $a0, integer
	syscall					# ask for second integer
	li $v0, 5
	syscall					# read the second integer
	move $s2, $v0				# store it in $s2
	
	# inputs did not create error, so we can continue
	
		
	# store operator values in registers. 
	li $t1, '+'					# store the '+' operator in $t1
	li $t2, '-'					# store the '-' operator in $t2
	li $t3, '*'					# store the '*' operator in $t3
	li $t4, '/'					# store the '/' operator in $t4
	
	# if operator is +, check for overflow. if it does not overflow, find the sum, print and exit.
	
addition:	bne $s1, $t1, subtract			# check if operator is '+'. branch to subtraction if not. otherwise:
			jal isAddOverflow		# check for overflow.
			beqz $v0, sum 			# if overflowed, print error and exit. otherwise, continue
				li $v0, 4	
				la $a0, overflow	# print error message
				syscall			
				j exit			# exit
				
sum:			add $t0, $s0, $s2		# add the two integers
			li $v0, 4
			la $a0, thank
			syscall				# print Thank you.
			li $v0, 1
			move $a0, $s0
			syscall				# first int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '+'
			syscall				# plus
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $s2
			syscall				# second int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '='
			syscall				# equals
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $t0
			syscall				# print the result and exit
			j exit				
		
	# do the same for the other 3 operators. 
	
subtract:	bne $s1, $t2, multiply			# check if operator is '-'. branch to multiplication if not. otherwise:
			jal isSubOverflow		# check for overflow.
			beqz $v0, minus			# if overflowed, print error and exit. otherwise, continue
				li $v0, 4
				la $a0, overflow	# print error message
				syscall
				j exit			# exit
				
minus:			sub $t0, $s0, $s2		# subtract the two integers
			li $v0, 4
			la $a0, thank
			syscall				# print Thank you.
			li $v0, 1
			move $a0, $s0
			syscall				# first int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '-'
			syscall				# subtract
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $s2
			syscall				# second int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '='
			syscall				# equals
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $t0
			syscall				# print the result and exit
			j exit			
		
multiply:	bne $s1, $t3, divide			# check if operator is '*'. branch to multiplication if not. otherwise:
			jal isMulOverflow		# check for overflow. 
			beqz $v0, multi			# if equal to 0, no overflow: branch. otherwise, print error and exit.
				li $v0, 4
				la $a0, overflow
				syscall 		# print overflow message and exit
				j exit			
multi:			mult $s0, $s2			# multiply the two integers the two integers
			mflo $t0			# obtain the 32-bit answer
			li $v0, 4
			la $a0, thank
			syscall				# print Thank you.
			li $v0, 1
			move $a0, $s0
			syscall				# first int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '*'
			syscall				# multiply
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $s2
			syscall				# second int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '='
			syscall				# equals
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $t0
			syscall				# print the result and exit
			j exit		
			
		# for division, must print both quotient and remainder. 
		# also checking for division by 0.
			
divide:		bne $s1, $t4, exit			# check if operator is /. branch to divsion if not. otherwise:
			jal isDivOverflow		# check for overflow.
			beqz $v0, next			# if overflowed, exit. otherwise, continue
				li $v0, 4
				la $a0, overflow
				syscall 		# print error message and exit
				j exit
next:			jal divByZero			# check for division by zero.
			beq $v0, $0, continue		# branch if 0 (false). if 1 (true), print error and exit
				li $v0, 4
				la $a0, error
				syscall
				j exit
continue:						# if second int not 0, proceed as normal. 
			div $s0, $s2			# divide the two integers
			mflo $t0			# move the quotient into $t0
			mfhi $t7			# move the remainder into $t7
			li $v0, 4
			la $a0, thank
			syscall				# print Thank you.
			li $v0, 1
			move $a0, $s0
			syscall				# first int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '/'
			syscall				# divide
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $s2
			syscall				# second int
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 11
			li $a0, '='
			syscall				# equals
			li $v0, 11
			la $a0, 32
			syscall				# space
			li $v0, 1
			move $a0, $t0		
			syscall				# print the quotient
			li $v0, 4
			la $a0, remainder		
			syscall				# print the letter r	
			li $v0, 1
			move $a0, $t7
			syscall				# print the remainder and exit
			j exit
	
	
	# exit cleanly
exit:	li $v0, 10
	syscall
	
	
isAddOverflow:	xor $t0, $s0, $s2			# compare signs
		bgez $t0, check				# branch if same
			move $v0, $0			# return 0 (false)
			jr $ra				
check:		addu $t0, $s0, $s2			# add operands
		xor $v0, $t0, $s0			# compare signs
		srl $v0, $v0, 31			# return sign bit
		jr $ra
		
isSubOverflow:	xor $t0, $s0, $s2			# compare signs
		blez $t0, check2			# branch if opposite
			move $v0, $0			# return 0 (false)
			jr $ra				
check2:		subu $t0, $s0, $s2			# subtract operands
		xor $v0, $t0, $s0			# compare signs
		srl $v0, $v0, 31			# return sign bit
		jr $ra

isMulOverflow:	mult $s0, $s2
		mfhi $t5				# store hi value in $t5 
		mflo $t6				# store lo value in $t6
		addi $t8, $0, -1    
		bne $t5, $0, check3			# check if hi is 0 or -1. if not, it overflows.
			j check4
check3:		bne $t5, $t8, check5
check4:			xor $t0, $t5, $t6		# compare signs to see if first 33 bits match
			bgtz $t0, check5		# if $t0 is less than 0, no overflow.
				move $v0, $0
				jr $ra			# did not overflow. return 0 (false)
check5:		multu $s0, $s2				# multiply unsigned operands
		mflo $t0
		xor $v0, $t0, $s0			# compare signs with result
		srl $v0, $v0, 31			# return sign bit
		jr $ra
		


isDivOverflow:	# overflow only occurs when dividing the maximum negative value by -1. only need to check for that
		addi $t8, $0, -2147483648		# store maximum negative value
		addi $t9, $0, -1			# store -1 
		bne $s0, $t8, check6			# check if first integer is equal to maximum negative value
		bne $s2, $t9, check6			# check if second int is -1
			srl $v0, $v0, 31		# if true, means overflow. return 1 (true)
			jr $ra		
check6:		move $v0, $0
		jr $ra

divByZero:	beqz $s2, true				# branch if second integer is equal to 0
			move $v0, $0			# if not, return 0 (false)
			jr $ra
true:		addi $t0, $0, 1
		move $v0, $t0
		jr $ra 					# return 1 if true
	

	
	
	
	
	
	
	
	
