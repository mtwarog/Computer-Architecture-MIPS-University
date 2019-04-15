.data # Data declaration section
promptA: .asciiz "Enter an integer a value\n"
promptB: .asciiz "Enter an integer b value\n"
promptC: .asciiz "Enter an integer c value\n"
promptD: .asciiz "Enter an integer d value\n"
promptResult: .asciiz "Calculated value of (a + b) - (c - d): "

.text
main: # Start of code section
jal get_integers # Call procedure
move $a0, $s0 # position the parameters
move $a1, $s1
move $a2, $s2
move $a3, $s3
jal calculations # Call procedure
move $s0, $v0 # return value will be in $v0
li $v0, 4 # system call code for printing a
# string = 4
la $a0, promptResult # address of string is argument 0 to
syscall

move $a0, $s0 # return value will be in $v0
li $v0, 1 # system call code for print_int
syscall # print it

li $v0, 10 # terminate program
syscall

get_integers:
# Prompt the user to enter an integer value. Read and return
# it. It takes no parameters.
li $v0, 4 # system call code for printing a
# string = 4
la $a0, promptA # address of string is argument 0 to
# print_string
syscall # call operating system to perform
# print operation
li $v0, 5 # get ready to read in integers
syscall # system waits for input, puts the
# value in $v0
move $s0, $v0
#get second int
li $v0, 4 
la $a0, promptB 
syscall 
li $v0, 5 
syscall 
move $s1, $v0 
#get third int
li $v0, 4 
la $a0, promptC 
syscall 
li $v0, 5 
syscall 
move $s2, $v0 
#get fourth int
li $v0, 4 
la $a0, promptD 
syscall 
li $v0, 5 
syscall 
move $s3, $v0 

jr $ra

calculations:
add $t0, $a0, $a1 # $t0 = a + b
sub $t1, $a2, $a3 # $t1 = c + d
sub $s0, $t0, $t1 # $s0 = (a + b) - (c - d)
move $v0, $s0 # put return value into $v0

jr $ra # jump back to the return
# address