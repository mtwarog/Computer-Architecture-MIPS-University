.data
inputVals: .asciiz "\nEnter integer values followed by return (0 terminates input): \n"
comma: .asciiz ","
bubble: .asciiz "Bubble Sort"
nextStep: .asciiz "--------Next Step--------"
lineBreak: .asciiz "\n"
seqSorted: .asciiz "\nSequence has been sorted\n"
.text 				
main:
	move $s0,$gp			#get the intial point to save array 
	addi $t0, $t0, 1			# $t0 = 1
	add $t1,$zero,$zero		
	add $t2,$zero,$zero		
	add $t3,$zero,$zero		
	add $t6,$zero,$zero        
	add $t4,$zero,$zero        
	sub $t7,$zero,$zero			# terminate        
	li $v0,4		# system call to put the string
	la $a0,inputVals		
	syscall		
	add $s1,$s0,$zero	# copy the pointer to array in $s1
	enterValues:
	li $v0,5		# get the value in v0 
	syscall		
	beq $v0,$t7,bubbleSort # end of string run to bubblesort
	sb $v0,0($s1)	# put the value at the position pointed by $s1
	addi $s1, $s1, 1		# move the $s1 pointer by one
	add $t5,$s1,$zero # $t5 stores the end value
	j enterValues
	end:
	li $v0,4		# system call to put the string
	la $a0,seqSorted		
	syscall		
	li $v0,5
	syscall	 
	
bubbleSort:
	add $t4,$s0,$zero
	addi $t6, $t6, 1
	#s1-1 -> s0
	sub $s1,$s1,$t0
	beq $s1,$s0,end  	# we have sorted everything
	#s0 -> s1
	add $s2,$s0,$zero
	internalLoop:
	lb $t1,0($s2)		# first element
	lb $t2,1($s2)		# second element
	slt $t3,$t2,$t1	 
	beq $t3,$zero,nextVal	# if $t2 > $t1 go to next value
	sb $t2,0($s2)		# else switch their position
	sb $t1,1($s2)		# $s2 is a pointer to element of array		
	nextVal:
	addi $s2, $s2, 1		
	bne $s2,$s1,internalLoop 
	li $v0,4		# system call to put the string
	la $a0,lineBreak		 
	syscall		
	li $v0,4		# system call to put the string
	la $a0,nextStep		 
	syscall		
	li $v0,4		# system call to put the string
	la $a0,lineBreak		 
	syscall		
	printSeq:
	li $v0,1
	lb $a0,0($t4)
	syscall
	li $v0,4
	la $a0,comma
	syscall		
	addi $t4, $t4, 1
	bne $t4,$t5,printSeq
jal bubbleSort	
