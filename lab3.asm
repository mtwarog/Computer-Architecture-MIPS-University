# Program reads coordinates of 2 vectors, 
# converts them to order, value form, 
# then calculate scalar product and prints the result
# int's are 4 bytes long
# max nuum of coord is 36
# returned scal prod: max 2^32

.data # Data declaration section
promptOrder: .asciiz "Enter an order of vectors\n"
promptVector: .asciiz " coordinate of Vector "
lineBreak:":\n"
promptResult: .asciiz "Calculated scalar product: "

#standarized form(max 36 coords):
#vec:  .word   0:36 # 36 ints of def value 0
#      .word   0:36 # 2nd vec
#order and values vectors:
#ordVec:  .word  0:36 # 1st vec
#         .word  0:36 # 2md vec
#valVec:  .word  0:36 # 1st vec
#         .word  0:36 # 2nd vec
         
#standarized form(max 36 coords):
vec:  .word   0:64 # 36 ints of def value 0
#order and values vectors:
ordVec:  .word  0:64 # 1st vec
valVec:  .word  0:64 # 1st vec

.text
main: # Start of code section

li $v0, 4 # system call code for printing a
# string = 4
la $a0, promptOrder # address of string is argument 0 to
syscall

li $v0, 5 # get ready to read in integers
syscall # system waits for input
move $s0, $v0 # save order in register

move $a0, $s0 # passing order as 1st arg
li $a1, 1 # passing vec num as 2nd arg
jal readVecCoords # jumps to func

move $a0, $s0 # passing order as 1st arg
li $a1, 2 # passing vec num as 2nd arg
jal readVecCoords # jumps to func

move $a0, $s0 # passing order as 1st arg
li $a1, 1 # passing vec num as 2nd arg
jal convertVec # jumps to func

move $a0, $s0 # passing order as 1st arg
li $a1, 2 # passing vec num as 2nd arg
jal convertVec # jumps to func

move $a0, $s0 # passing order as 1st arg
jal calculateScalProd # jumps to func

li $v0, 4 # system call code for printing a string
la $a0, promptResult # address of string is argument 0 to
syscall

li $v0, 1 # system call code for printing an int
move $a0, $v1 # copy scalar prod to arg 
syscall

li $v0, 10 # terminate program
syscall
readVecCoords:
# PETLA FOR BEG
li $t1, 0 # temp var counter for loop
move $t2, $a0 # exit condition(order num)
move $t3, $a1 # num of vec
la   $t4, vec # base address of the array
li   $t0, 2   # num of second vec
beq  $t3, $t0, SecVecAddrCoord # if vec num = 2, change coord addr
LoopCoord:
    beq $t2, $t1, ExitCoord #at $a0 we go to Exit, defined below
    addi $t1, $t1, 1 #increment counter
    # LOOP INSIDE BEG
    li $v0, 1 # system call code for printing an int
    move $a0, $t1 # copy actual coord num to arg 0
    syscall
    
    li $v0, 4 # system call code for printing a string
    la $a0, promptVector # address of string is argument 0 to
    syscall
    
    li $v0, 1 # system call code for printing an int
    move $a0, $t3 # copy vec num to arg 0
    syscall
    
    li $v0, 4 # system call code for printing a string
    la $a0, lineBreak # address of string is argument 0 to
    syscall

    li $v0, 5 # get ready to read an integer
    syscall # system waits for input
    
    # save readed value
    mul  $t5, $t1, 4     # $t5 is the offset
    add  $t6, $t5, $t4   # $t6 is the address of vec[$t1]
    move   $t7, $v0       # $t7 is the value to be put in vec[$t1]
    sw   $t7, ($t6)
    # LOOP INSIDE END
    j LoopCoord #jumps back to the top of loop
SecVecAddrCoord:
    addi $t4, $t4, 128 # change vec addr 288=36*8 to second vec
    j LoopCoord #jumps back to the top of loop
ExitCoord:
# PETLA FOR END
jr $ra # jump back to the return

