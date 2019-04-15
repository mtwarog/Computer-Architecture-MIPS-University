.data # Data declaration section
prompt: .asciiz "Enter an integer value\n"
promptResult: .asciiz "Calculated factorial: "

.text
main: # Start of code section
jal get_integer # Call procedure
move $s0, $v0 # position the parameters

li $s1, 1 # return var
li $t1, 0 # temp var counter for loop
move $t2, $s0 # exit condition
Loop:
    beq $t2, $t1, Exit #at $s0 we go to Exit, defined below
    addi $t1, $t1, 1 #increment counter
    mul $s1,$s1,$t1
    j Loop #jumps back to the top of loop
Exit:
li $v0, 4 # system call code for printing a
# string = 4
la $a0, promptResult # address of string is argument 0 to
syscall

move $a0, $s1 # copy factorial to argument reg
li $v0, 1 # system call code for print_int
syscall # print it

li $v0, 10 # terminate program
syscall

get_integer:
# Prompt the user to enter an integer value. Read and return
# it. It takes no parameters.
li $v0, 4 # system call code for printing a
# string = 4
la $a0, prompt # address of string is argument 0 to
# print_string
syscall # call operating system to perform
# print operation
li $v0, 5 # get ready to read in integers
syscall # system waits for input, puts the
# value in $v0
jr $ra # jump back to the return