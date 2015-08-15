# Name : Adnan Alvee

# How the Program Runs:
# Firstly, The user is asked about the size which has to be a size to the power of 2 and can go upto 32. After that user input is taken and each number is stored accordingly in the
# array called list. After that the loop starts, the size given is divided each time in the "mainLoop" until it reaches 1 to end the program, while being in the "mainLoop", the program
# goes to "InnerLoop", where each time in the innerloop, the amount of numbers to load is incremented by 2 as like first time is 2, second time 4 and continues depending on size. 
# From the InnerLoop whatever number to load is divided by the SPLITLIST arrays which means if number to load is 2, array name "splitList1" loads the first number from array "list" and "splitList2" 
# loads the second number. After loading the numbers in SplitList1 and SplitList2, merging takes place in merge. As the numbers are merged they are again stored back in the main list in INCREASING ORDER. The index
# of the list is then incremented. The merge keeps getting called depending on the size provided until the whole list is merged in INCREASING ORDER. 

#NOTE:
# In the code comments and label names, SPLITLIST 1 is termed as SL1 and SPLITLIST2 as SL2


.data
	sizeText: .asciiz "Please Enter Size of List(Must be to the power of 2...Upto 32): "
	valueInput: .asciiz "Now, Enter Integer"
	userText1: .asciiz "You Entered: "
	userText2: .asciiz "Enter Number: "
	MergedList: .asciiz "\nFinal Merged List: "
	SP: .asciiz " "
	NL: .asciiz "\n"
	MergeN: .asciiz "Merge "
	Colon: .asciiz ": "
	list: .space 128 # Array for a maximum of 32 Integers
	splitList1: .space 64 # Half of size of list for Merging 
	splitList2: .space 64 # Half of size of list for Merging	
	
	.globl main
.text
	main:
		
	#Ask user to Enter size of array
	li $v0, 4
	la $a0, sizeText
	syscall
	
	#Take user input
	li $v0, 5
	syscall
	
	#store user input in $t0
	move $t0, $v0
	
	#Show user Input :Text
	li $v0, 4
	la $a0, userText1
	syscall
	
	#print or show the input
	li $v0, 1
	move $a0, $t0
	syscall
	
	#Print NEW LINE
	li $v0, 4
	la $a0, NL
	syscall	
	
	#Initiate counters and offset
	move $s0, $zero
	move $t2, $zero		
		
	#Print NEW LINE
	li $v0, 4
	la $a0, NL
	syscall						
																	
	jal IntegerInput	
	
	IntegerInput: 
		beq $t0, $t2, printUserInput
		
		#prompt user for input
		li $v0, 4
		la $a0, userText2
		syscall
		
		#take input from user upto size limit
		li $v0, 5
		syscall
		
		#Store user input in register t3 from v0
		move $t3, $v0
		
		#store value of t3 in list at current index
		sb $t3, list($s0)
		
		addi $s0,$s0,4  #increment offset
		addi $t2,$t2,1  #increment counter
		
		j IntegerInput
			
		printUserInput:	
		#Print NEW LINE
		li $v0, 4
		la $a0, NL
		syscall	
				
		#DisplayText
		li $v0, 4
		la $a0, userText1
		syscall
		
		#Increment counter: make Register t2 initiate to 0
		move $t2, $zero
		move $s0, $zero # Set offset to zero Again
		
		jal while1
			
			while1:
			beq $t0, $t2, LoopInitializer
			lb $t4, list($s0) 
			
			#Show userinput
			li $v0, 1
			move $a0, $t4
			syscall
			
			#space
			li $v0, 4
			la $a0, SP
			syscall
			
			addi $t2,$t2,1 #increment counter
			addi $s0,$s0,4 #increment offset
			
			j while1
			
