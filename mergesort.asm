.data
newline:	.asciiz	"\n"
integer: 	.asciiz "Please enter the number of elements you want in the array (between 0 and 1,000,000): "

arrayLength:	.space 4
array:		.space 4000004

.text
	li $v0, 4
	la $a0, integer
	syscall				# ask for the first integer
	li $v0, 5
	syscall 			# read the first integer
	move $s7, $v0			# store it
	addi $t0, $0, 0			# index for array
	sw $s7, arrayLength($a3)	# store in array length
	addi $t9, $0, 0			# index for loop
rand:	beq $t9, $s7, done
		addi $a1, $0, 10000	# upper limit
		addi $v0, $0, 42
		syscall			# generate a random number in $a0
		sw $a0, array($t0)	# store that num in the current position
		addi $t0, $t0, 4 	# increment position in array
		addi $t9, $t9, 1	# increment index for loop
		j rand			# repeat until desired length of elements
		

done:	la $a0, array			# load start address of array
	lw $t0, arrayLength		# load the length of the array
	sll $t0, $t0, 2			# calculate the size of elements
	add $a1, $a0, $t0		# calculate array end address
	jal sort			# jump to the sort function
	j exit 				# exit
	

# the sort function
sort:
	addi $sp, $sp, -16		# entry block - make room for 4 ints
	sw $ra, 0($sp)			# store end address
	sw $a0, 4($sp)			# store start address
	sw $a1, 8($sp)			# store return address
	
	sub $t0, $a1, $a0		# calculate difference between start and end address
	ble $t0, 4, end			# if only one item in array, end. otherwise, continue
	
		srl $t0, $t0, 3		# shift right three bits 
		sll $t0, $t0, 2		# shift left two bits
		add $a1, $a0, $t0	# add to find middle of array
		sw $a1, 12($sp)		# store this in stack 
	
	jal sort			# recurse on the first half
	
		lw $a0, 12($sp)		# load the middle address
		lw $a1, 8($sp)		# load the end address
	
	jal sort			# recurse on the second half
	
		lw $a0, 4($sp)		# load start address of array
		lw $a1, 12($sp)		# load middle address of array
		lw $a2, 8($sp)		# load end address of array
		
	jal merge			# call the merge function
	
end:				
	lw $ra, 0($sp)		# exit block - reset all values
	addi $sp, $sp, 16	# restore $sp
	jr $ra 			# return
	

# merge function

merge:
	addi $sp, $sp, -16		# entry block - make room for 4 ints
	sw $ra, 0($sp)			# store return address
	sw $a0, 4($sp)			# store start address
	sw $a1, 8($sp)			# store middle address
	sw $a2, 12($sp)			# store end address
	
	move $s0, $a0		# copy the first half address 
	move $s1, $a1		# copy the second address
	
loop:

	la $t0, 0($s0)			# load first pointer
	la $t1, 0($s1)			# load second pointer
	lw $t0, 0($t0)			# load first value
	lw $t1, 0($t1)			# load second value
	
	bgt $t1, $t0, continue 	# if first value is already less than second, continue. otherwise, need to swap.
	
	move $a0, $s1		# load space for element in array
	move $a1, $s0		# load space for address
swap:
	li $t0, 10			# load immediate 10
	ble $a0, $a1, send		# if we are at the end of the array, stop. 
	
		addi $t2, $a0, -4		# find the previous address in the array
		lw $t3, 0($a0)			# get current pointer
		lw $t4, 0($t2)			# get last pointer
		sw $t3, 0($t2)			# save the current pointer to previous address
		sw $t4, 0($a0)			# save the last pointer to the current address
		move $a0, $t2			# shift current position
		
	j swap				# loop again
send:
	addi $s1, $s1, 4		# increment index of second half
	
continue:

	addi $s0, $s0, 4		# increment index of first half
	lw $a2, 12($sp)			# load end address

	bge $s0, $a2, lend		# loop until first half of array has content
	
	bge $s1, $a2, lend		# loop until second half of array has content
	
	j loop
	
lend:
	
	lw $ra, 0($sp)			# exit block - reset variables
	lw $a0, 4($sp)			
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16		# reset $sp
	jr $ra				# return
	

exit: 

	li $t0, 0				# set index to 0		
	li $v0,10
	syscall	
	
					

									
																
