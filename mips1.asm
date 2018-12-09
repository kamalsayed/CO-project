 .data 
 Ex  : .asciiz "Exist in index : "
 Exnt: .asciiz "not Exist\n"
tab : .asciiz "		"
list: .word 5,7,8,2,9,1,4,15,3,10,11,12,13,14,6
Type : .asciiz  "for search Enter 1 , for sort enter 0\n"
Sear_val : .asciiz "Enter the Value you are searching for\n"
sort_t : .asciiz "for ascending sort enter 0 for descending sort enter 1\n"
.text 
.globl main
main :
	
	li $v0 , 4 #to print string
	la $a0 , Type #the string
	syscall
	li $v0,5 # to read the choice 
	syscall
	move $t0,$v0 # to store the choice into t0 reg
	la $a0 , list #first address of list 
	move $v1 , $a0
	bne  $t0 ,1 Sort
	jal Search
	add $s1 , $v1, $0
	add $s2 , $v0 ,$0
	beq $s1 , 0 , Not_exist
	j exist
	exist :
	li $v0 , 4 #to print string
	la $a0 , Ex #the string
	syscall
	beqz $s2 Zero
	div $s2 , $s2 , 4 
      Zero :	li $v0,1
   	move $a0 , $s2
	syscall
	j EXIT
	Not_exist :
	li $v0 , 4 #to print string
	la $a0 , Exnt #the string
	syscall
	j EXIT

Search:
	li $v0 , 4 #to print string
	la $a0 , Sear_val #the string
	syscall
	li $v0,5 # to read the choice 
	syscall
	move $t1,$v0 # to store the choice into t0 reg
	li $t0 , 0
	add  $t7 , $v1,$0
	loop:  
    	beq $t0,15 exit
    	sll $t2,$t0,2   #loop iteration *4
      add $t6, $t2, $t7 #4x array index in $t6
      lw $t5 , 0($t6)   #load list[index] into $t2
       bne $t1, $t5 , els
      addi $v1 , $zero,1
      add $v0 , $zero ,$t2
     jr $ra

els:

    addi $t0, $t0, 1

    j loop

exit:

    li $v1 , 0

    jr $ra

EndSearch:

Sort:
	la $v1 ,list
	li $v0 , 4 #to print string
	la $a0 , sort_t #the string
	syscall
	li $v0,5 # to read the choice 
	syscall
	move $t2 , $v0
	bne $t2 , 1 , Ascending
	jal  Descending
 
Descending:
	li $s0 ,0 #i counetr a0
	
	li $s1 ,0 #j counter a1
	
	li $s2, 0 #temp a2
	
	li $t0 ,15 #load size to subtract i from it
outer2:
	
        ble  $s0, 14 , inner2 # [0 -- > 14]
        j return2
  
   inner2 :
   	sll $t6,$s1,2 # index[j]=j*4	
   	add $t4 ,$v1 ,$t6 #get effective adress
   	lw $t1 ,0($t4)
   	lw $t2 ,4($t4)
   	slt $t9 , $t1 , $t2
   	beq $t9 , 1 ,inner2_else #a[j] < a[j+1]
   	#swap if  a[j] > a[j+1] if t9 =0
   	add $t8 , $t1 ,$0
   	add $t1 , $t2 ,$0
   	add $t2 , $t8 ,$0
   	sw $t1 ,0($t4)
   	sw $t2 ,4($t4)
   	inner2_else: # to incr and back to inner loop
   	addi $s1 , $s1 , 1
   	sub $t8,$t0,$s0
   	ble $s1,$t8, inner2#if we reached j< size -i end of inner
   	outer2_else:  
   		addi $s0 , $s0 ,1
   		li $s1 ,0
   		jal outer2
   		
   return2:
   	   li $t0 , 14
   	   li $t3 , 0
   	   div  $s5 , $t0 , 2
   FOR2:
        
   	bge  $t0 , $s5, L2
   	j return1
   L2:	sll $t6 , $t0 ,2 #index *4
   	add $s3 ,$v1 ,$t6
   	sll $t7 , $t3 ,2 #index *4
   	add $s4 ,$v1 ,$t7
   	lw $s1 , 0($s3)
   	lw $s2,0($s4)
   	sw $s1 , 0($s4)
   	sw $s2 , 0($s3)
   	addi $t0 , $t0,-1 
   	addi $t3 , $t3 , 1
   	j  FOR2
   END_FOR2:		
	
	
	
	
   		
Ascending :#note array in s0 reg
  	li $s0 ,0 #i counetr a0
	
	li $s1 ,0 #j counter a1
	
	li $s2, 0 #temp a2
	
	li $t0 ,15 #load size to subtract i from it
outer1:
	
        ble  $s0, 14 , inner1 # [0 -- > 14]
        j return1
  
   inner1 :
   	sll $t6,$s1,2 # index[j]=j*4	
   	add $t4 ,$v1 ,$t6 #get effective adress
   	lw $t1 ,0($t4)
   	lw $t2 ,4($t4)
   	slt $t9 , $t1 , $t2
   	beq $t9 , 1 ,inner1_else #a[j] < a[j+1]
   	#swap if  a[j] > a[j+1] if t9 =0
   	add $t8 , $t1 ,$0
   	add $t1 , $t2 ,$0
   	add $t2 , $t8 ,$0
   	sw $t1 ,0($t4)
   	sw $t2 ,4($t4)
   	inner1_else: # to incr and back to inner loop
   	addi $s1 , $s1 , 1
   	sub $t8,$t0,$s0
   	ble $s1,$t8, inner1#if we reached j< size -i end of inner
   	outer1_else:  
   		addi $s0 , $s0 ,1
   		li $s1 ,0
   		jal outer1
   		
   		
   return1:
   	   li $t0 , 0
   FOR :
   	ble  $t0 , 14, L
   	j EXIT
   L:	sll $t6 , $t0 ,2 #index *4
   	add $s3 ,$v1 ,$t6
   	li $v0,1
   	lw $a0 ,0($s3)
   	syscall
   	li $v0 , 4
   	la $a0 ,tab
   	syscall 
   	addi $t0 , $t0,1 
   	j  FOR
   END_FOR:	
   
   	
   	
   			
   				
   						
  
	
EndSort:


EXIT:

