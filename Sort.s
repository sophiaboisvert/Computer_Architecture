#Sophia Boisvert
#This program merges two ordered lists. It utilising a third area of memory to
#store the lists. The program merges the lists by comparing the data, until one
#list has no more data to add. It then adds the remainder of the unempty list
#The program moves through the first, second, and combined array by incrementing
#a address until it reaches the end. 

#Instructions: 	enter the ordered arrays below. Put the required amount of space for
#				finalarray 

#Register value meanings until printa: 	
#					$s0 	= 	list index for array 1
#					$s1 	= 	list index for array 2
#					$s2 	= 	index bound for array 1	[one word past end]
#					$s3		= 	index bound for array 2 [One word past end]
#					$s4		= 	list index for the final array
#					$t0		= 	stores result of logical comparisons
#					$a0		= 	the next item to be merged from array 1 	(or the argument to be printed out)
#					$t1		= 	the next item to be merged from array 2
#Label Meanings		step1 	= 	merging portion until one array is empty
#					add2	= 	storing the second array's value in the finalarray
#					first	= 	storing the remainder of the first array into the final array
#					second 	= 	storing the remainder of the second array into the final array

.data
space: .asciiz " "
array1: .word -3
		.word -1
		.word 1
		.word 3
array2: .word -2
		.word 0
		.word 2
		.word 4
		.word 5
finalarray: .space 36

.text

main:	la $s0, array1			#loads array 1 list counter
		la $s1, array2			#loads array 2 list counter
		la $s2, array2			#loads bound of array 1
		la $s3,	finalarray		#loads bound of array 2
		move $s4, $s3			#loads final array list counter
		
step1:	beq $s0, $s2, second	#if counter has passed the end of array1, jump to mergethe rest of the second array
		beq $s1, $s3, first		#if counter has passed the end of array2, jump to merge the rest of the first array
		
		lw $a0, 0($s0)			#load next number to be merged from array1
		lw $t1, 0($s1)			#load next number to be merged from array2	
		
		sgt $t0, $t1, $a0		#if item of array 2 > item of array1, $t0 = 1, else $t0 = 0
		beq $t0, $zero, add2	#if item of array 2 < item of array1, go to store the second array data, else continue and add the first array data
		
		sw	$a0, 0($s4)			#store the first array's number into the final array
		addi $s0, $s0, 4		#increment counter on array1
		addi $s4, $s4, 4		#increment counter on final array
		
		li $v0, 1				#print out the appended numer
		syscall
		li $v0, 4
		la $a0, space
		syscall
		j step1					#jump to step1
		
add2:	sw	$t1, 0($s4)			#store the second array's number into the final array
		addi $s1, $s1, 4		#increase counter on array2
		addi $s4, $s4, 4		#increment final array
		
		move $a0, $t1			#print out appended number
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, space
		syscall
		j step1					#jump to step1
		
first:	beq $s0, $s2, fin		#if reached the end of array1, go to print out final array
		lw $a0, 0($s0)			#load the next item to be appended
		sw	$a0, 0($s4)
		addi $s0, $s0, 4		#increase counter on array1
		addi $s4, $s4, 4		#increment final array
		
		li $v0, 1				#print out appended number
		syscall
		li $v0, 4
		la $a0, space
		syscall
		j first					#jump to first
		
second:	beq $s1, $s3, fin		#if reached the end of array2, go to print out final array
		lw $t2, 0($s1)			#load the next item to be appended
		sw	$t2, 0($s4)			#store the next item to be appended
		addi $s1, $s1, 4		#increase counter on array2
		addi $s4, $s4, 4		#increment final array
		
		move $a0, $t2			#print out appended number
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, space
		syscall
		j second				#jump to second

fin:	li $v0, 10				#exit program
		syscall