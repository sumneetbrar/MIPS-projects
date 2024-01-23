.data 

input:  .asciiz "Please enter a nonnegative integer."
comma:  .asciiz ", "
err: 	.asciiz "Try again."
.text
main: 
	li $v0, 4
	la $a0, input
	syscall				# prompt the user to enter a nonnegative integer
	
	li $v0, 5
	syscall				# read the nonnegative integer that the user enters
	
	move $t0, $v0			# move the input to $t0
	
	# $t0 holds the input value
	
	bgt $t0, -1, input0		# if input is less than 0, print an error message and exit. otherwise, branch to input0. 
		li $v0, 4
		la $a0, err
		syscall
		j exit
	
input0:					# if input value = 0, print 1 and exit. otherwise, branch to input 1. 
	bne  $t0, 0, input1		
		li $v0, 1
		li $a0, 1
		syscall
		j exit

input1: 				# if input value = 1, print 1 and decrement input by 1, jumping to input 0. otherwise, branch to next
	bne $t0, 1, next
		li $v0, 1
		li $a0, 1
		syscall
		li $v0, 4
		la $a0, comma
		syscall
		addi $t0, $t0, -1
		j input0
		
next:	
	addi $t2, $zero, 1		# 'variables' to help with math
	addi $t3, $zero, 1
	
	addi $t7, $t0, -1		# run loop n - 1 times. $t7 holds n - 1. 
	
 	ble $t0, 1, input1		# if input value > 1, do the following. otherwise, branch to input 1. 
 	
 		li $v0, 1
		li $a0, 1
		syscall
		li $v0, 4
		la $a0, comma
		syscall			# manually print the 1 for when n = 0.
		
		li $v0, 1
		li $a0, 1
		syscall
		li $v0, 4
		la $a0, comma
		syscall			# manually print the 1 for when n = 1.
		
loop:		bge $t1, $t7, exit			# if $t1 < (input - 1), run the loop. otherwise, exit.
			add $t4, $t3, $t2
			addi $t4, $t4, 1		# calculations
			
			li $v0, 1
			move $a0, $t4
			syscall				# print the value of $t4
						
			li $v0, 4
			la $a0, comma		
			syscall				# print a comma
			
			move $t3, $t2
			move $t2, $t4
			addi $t1, $t1, 1		# increment $t1 (index)
			
			
			j loop				# loop
			
exit: 	li $v0, 10
	syscall						# exit cleanly
		
