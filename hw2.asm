########### Ryan Engel ############
########### Ryengel ################
########### 113150597 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl hash
hash:
  li $t2, 0
  loop1:
    lb $t1, 0($a0)
    beqz $t1, next
    add $t2, $t2, $t1
    addi $a0, $a0, 1
    j loop1
  next:
    move $v0, $t2
  jr $ra

.globl isPrime
isPrime:
  li $t1, 2
  beqz $a0, is_prime
  blt $a0, $t1, not_prime
  div $a0, $t1
  mfhi $t2
  beqz $t2, not_prime
  li $t3, 3
  
  loop2:
    mul $t4, $t3, $t3
    bgt $t4, $a0, is_prime
    div $a0, $t3
    mfhi $t5
    beqz $t5, not_prime
    addi $t3, $t3, 2
    j loop2
    
  is_prime:
    li $t6, 1
    move $v0, $t6
    jr $ra
    
  not_prime:
    li $t6, 0
    move $v0, $t6
    jr $ra

.globl lcm
lcm:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  
  jal gcd
  move $t2, $v0
  mul $t1, $a0, $a1
  div $t1, $t2
  mflo $t3
  move $v0, $t3
  
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $ra

.globl gcd
gcd:
  move $t0, $a0
  move $t1, $a1
  bgt $t0, $t1, a0_is_larger
  move $t2, $t1
  move $t1, $t0
  move $t0, $t2
  
  a0_is_larger:
    li $t2, 1
    loop3:
      blez $t2, end_loop
      div $t0, $t1
      mfhi $t2
      move $t0, $t1
      move $t1, $t2
      j loop3
    
  end_loop:
    move $v0, $t0
    jr $ra

.globl pubkExp
pubkExp:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  move $a1, $a0
  
  loop4:
    li $t1, 2
    sub $a1, $a1, $t1
    li $v0, 42
    syscall
    addi $a0, $a0, 2
    addi $a1, $a1, 2
    jal gcd
    move $t3, $v0
    li $t2, 1
    beq $t3, $t2, exit_loop
    j loop4
    
  exit_loop:
    move $v0, $a0
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

.globl prikExp
prikExp:
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal gcd
  move $t0, $v0
  li $t1, 1
  bne $t0, $t1, not_coprime

  move $t0, $a1
  li $t1, 1
  li $t2, 0
  li $t3, 1
  li $t4, 1
  li $t5, 1
  li $t6, 1
  li $t7, 0
  
  loop5:
    ble $t1, $0, exit
    div $t0, $a0
    mflo $t8
    mfhi $t1
    move $t0, $a0
    move $a0, $t1
    li $t9, 2
    
    blt $t7, $t9, next_line
    mul $t9, $t3, $t5
    sub $t4, $t2, $t9
    div $t4, $a1
    mfhi $t4
    move $t2, $t3
    move $t3, $t4
    
    next_line:
      move $t5, $t6
      move $t6, $t8
      addi $t7, $t7, 1
      j loop5

  exit:
    mul $t9, $t3, $t5
    sub $t4, $t2, $t9
    div $t4, $a1
    mfhi $t4
    bgt $t4, $0, skip  
    #if private key is negative, convert to equivalent positive value
    add $t4, $a1, $t4
  skip:
    move $v0, $t4
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
  not_coprime:
    li $t0, -1
    move $v0, $t0
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

.globl encrypt
encrypt:
  #save $ra, and $a0 in $sp
  addi $sp, $sp, -16
  sw $ra, 0($sp)
  sw $a0, 4($sp)  #m
  
  move $t2, $a1  #p
  move $t3, $a2  #q
  
  mul $t0, $t2, $t3  #n
  sw $t0, 8($sp)  #Store n in sp
  li $t1, 1
  sub $a0, $a1, $t1  #p-1
  sub $a1, $a2, $t1  #q-1
  jal lcm
  move $t1, $v0  #k
  move $a0, $t1
  
  jal pubkExp
  move $t2, $v0  #e
  
  #Test by hard coding the e value in next line
  #li $t2, 181
  sw $t2, 12($sp)  #store value of e in $sp
  
  lw $t4, 4($sp)  #m
  lw $t0, 8($sp)  #n
  div $t4, $t0
  mfhi $t5  #c
  li $t6, 1  #i
  lw $t2, 12($sp)  #e
  
  loop6:
    bge $t6, $t2, end_l
    mul $t5, $t5, $t4
    div $t5, $t0
    mfhi $t5
    addi $t6, $t6, 1
    j loop6
    
  end_l:
    move $v0, $t5
    move $v1, $t2
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra
    
.globl decrypt
decrypt:
  #save $ra, and $a0 in $sp
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $a0, 4($sp)  #c
  sw $a1, 8($sp)  #e
  
  move $t2, $a2  #p
  move $t3, $a3  #q
  
  mul $t0, $t2, $t3  #n
  sw $t0, 12($sp)  #Store n in sp
  li $t1, 1
  sub $a0, $a2, $t1  #p-1
  sub $a1, $a3, $t1  #q-1
  jal lcm
  move $t1, $v0  #k
  sw $t1, 16($sp)  #k
  lw $t2, 8($sp)  #e
  move $a0, $t2
  move $a1, $t1
  jal prikExp
  move $t3, $v0  #d
  
  lw $t4, 4($sp)  #c
  lw $t0, 12($sp)  #n
  div $t4, $t0
  mfhi $t5  #m
  li $t6, 1  #i
  
  loop7:
    bge $t6, $t3, end_ln
    mul $t5, $t5, $t4
    div $t5, $t0
    mfhi $t5
    addi $t6, $t6, 1
    j loop7
    
  end_ln:
    move $v0, $t5
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra
  
