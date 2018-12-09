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
	move $v1 , $a0 # to copy array address
	bne  $t0 ,1 Sort #if choice is 1 goto sort else goto search and link to get return
	jal Search # jump to search function
	add $s1 , $v1, $0 # the returned values from search v1 is flag if exist = 1 else = 0
	add $s2 , $v0 ,$0 # v0 returned from search with the index in the array if the key exists
	beq $s1 , 0 , Not_exist # if existence  flag  =0  goto not exist
	j exist # else goto exist we can delete this jump casus next line is exist function
	exist :
	li $v0 , 4 #to print string
	la $a0 , Ex #the string is "exist "
	syscall
	beqz $s2 Zero # to get the index we need to divide by four, indexes from 1 to the end and if zero don't need to do that
	div $s2 , $s2 , 4 #div ndex by four
        Zero :	
	li $v0,1  # hereto print the number
   	move $a0 , $s2
	syscall
	j EXIT # EO program
	Not_exist :
	li $v0 , 4 #to print string
	la $a0 , Exnt #the string
	syscall
	j EXIT # EO program

Search:
	li $v0 , 4 #to print string
	la $a0 , Sear_val #the string
	syscall
	li $v0,5 # to read the key
	syscall
	move $t1,$v0 # to store the key into t1 reg
	li $t0 , 0 # i counter
	add  $t7 , $v1,$0 # to store array start address in $t7
	loop:  
       beq $t0,15 exit # if counter reached the last index of array without finding the key
       sll $t2,$t0,2   #loop iteration *4 (i*4)
       add $t6, $t2, $t7 #4x array index in $t6 to store the index address in memory
       lw $t5 , 0($t6)   #load list[index] value into $t5
       bne $t1, $t5 , els # if the value of the current index != key  goto i++
       addi $v1 , $zero,1 # if the value of the current index == key set the v1 with 1
       add $v0 , $zero ,$t2 # save the index in $v0
       jr $ra # return value to the main function

els:

    addi $t0, $t0, 1 # i++

    j loop # back to loop

exit:

    li $v1 , 0 # end of loop and the key not found

    jr $ra

EndSearch: # unreachable but exists to make a block

Sort:
	#la $v1 ,list
	li $v0 , 4 #to print string
	la $a0 , sort_t #the string
	syscall
	li $v0,5 # to read the choice 
	syscall
	move $t2 , $v0 # to store type of sort in t2
	
	li $s0 ,0 #i counetr =0 in a0 
	
	li $s1 ,0 #j counter =0 in a1
	
	li $s2, 0 #temp =0 in a2
	
	li $t0 ,15 #load size to subtract i counter in inner loop from it
	
	bne $t2 , 1 , Ascending# if type of  search = 0 goto ascending
	jal  Descending # else goto Descending
 	
Ascending :#note array in s0 reg
		
outer1: # outer loop
        ble  $s0, 14 , inner1 # [0 -- > 14] for i <15
        j return1 # if i counter == size goto return 1
  
   inner1 : # inner loop
   	sll $t6,$s1,2 # index[j]=j*4	
   	add $t4 ,$v1 ,$t6 #get effective adress (first index + j*4)
   	lw $t1 ,0($t4) #A[j]
   	lw $t2 ,4($t4) #A[j+1]
   	slt $t9 , $t1 , $t2 # if A[j] < A[j+1] set t9 =1 else t9 =0
   	beq $t9 , 1 ,inner1_else #a[j] < a[j+1] don't swap already sorted in this iteration
   	#swap if  a[j] > a[j+1] if t9 =0
   	sw $t1 ,4($t4) #a[j+1]=a[j]
   	sw $t2 ,0($t4)#a[j] = a[j+1]
   	inner1_else: # to incr and back to inner loop
   	addi $s1 , $s1 , 1 # j++
   	sub $t8,$t0,$s0  
   	ble $s1,$t8, inner1#if we reached j< size -i end of inner
   	outer1_else:   # if inner iteration ended
   		addi $s0 , $s0 ,1 # i++
   		li $s1 ,0 	# j = 0
   		jal outer1      #goto outer
   		
   		
Descending: # we will sort Asending then resort it to be Desending in return2 function

outer2: #outer loop
	
        ble  $s0, 14 , inner2 # [0 -- > 14]
        j return2 #  if outer loop finished goto reurn 2
  
   inner2 :
   	sll $t6,$s1,2 # index[j]=j*4	
   	add $t4 ,$v1 ,$t6 #get effective adress
   	lw $t1 ,0($t4) #A[j]
   	lw $t2 ,4($t4) #A[j+1]
   	slt $t9 , $t1 , $t2 #if A[j] < A[j+1] set t9 =1 else t9 =0
   	beq $t9 , 1 ,inner2_else #a[j] < a[j+1]
   	#swap if  a[j] > a[j+1] if t9 =0
   	sw $t1 ,4($t4) #a[j+1]=a[j]
   	sw $t2 ,0($t4) #a[j] = a[j+1]
   	inner2_else: # to incr and back to inner loop
   	addi $s1 , $s1 , 1 # j++
   	sub $t8,$t0,$s0  #size -i in t8
   	ble $s1,$t8, inner2#if we reached j< size -i end of inner
   	outer2_else:   # if inner iteration ended
   		addi $s0 , $s0 ,1 # i++
   		li $s1 ,0 # j =0 
   		jal outer2
   		
   return2: # function to change assending  sorted array to descending
   	   li $t0 , 14 # j= size -1
   	   li $t3 , 0 # i=0
   	   div  $s5 , $t0 , 2 # to get number of iteations last index /2
   FOR2: # loop to reverse sorted array
   	bge  $t0 , $s5, L2 #if  j > last index /2 goto swap start
   	j return1 #else goto return 1 to print the arrray
   L2:	sll $t6 , $t0 ,2 #index *4 for j*4 
   	add $s3 ,$v1 ,$t6 # to get the index address in memory A[j]
   	sll $t7 , $t3 ,2 #index *4 for i *4
   	add $s4 ,$v1 ,$t7 # to get the index address in memory A[i]
   	lw $s1 , 0($s3) # a[j] value in $s1
   	lw $s2,0($s4) # a[i] value in $s2
   	# SWAP
   	sw $s1 , 0($s4) # a[j]=a[i]
   	sw $s2 , 0($s3) # a[i] = a[j]
   	addi $t0 , $t0,-1  #j--
   	addi $t3 , $t3 , 1 # i++
   	j  FOR2
   END_FOR2:	# unsable but for block	
		
   return1: # loop function to print
   	   li $t0 , 0 # i =0
   FOR :
   	ble  $t0 , 14, L # if i < size [0 -> 14] # print 
   	j EXIT # else Exit
   L:	sll $t6 , $t0 ,2 #index *4
   	add $s3 ,$v1 ,$t6 # effective address iteration *4 + start address of array
   	li $v0,1 # print integer value from array 
   	lw $a0 ,0($s3) 
   	syscall
   	li $v0 , 4 # print tab 
   	la $a0 ,tab
   	syscall 
   	addi $t0 , $t0,1  # i++
   	j  FOR
   END_FOR:		
EndSort:
EXIT:
