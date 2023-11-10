.data
str: .asciiz "Fall2022"

.text
main:
 #la $a0,str
 #jal hash

 #used for testing LCM
 #li $a0, 4
 #li $a1, 6
 #jal lcm
 #move $a0, $v0
 #li $v0, 1
 #syscall

#used for testing public key exp function
 #li $t3, 12
 #move $a0, $t3
 #jal pubkExp
 #move $a0, $v0
 #li $v0, 1
 #syscall

 #used for testing private key exp
 #li $a0, 119919
 #li $a1, 998777
 #jal prikExp
 #move $a0, $v0
 #li $v0, 1
 #syscall
 
 
#test encrypt function
 #li $a0, 52
 #li $a1, 107
 #li $a2, 131
 #jal encrypt
 #move $t9, $v0
 
 #move $a0, $v0
 #li $v0, 1
 #syscall
 
 #li $a0, 'A' 
 #li $v0, 11
 #syscall
 
 #move $a0, $v1
 #li $v0, 1
 #syscall
 
 #li $a0, 'A'
 #li $v0, 11
 #syscall
 
 
 #test decrypt function
 #move $a0, $t9
 #move $a1, $v1
 #li $a2, 107
 #li $a3, 131
 #jal decrypt
 #move $a0, $v0
 #li $v0, 1
 #syscall
 
 
 #test private key exp
 #li $a0, 119919
 #li $a1, 998777
 #jal prikExp
 #move $a0, $v0
 #li $v0, 1
 #syscall
 
 #test public key exp function
 #li $t3, 12
 #move $a0, $t3
 #jal pubkExp
 #move $a0, $v0
 #li $v0, 1
 #syscall
 
 #test LCM
 #li $a0, 382
 #li $a1, 8261
 #jal lcm
 
 #test GCD
 #li $a0, 9999
 #li $a1, 132
 #jal gcd
 #move $a0, $v0
 #li $v0, 1
 #syscall
 
 #test primality
 #li $a0, 77
 #jal isPrime

 li $v0,10
 syscall
 
.include "hw2.asm"