#////////////////----USER INPUT ENDS-----////////////----ALL NUMBERS LOADED IN LIST----////////////------LOOPING AND MERGING STARTS BELOW-----///////////////////////
		
		LoopInitializer:
		#------------New Line
		li $v0, 4
		la $a0, NL
		syscall
		#-------------------
					
		move $s0, $zero
		move $t4, $zero
		move $t3, $zero
		
		li $t1, 1 	# Counter for main loop
		move $t2, $t0 	# User Input Size
		li $t4, 1 	# Number to Load from Arrays. Increases Each Time in MainLoop
		li $t5, 1
		#Store in s2 the size of main list 
		move $t0, $t2

		jal mainLoop
	
	mainLoop:
		
	beq $t1, $t2, printText # Exit the program when register $t2 reaches 1 after getting divided by 2 each time in the loop.
	move $t3, $zero  # Initiate InnerLoop Counter to Zero
	div $t2,$t2, 2   # Divide User Given Size by 2
	
	move $s4, $zero #Initiate offset for list in Label "Merge"		
		
	bge $t2,$t1, innerLoop
			
			innerLoop:
			beq $t2, $t3, incrementArrayLoader # When inner Loop is reached, it increments the amount to load the next time through the loop depending on size
			li $s2, 0 # Initiate Counter for Loader 1 Loop
			li $s3, 0 # Initiate Counter for Loader 2 Loop
			move $t7, $zero # Initiate Offset for SplitList 1 to 0
			move $t6, $zero # Initiate Offset for SplitList 2 to 0
						
			addi $t3, $t3, 1 # Inner Loop Incrementer			
			
			jal loader1	
										
				incrementArrayLoader:
						#Print NEW LINE
						li $v0, 4
						la $a0, NL
						syscall	
						#Print Text
						li $v0, 4
						la $a0, MergeN
						syscall
						#Print Merge Number
						li $v0, 1
						move $a0, $t5
						syscall
						#Print Text
						li $v0, 4
						la $a0, Colon
						syscall
						
				sll $t4, $t4, 1 # Increment loader : Number to load from List in each Loop. Doubles each Time.
				move $s1, $zero # Set offset for list to 0 again
				addi $t5, $t5, 1 # Increment counter for indicating the merge
					#--------Initializing For print
					move $s3, $zero
					move $t9, $zero
					move $t8, $zero				
					#-------------------------*****
			
				jal printMerge
						
						printMerge:
						beq $s3, $t0 mainLoop #branch counter loop
						lb $t9, list($t8)
						#----------------------------------------------PRINT INITIAL MERGE
						#Print Number
						li $v0, 1
						move $a0, $t9
						syscall
						#Print Space
						li $v0, 4
						la $a0, SP
						syscall
						#---------------------------------------------------***********
						addi $t8, $t8, 4  #increment offset for list
						addi $s3, $s3, 1  #increment counter
				
						j printMerge								
												
				#------------------------Load Numbers in Split List 1 Array 
				loader1:
				beq $s2, $t4, loader2 # s2 is the counter for loader 1 loop
				lb $s0, list($s1)  # $s1 = offset for list
					
				sb $s0, splitList1($t6) 
					
				addi $s2, $s2, 1 # increment counter s2
				addi $s1, $s1, 4 # increment offset for list
				addi $t6, $t6, 4 # increment offset for Split List 1
				
				j loader1
				
				#------------------------Load Numbers in Split List 2 Array 
				loader2:
				beq $s3, $t4, merge # s3 is counter for loader 2 loop
				lb $s0, list($s1)  # $s1 = offset for list
					
				sb $s0, splitList2($t7) 
					
				addi $s3, $s3, 1 # increment counter s3
				addi $s1, $s1, 4 # increment offset for list
				addi $t7, $t7, 4 # increment offset for Split List 2
				j loader2
					   	#------------------------------------------------- MERGE BEGINS-------------------------------------------------------------
						merge:						
						li $s2, 0 # Set Counter to 0 for split list 1
						li $s3, 0 # Set Counter to 0 for split list 2
						move $t7, $zero # Initiate Offset for SplitList 1 to 0
						move $t6, $zero # Initiate Offset for SplitList 2 to 0
							
						jal while
						
							while:
							beq $s2, $t4 innerLoop  # if counter reached the number to load as stored in register $t4, go back to InnerLoop
							lb $s5, splitList1($t6) # Load current index at split list 1
								
							addi $s2, $s2, 1 # increment counter for while loop
							addi $t6, $t6, 4 # increment offset for split list 1
							   jal compare
							   
							   	compare:
							   	beq $s3, $t4 while  # if counter reached the number to load as stored in register $t4, go back to while
							   	lb $s6, splitList2($t7) # Load current index at split list 2							   	
							   	
							   	bge $s5, $s6 mergeIfGreater # If the value in SL1 is greater than the value in SL2		
							   						   	
							   	addi $s3, $s3, 1 # increment counter for while loop
							   	addi $t7, $t7, 4 # increment offset for split list 2
							   								   
							   	blt $s5, $s6 mergeIfLess # If the value in SL1 is less than the value in SL2	
							   		
							   			#-----------------------------------If Number at Current Index in Splitlist1 is greater than in SplitList2
							   			mergeIfGreater:
							   			sb $s5, list($s4)    # Store current value in list
							   			addi $s4, $s4, 4     #increment offset for list		
							   			
							   			beq $s2, $t4, storeLastfromSL2  # if counter of "while" loop reached go to label and store the last number in SL2
							   			j while
							   				storeLastfromSL2:
							   				sb $s6, list($s4) # Storing last number in SL2
							   				
											beq $t4, 1, ibeforeInnerLoop # If number to load in each of Split List arrays is 1, go back to innerloop
											addi $s3, $s3, 1 # increment counter for compare loop
											addi $t7, $t7, 4 # increment offset for SL2
											bne $s3, $t4 storeTheRestfromSL2 # if compare loop counter s3 not equals t4 then store the rest of the numbers in from SL2							   				
							   							   				
							   				storeTheRestfromSL2:
							   				beq $s3, $t4, ibeforeInnerLoop
							   			
							   				addi $s4, $s4, 4  # increment offset
							   				lb $s5, splitList2($t7) # load from SL2
							   				sb $s5, list($s4) # store in SL2
							   					
							   				addi $s3, $s3, 1 # increment counter 
							   				addi $t7, $t7, 4 # increment offset
							   				j storeTheRestfromSL2
										#-------------------------------------------------------*************************************************

							   			#-----------------------------------If Number at Current Index in Splitlist1 is less than in SplitList2
							   			mergeIfLess:
							   			sb $s6, list($s4) # store value from SL2 to list	
							   			addi $s4, $s4, 4 # increment offset			
							 
							   			beq $s3, $t4, storeLastfromSL1 # if counter at compare loop reached t4 then store the last number/numbers of SL1
							   			j compare
							   				
							   				storeLastfromSL1:
							   				sb $s5, list($s4) # Store value at SL1 in list
							   				
											beq $t4, 1, ibeforeInnerLoop	# if $t4(amount to load in SL1 and SL2) is only 1 then go back to InnerLoop										
											bne $s2, $t4,  storeTheRestfromSL1											
										
							   				storeTheRestfromSL1:
							   				beq $s2, $t4, ibeforeInnerLoop
							   			
							   				addi $s4, $s4, 4  # increment offset
							   				lb $s6, splitList1($t6)
							   				sb $s6, list($s4)
							   					
							   				addi $s2, $s2, 1 # increment counter 
							   				addi $t6, $t6, 4 # increment offset
							   				j storeTheRestfromSL1
							   				#------------------------------------------------------------**************************
							   				
							   #------------------------------------------Before going back to inner loop after storing Last Ones
							   #------------------------------------------increment the current index at list
							   ibeforeInnerLoop:
							   addi $s4, $s4, 4 # increment offset for list
							   jal innerLoop	
					   										   											
							
							printText:
							#Print NEW LINE
							li $v0, 4
							la $a0, NL
							syscall	
							#--------Print Merged Text
							li $v0, 4
							la $a0, MergedList
							syscall
							#------------******
							move $s3, $zero	
							move $t8, $zero
							
							jal printInitialMerges
								
						printInitialMerges:
						beq $s3, $t0 exit #branch counter loop
						lb $t9, list($t8)
						#----------------------------------------------PRINT INITIAL MERGE
						#Print Number
						li $v0, 1
						move $a0, $t9
						syscall
						#Print Space
						li $v0, 4
						la $a0, SP
						syscall
						#---------------------------------------------------***********
						addi $t8, $t8, 4  #increment offset for list
						addi $s3, $s3, 1  #increment counter
				
						j printInitialMerges	
	exit:
	li $v0, 10
	syscall
