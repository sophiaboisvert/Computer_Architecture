#Sophia Boisvert
#Registers
#		$s0 -> contains the number of integers in the list
#		$s1 -> contains the size of the sublists to be merged
#		$s2 -> points to beginning of active list
#		$s3 -> points to beginning of list to save to
#		$t0 -> acts a pointer of the list	
#		$t1 -> first sublist beginning
#		$t2 -> second sublist beginning
#		$t3	-> first sublist end
#		$t4	-> second sublist end


#in merge function
#		$s4 -> points to the printing array
#		$t5-> the next item to be merged from array 1 
#		$t6 -> the next item to be merged from array 2

	.data
list: 		.space 128
list2: 		.space 128
prompt: 	.asciiz "Enter the number of integers in the list: "
prompt2: 	.asciiz "Enter the number: "
blank: 		.asciiz " "

	.text
main:	
	li $v0, 4				#read in the number of integers in the list
	la $a0, prompt		
	syscall
	li $v0, 5
	syscall
	sll $s0, $v0, 2		#$s0 <- $v0
	add $t0, $0, 0		#$t0 <- 0
	
read:
	li $v0, 4				#read in the next integer in the list
	la $a0, prompt2
	syscall
	li $v0, 5
	syscall
	sw $v0, list($t0)		#store new integer
	addi $t0, $t0, 4		#$t0 <- $t0 + 4 increment the pointer
	bne $t0, $s0, read		#check if at the end of the list

	li $s1, 2				#$s1 <- 2 	set size of the first set of sublist	

	la $s3, list
	la $s2, list2
	
sublists:					
	sll $s1, $s1, 1			#$s1 <- 2*$s1 	double size of the sublists
	beq $s1, $s0, print 	#if size of sublists is the whole list
	
	add $s5, $s2, $0		#switch active and inactive lists
	add $s2, $s3, $0
	add $s3, $s5, $0
	add $s4, $s3, $0

	add $t1, $s2, 0			#$t1 <- head of first sublist
	add $t2, $t1, $s1		#$t1 <- head of second sublist
	add $t3, $t2, $0
	add $t4, $t2, $s1
	
shift:
	jal merge				#go to merge the sublists

	add $t1, $t4, $0		#shift the sublists to the next set
	add $t2, $t1, $s1		
	add $t3, $t2, $0
	add $t4, $t2, $s1	
	add $t0, $s2, $s0
	
	beq $t1, $t0, sublists	#check if at the end
	
	j shift

print:						#print out the list
	add $s0, $s0, $s3
loop:
	li $v0, 4
	la $a0, blank
	syscall
	lw $a0, 0($s3)
	li $v0, 1
	syscall
	addi $s3, $s3, 4
	bne $s3, $s0,  loop
	
	li $v0, 10			#exit the program
	syscall
	
merge: 
	beq $t1, $t3, second	#if counter has passed the end of array1, jump to merge the rest of the second array
	beq $t2, $t4, first		#if counter has passed the end of array2, jump to merge the rest of the first array
	
	lw $t5, 0($t1)			#load next number to be merged from array1
	lw $t6, 0($t2)			#load next number to be merged from array2	
	
	sgt $t0, $t6, $t5		#if item of array 2 > item of array1, $t0 = 1, else $t0 = 0
	beq $t0, $zero, add2	#if item of array 2 < item of array1, go to store the second array data, else continue and add the first array data
	
	sw	$t5, 0($s4)			#store the first array's number into the final array
	addi $t1, $t1, 4		#increment counter on array1
	addi $s4, $s4, 4		#increment counter on final array
	j merge					#jump to merge
	
add2:	
	sw	$t6, 0($s4)			#store the second array's number into the final array
	addi $t2, $t2, 4		#increase counter on array2
	addi $s4, $s4, 4		#increment final array
	j merge					#jump to merge
	
first:	
	beq $t1, $t3, fin		#if reached the end of array1, go to print out final array
	lw $t5, 0($t1)			#load the next item to be appended
	sw	$t5, 0($s4)
	addi $t1, $t1, 4		#increase counter on array1
	addi $s4, $s4, 4		#increment final array	
	j first					#jump to first
	
second:	
	beq $t2, $t4, fin		#if reached the end of array2, go to print out final array
	lw $t6, 0($t2)			#load the next item to be appended
	sw	$t6, 0($s4)			#store the next item to be appended
	addi $t2, $t2, 4		#increase counter on array2
	addi $s4, $s4, 4		#increment final array
	j second				#jump to second
	
fin:
	jr $ra