convertVec:
# PETLA FOR BEG
li $t1, 0 # temp var counter for loop
move $t2, $a0 # exit condition(order num)
move $t3, $a1 # num of vec
la   $t4, vec # base address of the vec array
la   $t8, ordVec # base address of the ordVec array
la   $t9, valVec # base address of the valVec array
li   $t0, 2   # num of second vec
li   $s7, 1   # iterator for valVec
beq  $t3, $t0, SecVecAddrConv # if vec num = 2, change coord addr
LoopConv:
    beq $t2, $t1, ExitConv #at $a0 we go to Exit, defined below
    addi $t1, $t1, 1 #increment counter
    # LOOP INSIDE BEG
    mul  $t5, $t1, 4     # $t5 is the offset
    add  $t6, $t5, $t4   # $t6 is the address of vec[$t1]
    lw $t7, ($t6) # load coordinate
    bne $zero, $t7, SplitNonZero # if coord != 0 add val to valVec
    # split on zero - 0 is a default value in array
    # LOOP INSIDE END
    j LoopConv #jumps back to the top of loop
SplitNonZero:
    add  $t6, $t5, $t8   # $t6 is the address of ordVec[$t1]
    addi $t5, $zero, 1   # $t5 is 1 value
    sw   $t5, ($t6)
    mul  $t5, $s7, 4     # $t5 is the offset
    add  $t6, $t5, $t9   # $t6 is the address of valVec[$t1]
    sw   $t7, ($t6)
    addi $s7, $s7, 1 #increment counter
j LoopConv #jumps back to the top of loop
SecVecAddrConv:
    addi $t4, $t4, 128 # change vec addr (288=36*8) to second vec
    addi $t8, $t8, 128 # change ordVec addr (288=36*8) to second vec
    addi $t9, $t9, 128 # change valVec addr (288=36*8) to second vec
    j LoopConv #jumps back to the top of loop
ExitConv:
# PETLA FOR END
jr $ra # jump back to the return

calculateScalProd:
# PETLA FOR BEG
li $v1, 0 # initial val of scal prod
li $t1, 0 # temp var counter for loop
li $s6, 0 # valVec1 iterator
li $s5, 0 # valVec2 iterator
move $t2, $a0 # exit condition(order num)
la   $t3, ordVec # base address of the array
la   $t4, valVec # base address of the array
addi $t8, $t3, 128 # change ordVec addr to second valVec
addi $t9, $t4, 128 # change valVec addr to second valVec
LoopProd:
    beq $t2, $t1, ExitProd #at $a0 we go to Exit, defined below
    addi $t1, $t1, 1 #increment counter
    # LOOP INSIDE BEG
    mul  $t5, $t1, 4     # $t5 is the offset
    add  $t6, $t5, $t3   # $t6 is the address of ordvec[$t1]
    add  $t0, $t5, $t8   # $t6 is the address of ordvec[$t1]
    lw $t7, ($t6) # load coordinate
    lw $s7, ($t0) # load coordinate
    beq $t7, $zero, PastOne # if ordVec1 == 0 continue loop for next iter
    addi $s6, $s6, 1 #incrementing valVec1 iterator
    PastOne:
    beq $s7, $zero, LoopProd # if ordVec2 == 0 continue loop for next iter
    addi $s5, $s5, 1 #incrementing valVec2 iterator
    mul  $t5, $s6, 4     # $t5 is the offset
    add  $t6, $t5, $t4   # $t6 is the address of valvec[$t1]
    mul  $t5, $s5, 4     # $t5 is the offset
    add  $t0, $t5, $t9   # $t6 is the address of valvec[$t1]
    lw $t7, ($t6) # load coordinate
    lw $s7, ($t0) # load coordinate
    mul  $t7, $t7, $s7     # $t5 is the offset
    add  $v1, $v1, $t7   # $t6 is the address of vec[$t1]
    # LOOP INSIDE END
    j LoopProd #jumps back to the top of loop
ExitProd:
# PETLA FOR END
jr $ra # jump back to the return


