	.data
array:	.space 20
newLine: .asciiz "\n"

	.text
main:	la	$s1, array	# loads the address of the array into a register

	li	$t0, 1
	sw	$t0, 0($s1)	# stores 1 in array[0]
	li	$t0, 2
	sw	$t0, 4($s1)	# stores 2 in array[1]
	li	$t0, 3
	sw	$t0, 8($s1)	# stores 3 in array[2]
	li	$t0, 4
	sw	$t0, 12($s1)	# stores 4 in array[3]
	li	$t0, 5
	sw	$t0, 16($s1)	# stores 5 in array[4]

	lw $t0,0($s1)
	lw $t1,8($s1)
	sub $t0,$t1,$t0 	
	sw $t0,0($s1)		# subtracts array[0] from array[2] and stores it in array[0]
	
	lw $t0,0($s1)
	lw $t1,8($s1)
	lw $t2,16($s1)
	add $t2,$t0,$t2 
	add $t2,$t1,$t2		
	sw $t2,16($s1)		# adds array[0], array[2], and array[4], storing the result in array[4]

	lw $t0,4($s1)
	lw $t1,12($s1)
	or $t0,$t0,$t1		
	sw $t0,4($s1)		# bitwise-or array[1] with array[3], storing the result in array[1]

	lw $t0,4($s1)
	sll $t0,$t0,2		
	sw $t0,4($s1)		# shift-left array[1] by 2, storing the result in array[1]

	lw $t0,4($s1)
	lw $t1,12($s1)
	andi $t1,$t0,21		
	sw $t1,12($s1)		# bitwise-and array[1] with 21, storing the result in array[3]

	lw $t0,8($s1)
	lw $t1,16($s1)
	not $t0,$t1		
	sw $t0,8($s1)		# bitwise-invert array[4], storing the result in array[2]
	
	

	lw $t0,0($s1)
	li $v0,1
	move $a0,$t0
	syscall			# print the value of array[0]
	
	li $v0,4
	la $a0,newLine
	syscall			# print a new line

	lw $t0,4($s1)
	li $v0,1
	move $a0,$t0
	syscall			# print the value of array[1]
	
	li $v0,4
	la $a0,newLine
	syscall			# print a new line
	
	lw $t0,8($s1)
	li $v0,1
	move $a0,$t0
	syscall			# print the value of array[2]
	
	li $v0,4
	la $a0,newLine
	syscall			# print a new line
	
	lw $t0,12($s1)
	li $v0,1
	move $a0,$t0
	syscall			# print the value of array[3]
	
	li $v0,4
	la $a0,newLine
	syscall			# print a new line
	
	lw $t0,16($s1)
	li $v0,1
	move $a0,$t0
	syscall			# print the value of array[4]

exit:	li $v0,10
	syscall         	# exit cleanly
